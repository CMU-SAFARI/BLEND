#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#define __STDC_LIMIT_MACROS
#include "kvec.h"
#include "mmpriv.h"

unsigned char seq_nt4_table[256] = {
	0, 1, 2, 3,  4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,
	4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,
	4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,
	4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,
	4, 0, 4, 1,  4, 4, 4, 2,  4, 4, 4, 4,  4, 4, 4, 4,
	4, 4, 4, 4,  3, 3, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,
	4, 0, 4, 1,  4, 4, 4, 2,  4, 4, 4, 4,  4, 4, 4, 4,
	4, 4, 4, 4,  3, 3, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,
	4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,
	4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,
	4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,
	4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,
	4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,
	4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,
	4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,
	4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4
};
typedef struct { uint64_t x, y; uint32_t i; uint16_t k; } b176_t;

static inline uint64_t hash64(uint64_t key, uint64_t mask){
	key = (~key + (key << 21)) & mask; // key = (key << 21) - key - 1;
	key = key ^ key >> 24;
	key = ((key + (key << 3)) + (key << 8)) & mask; // key * 265
	key = key ^ key >> 14;
	key = ((key + (key << 2)) + (key << 4)) & mask; // key * 21
	key = key ^ key >> 28;
	key = (key + (key << 31)) & mask;
	return key;
}

typedef struct { // a simplified version of kdq
	int front, count;
	int a[32];
} tiny_queue_t;

static inline void tq_push(tiny_queue_t *q, int x)
{
	q->a[((q->count++) + q->front) & 0x1f] = x;
}

static inline int tq_shift(tiny_queue_t *q)
{
	int x;
	if (q->count == 0) return -1;
	x = q->a[q->front++];
	q->front &= 0x1f;
	--q->count;
	return x;
}

/**
 * Find symmetric (w,k)-minimizers on a DNA sequence
 *
 * @param km     thread-local memory pool; using NULL falls back to malloc()
 * @param str    DNA sequence
 * @param len    length of $str
 * @param w      find a BLEND value for every $w consecutive k-mers
 * @param k      k-mer size
 * @param n_neighbors should BLEND use minimizers or not. If so, the number tells how many neighbor k-mers should be blended. E.g., if 3, then take 1 minimizer and 2 preceding k-mers to calculate the hash value of a seed
 * @param rid    reference ID; will be copied to the output $p array
 * @param is_hpc homopolymer-compressed or not
 * @param p      minimizers
 *               p->a[i].x = kMer<<14 | kmerSpan
 *               p->a[i].y = rid<<32 | lastPos<<1 | strand
 *               where lastPos is the position of the last base of the i-th minimizer,
 *               and strand indicates whether the minimizer comes from the top or the bottom strand.
 *               Callers may want to set "p->n = 0"; otherwise results are appended to p
 */
void mm_sketch_minimizer_blend(void *km,
                               const char *str,
                               int len,
                               int w,
                               int blend_bits,
                               int k,
                               int n_neighbors,
                               uint32_t rid,
                               int is_hpc,
                               mm128_v *p){
    
    assert(len > 0 && (w > 0 && w+k < 8192) && (k > 0 && k <= 28) && (n_neighbors > 0 && n_neighbors+k < 8192) && (blend_bits <= 56)); // 56 bits for k-mer; could use long k-mers, but 28 enough in practice
    
    int blndK = (blend_bits>0)?blend_bits:2*k;
    uint64_t shift1 = 2 * (k - 1), mask = (1ULL<<2*k)-1, kmer[2] = {0,0}, hkmer[2] = {0,0}, iMask = (1ULL<<32)-2, blndMask = (1ULL<<blndK)-1;
    int i, j, l, buf_pos, min_pos, kmer_span = 0, tot_span;
    mm128_t buf[w];
    mm128_t min = { UINT64_MAX, UINT64_MAX };
    tiny_queue_t tq;
    
    //BLEND Variables
    int16_t blndIndStart = blndK-1;
    uint64_t blendVal = 0, r_blendVal = 0, blendStart=1ULL<<blndIndStart;
    int16_t blndcnt[sizeof(uint64_t)*8]; memset(blndcnt, 0, sizeof(blndcnt));
    int16_t r_blndcnt[sizeof(uint64_t)*8]; memset(r_blndcnt, 0, sizeof(r_blndcnt));
    b176_t blndBuf[n_neighbors];
    int16_t bi;
    int f_blendpos = -1;
    int l_blendpos;
    
    memset(buf, 0xff, w*16);
    memset(blndBuf, 0, n_neighbors*22);
    memset(&tq, 0, sizeof(tiny_queue_t));
    kv_resize(mm128_t, km, *p, p->n + len/w);

    for (i = l = l_blendpos = buf_pos = min_pos = 0; i < len; ++i) {
        int c = seq_nt4_table[(uint8_t)str[i]];
        mm128_t info = { UINT64_MAX, UINT64_MAX };
        if (c < 4) { // not an ambiguous base
            int z;
            if (is_hpc) {
                int skip_len = 1;
                if (i + 1 < len && seq_nt4_table[(uint8_t)str[i + 1]] == c) {
                    for (skip_len = 2; i + skip_len < len; ++skip_len)
                        if (seq_nt4_table[(uint8_t)str[i + skip_len]] != c)
                            break;
                    i += skip_len - 1; // put $i at the end of the current homopolymer run
                }
                tq_push(&tq, skip_len);
                kmer_span += skip_len;
                if (tq.count > k) kmer_span -= tq_shift(&tq);
            } else kmer_span = l + 1 < k? l + 1 : k;
            
            kmer[0] = ((kmer[0] << 2 | c) & mask); // forward k-mer
            kmer[1] = ((kmer[1] >> 2) | (3ULL^c) << shift1); //reverse k-mer k-mer
//            if (kmer[0] == kmer[1]) continue; // skip "symmetric k-mers" as we don't know it strand

            ++l;
            if (l >= k && kmer_span < 256){
                
                hkmer[0] = hash64(kmer[0], blndMask);
                hkmer[1] = hash64(kmer[1], blndMask);
                
                if(l >= n_neighbors+k-1){
                    bi = blndIndStart;
                    blendVal = 0; r_blendVal = 0;
                    
                    for(uint64_t val = blendStart; val > 0; val >>= 1){
                        blndcnt[bi] += ((hkmer[0]&val) == val)?1:-1;
                        r_blndcnt[bi] += ((hkmer[1]&val) == val)?1:-1;
                        if(blndcnt[bi]>0)blendVal |= val;
                        if(r_blndcnt[bi]>0)r_blendVal |= val;
                        blndcnt[bi] -= ((blndBuf[f_blendpos].x&val) == val)?1:-1;
                        r_blndcnt[bi] -= ((blndBuf[f_blendpos].y&val) == val)?1:-1;
                        --bi;
                    }
                    
                    tot_span = i - blndBuf[f_blendpos].i + blndBuf[f_blendpos].k;
                    
                    if(++f_blendpos == n_neighbors) f_blendpos = 0;
                    
                    if(blendVal < r_blendVal){
                        info.x = blendVal << 14 | tot_span;
                        info.y = (uint64_t)rid<<32 | (uint32_t)i<<1 | 0;
                    }else{
                        info.x = r_blendVal << 14 | tot_span;
                        info.y = (uint64_t)rid<<32 | (uint32_t)i<<1 | 1;
                    }
                }else{
                    bi = blndIndStart;
                    for(uint64_t val = blendStart; val > 0; val >>= 1){
                        blndcnt[bi] += ((hkmer[0]&val) == val)?1:-1;
                        r_blndcnt[bi--] += ((hkmer[1]&val) == val)?1:-1;
                    }
                    
                    if(f_blendpos == -1) f_blendpos = l_blendpos;
                    
                    z = (kmer[0] < kmer[1])?0:1;
                    info.x = hkmer[z] << 14 | kmer_span;
                    info.y = (uint64_t)rid<<32 | (uint32_t)i<<1 | z;
                }
            }
        } else l = 0, tq.count = tq.front = 0, kmer_span = 0;
        buf[buf_pos] = info; // need to do this here as appropriate buf_pos and buf[buf_pos] are needed below
        blndBuf[l_blendpos].x = hkmer[0];
        blndBuf[l_blendpos].y = hkmer[1];
        blndBuf[l_blendpos].i = i;
        blndBuf[l_blendpos].k = kmer_span;
        
        if (l == w + k - 1 && min.x != UINT64_MAX) { // special case for the first window - because identical k-mers are not stored yet
            for (j = buf_pos + 1; j < w; ++j)
                if (min.x == buf[j].x && buf[j].y != min.y) kv_push(mm128_t, km, *p, buf[j]);
            for (j = 0; j < buf_pos; ++j)
                if (min.x == buf[j].x && buf[j].y != min.y) kv_push(mm128_t, km, *p, buf[j]);
        }
        if (info.x <= min.x) { // a new minimum; then write the old min
            if (l >= w + k && min.x != UINT64_MAX) kv_push(mm128_t, km, *p, min);
            min = info, min_pos = buf_pos;
        } else if (buf_pos == min_pos) { // old min has moved outside the window
            if (l >= w + k - 1 && min.x != UINT64_MAX) kv_push(mm128_t, km, *p, min);
            for (j = buf_pos + 1, min.x = UINT64_MAX; j < w; ++j) // the two loops are necessary when there are identical k-mers
                if (min.x >= buf[j].x) min = buf[j], min_pos = j; // >= is important s.t. min is always the closest k-mer
            for (j = 0; j <= buf_pos; ++j)
                if (min.x >= buf[j].x) min = buf[j], min_pos = j;
            if (l >= w + k - 1 && min.x != UINT64_MAX) { // write identical k-mers
                for (j = buf_pos + 1; j < w; ++j) // these two loops make sure the output is sorted
                    if (min.x == buf[j].x && min.y != buf[j].y) kv_push(mm128_t, km, *p, buf[j]);
                for (j = 0; j <= buf_pos; ++j)
                    if (min.x == buf[j].x && min.y != buf[j].y) kv_push(mm128_t, km, *p, buf[j]);
            }
        }

        if(++buf_pos == w) buf_pos = 0;
        if(++l_blendpos == n_neighbors) l_blendpos = 0;
    }
    if (min.x != UINT64_MAX)
        kv_push(mm128_t, km, *p, min);
}

/**
 * Find symmetric (w,k)-minimizers on a DNA sequence
 *
 * @param km     thread-local memory pool; using NULL falls back to malloc()
 * @param str    DNA sequence
 * @param len    length of $str
 * @param w      find a BLEND value for every $w consecutive k-mers
 * @param blend_bits skip/shift this many k-mers before generating the next BLEND value
 * @param k      k-mer size
 * @param k_shift skip/shift this many characters before calculating the next k-mer
 * @param rid    reference ID; will be copied to the output $p array
 * @param is_hpc homopolymer-compressed or not
 * @param p      minimizers
 *               p->a[i].x = kMer<<14 | kmerSpan
 *               p->a[i].y = rid<<32 | lastPos<<1 | strand
 *               where lastPos is the position of the last base of the i-th minimizer,
 *               and strand indicates whether the minimizer comes from the top or the bottom strand.
 *               Callers may want to set "p->n = 0"; otherwise results are appended to p
 */
void mm_sketch_blend(void *km,
                     const char *str,
                     int len,
                     int w,
                     int blend_bits,
                     int k,
                     int k_shift,
                     uint32_t rid,
                     int is_hpc,
                     mm128_v *p){
    
    assert(len > 0 && (w > 0 && w+k < 8192) && (k > 0 && k <= 28) && (blend_bits <= 56)); // 56 bits for k-mer; could use long k-mers, but 28 enough in practice
    
    int blndK = (blend_bits>0)?blend_bits:2*k;
    uint64_t shift1 = 2 * (k - 1), mask = (1ULL<<2*k)-1, kmer[2] = {0,0}, hkmer[2] = {0,0}, iMask = (1ULL<<32)-2, blndMask = (1ULL<<blndK)-1;
    int i, l, buf_pos, kmer_span = 0, tot_span;
    tiny_queue_t tq;
    
    //BLEND Variables
    int16_t blndIndStart = blndK-1;
    uint64_t blendVal = 0, r_blendVal, blendStart=1ULL<<blndIndStart;
    int16_t blndcnt[sizeof(uint64_t)*8]; memset(blndcnt, 0, sizeof(blndcnt));
    int16_t r_blndcnt[sizeof(uint64_t)*8]; memset(r_blndcnt, 0, sizeof(r_blndcnt));
    b176_t blndBuf[w];
    int16_t bi;
    int f_blendpos = -1;
    int l_blendpos;

    //IMPORTANT: changed w < 256 to w < 8192
    //should we make it 8192? because kmer span can be much higher than k if hpc is enabled so
    //accumulating kmer span at each iteration w many times may result in a vlaue higher than 16k
    
    memset(blndBuf, 0, w*22);
    memset(&tq, 0, sizeof(tiny_queue_t));
    kv_resize(mm128_t, km, *p, p->n + ((len-k+1)/k_shift)+1);
    //@IMPORTANT: fix below do not set it to zero automatically, I set it for experimental
    //purposes
    //@IDEA: Should we simhash the kmer in its binary form directly or after hashing it?
    //@IDEA: Tweak grim-filter so that it works for simhash counting?
    //$i is the actual position pointer of seq, the others are reset eventually
    
    int kShiftCount = 1;
    int kCount = 0;
    for (i = l = l_blendpos = buf_pos = 0; i < len; ++i) {
        int c = seq_nt4_table[(uint8_t)str[i]];
        mm128_t info = {UINT64_MAX, UINT64_MAX};
        if (c < 4){ // not an ambiguous base
            int z;
            if (is_hpc){ //checking whether homopolymer compression
                int skip_len = 1;
                if (i + 1 < len && seq_nt4_table[(uint8_t)str[i + 1]] == c) {
                    for (skip_len = 2; i + skip_len < len; ++skip_len)
                        if (seq_nt4_table[(uint8_t)str[i + skip_len]] != c)
                            break;
                    i += skip_len - 1; // put $i at the end of the current homopolymer run
                }
                tq_push(&tq, skip_len);
                kmer_span += skip_len;
                if (tq.count > k) kmer_span -= tq_shift(&tq);
            } else kmer_span = l + 1 < k? l + 1 : k;
            kmer[0] = ((kmer[0] << 2 | c) & mask); // forward k-mer
            kmer[1] = ((kmer[1] >> 2) | (3ULL^c) << shift1); //reverse k-mer
            
            ++l;
            //k-mer span also counts the number of characters we skipped during hpc
            if (l >= k && kmer_span < 256){
                
                if(--kShiftCount) continue;
                kShiftCount = k_shift;
                kCount++;
                
                hkmer[0] = hash64(kmer[0], blndMask);
                hkmer[1] = hash64(kmer[1], blndMask);
                if(kCount >= w){
                    bi = blndIndStart;
                    blendVal = 0; r_blendVal = 0;
                    
                    for(uint64_t val = blendStart; val > 0; val >>= 1){
                        blndcnt[bi] += ((hkmer[0]&val) == val)?1:-1;
                        r_blndcnt[bi] += ((hkmer[1]&val) == val)?1:-1;
                        if(blndcnt[bi]>0)blendVal |= val;
                        if(r_blndcnt[bi]>0)r_blendVal |= val;
                        blndcnt[bi] -= ((blndBuf[f_blendpos].x&val) == val)?1:-1;
                        r_blndcnt[bi] -= ((blndBuf[f_blendpos].y&val) == val)?1:-1;
                        --bi;
                    }
                    
                    tot_span = i - blndBuf[f_blendpos].i + blndBuf[f_blendpos].k;
                    
                    if(++f_blendpos == w) f_blendpos = 0;
                    
                    if(blendVal < r_blendVal){
                        info.x = blendVal << 14 | tot_span;
                        info.y = (uint64_t)rid<<32 | (uint32_t)i<<1 | 0;
                    }else{
                        info.x = r_blendVal << 14 | tot_span;
                        info.y = (uint64_t)rid<<32 | (uint32_t)i<<1 | 1;
                    }
                }else{
                    bi = blndIndStart;
                    for(uint64_t val = blendStart; val > 0; val >>= 1){
                        blndcnt[bi] += ((hkmer[0]&val) == val)?1:-1;
                        r_blndcnt[bi--] += ((hkmer[1]&val) == val)?1:-1;
                    }
                    
                    if(f_blendpos == -1) f_blendpos = l_blendpos;
                    
                    z = (kmer[0] < kmer[1])?0:1;
                    info.x = hkmer[z] << 14 | kmer_span;
                    info.y = (uint64_t)rid<<32 | (uint32_t)i<<1 | z;
                }
            }
        } else l = 0, tq.count = tq.front = 0, kmer_span = 0;
        blndBuf[l_blendpos].x = hkmer[0];
        blndBuf[l_blendpos].y = hkmer[1];
        blndBuf[l_blendpos].i = i;
        blndBuf[l_blendpos].k = kmer_span;
        
        if(kCount >= w) kv_push(mm128_t, km, *p, info);
        
        if(++l_blendpos == w) l_blendpos = 0;
    }
}

/**
 * Find symmetric (w,k)-minimizers on a DNA sequence
 *
 * @param km     thread-local memory pool; using NULL falls back to malloc()
 * @param str    DNA sequence
 * @param len    length of $str
 * @param w      find a BLEND value for every $w consecutive k-mers
 * @param blend_bits skip/shift this many k-mers before generating the next BLEND value
 * @param k      k-mer size
 * @param k_shift skip/shift this many characters before calculating the next k-mer
 * @param n_neighbors should BLEND use minimizers or not. If so, the number tells how many neighbor k-mers should be blended. E.g., if 3, then take 1 minimizer and 2 preceding k-mers to calculate the hash value of a seed
 * @param rid    reference ID; will be copied to the output $p array
 * @param is_hpc homopolymer-compressed or not
 * @param p      minimizers
 *               p->a[i].x = kMer<<14 | kmerSpan
 *               p->a[i].y = rid<<32 | lastPos<<1 | strand
 *               where lastPos is the position of the last base of the i-th minimizer,
 *               and strand indicates whether the minimizer comes from the top or the bottom strand.
 *               Callers may want to set "p->n = 0"; otherwise results are appended to p
 */
void mm_sketch(void *km,
			   const char *str,
			   int len,
			   int w,
               int blend_bits,
			   int k,
               int k_shift,
               int n_neighbors,
			   uint32_t rid,
			   int is_hpc,
			   mm128_v *p){
    
    if(n_neighbors > 0)
        mm_sketch_minimizer_blend(km, str, len, w, blend_bits, k, n_neighbors, rid, is_hpc, p);
    else mm_sketch_blend(km, str, len, w, blend_bits, k, k_shift, rid, is_hpc, p);
}
