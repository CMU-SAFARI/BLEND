#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#define __STDC_LIMIT_MACROS
#include "kvec.h"
#include "mmpriv.h"

// #include <immintrin.h>
#include <x86intrin.h>

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

typedef struct { uint64_t x, y, sk_x, sk_y; uint32_t i; uint16_t k; } b304_t;
typedef struct { uint64_t x, y; uint32_t i; uint16_t k; } b176_t;
typedef struct { uint64_t x; uint32_t i; uint16_t k; } b112_t;

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

static inline uint32_t hash32(uint32_t key, uint32_t mask){
    key = (~key + (key << 21)) & mask; // key = (key << 21) - key - 1;
    key = key ^ key >> 24;
    key = ((key + (key << 3)) + (key << 8)) & mask; // key * 265
    key = key ^ key >> 14;
    key = ((key + (key << 2)) + (key << 4)) & mask; // key * 21
    key = key ^ key >> 28;
    key = (key + (key << 31)) & mask;

    return key;
}

static inline uint64_t MurmurHash3(uint64_t key, uint64_t mask) {
  key = (key^(key >> 33)) & mask;
  key = (key*0xff51afd7ed558ccd) & mask;
  key = (key^(key >> 33)) & mask;
  key = (key*0xc4ceb9fe1a85ec53) & mask;
  key = (key^(key >> 33)) & mask;

  return key;
}

typedef struct { // a simplified version of kdq
    int front, count;
    int a[32];
} tiny_queue_t;

static inline void tq_push(tiny_queue_t *q, int x){
    q->a[((q->count++) + q->front) & 0x1f] = x;
}

static inline int tq_shift(tiny_queue_t *q){
    int x;
    if (q->count == 0) return -1;
    x = q->a[q->front++];
    q->front &= 0x1f;
    --q->count;
    return x;
}

//https://stackoverflow.com/a/21673221
static inline __m256i movemask_inverse(const uint32_t mask) {
    __m256i vmask = _mm256_set1_epi32(mask);
    const __m256i shuffle = _mm256_setr_epi64x(0x0000000000000000,
      0x0101010101010101, 0x0202020202020202, 0x0303030303030303);
    vmask = _mm256_shuffle_epi8(vmask, shuffle);
    const __m256i bit_mask = _mm256_set1_epi64x(0x7fbfdfeff7fbfdfe);
    vmask = _mm256_or_si256(vmask, bit_mask);
    return _mm256_cmpeq_epi8(vmask, _mm256_set1_epi64x(-1));
}

static inline void calc_blend_simd(__m256i* blndcnt_lsb, __m256i* blndcnt_msb, __m256i* ma, __m256i* mb, uint64_t val,
                                   uint64_t mask, int bits) {

    (*blndcnt_lsb) = _mm256_adds_epi8((*blndcnt_lsb), _mm256_blendv_epi8((*ma), (*mb), movemask_inverse(val&mask)));
    uint64_t blendVal = (uint64_t)_mm256_movemask_epi8((*blndcnt_lsb))&mask;
    if(bits > 32){
        (*blndcnt_msb) = _mm256_adds_epi8((*blndcnt_msb), _mm256_blendv_epi8((*ma), (*mb),movemask_inverse((val>>32)&mask)));
        blendVal |= ((uint64_t)_mm256_movemask_epi8((*blndcnt_msb)))<<32;
    }
}

static inline uint64_t calc_blend_rm_simd(__m256i* blndcnt_lsb, __m256i* blndcnt_msb, __m256i* ma, __m256i* mb,
                                        uint64_t val, uint64_t remval, uint64_t mask, int bits) {

    (*blndcnt_lsb) = _mm256_adds_epi8((*blndcnt_lsb), _mm256_blendv_epi8((*ma), (*mb), movemask_inverse(val&mask)));
    uint64_t blendVal = (uint64_t)_mm256_movemask_epi8((*blndcnt_lsb))&mask;
    //removal of the oldest item
    (*blndcnt_lsb) = _mm256_adds_epi8((*blndcnt_lsb), _mm256_blendv_epi8((*mb), (*ma), movemask_inverse(remval&mask)));

    if(bits > 32){
        (*blndcnt_msb) = _mm256_adds_epi8((*blndcnt_msb), _mm256_blendv_epi8((*ma), (*mb),movemask_inverse((val>>32)&mask)));
        blendVal |= ((uint64_t)_mm256_movemask_epi8((*blndcnt_msb)))<<32;

        (*blndcnt_msb) = _mm256_adds_epi8((*blndcnt_msb),_mm256_blendv_epi8((*mb), (*ma), movemask_inverse((remval>>32)&mask)));
    }
    
    return blendVal;
}

/**
 * Find symmetric (w,k)-minimizers on a DNA sequence and BLEND it with its (n_neighbors-1) preceding neighbor k-mers
 *
 * @param km     thread-local memory pool; using NULL falls back to malloc()
 * @param str    DNA sequence
 * @param len    length of $str
 * @param w      find a BLEND value for every $w consecutive k-mers
 * @param blend_bits      use blend_bits many bits when generating the hash values of seeds
 * @param k      k-mer size
 * @param n_neighbors How many neighbor k-mers (including the minimizer k-mer) should be combined to generate a seed
 * @param rid    reference ID; will be copied to the output $p array
 * @param is_hpc homopolymer-compressed or not
 * @param p      minimizers
 *               p->a[i].x = BLEND(n_neighbors k-mers)<<14 | n_neighbors k-mers span
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
                     int n_neighbors,
                     uint32_t rid,
                     int is_hpc,
                     mm128_v *p){
    
    assert(len > 0 && (w > 0 && w+k < 8192) && (k > 0 && k <= 28) && (n_neighbors > 0 && n_neighbors+k < 8192) && (blend_bits <= 56)); // 56 bits for k-mer; could use long k-mers, but 28 enough in practice
    
    int blndK = (blend_bits>0)?blend_bits:2*k;
    uint64_t shift1 = 2*(k-1), mask = (1ULL<<2*k)-1, blndMask = (1ULL<<blndK)-1, mask32 = (1ULL<<32)-1, kmer[2] = {0,0}, hkmer = 0, sMask = (1ULL<<14)-1;
    int i, j, l, buf_pos, min_pos, kmer_span = 0, tot_span;
    mm128_t buf[w];
    mm128_t min = { UINT64_MAX, UINT64_MAX };
    tiny_queue_t tq;
    
    //BLEND Variables
    uint64_t blendVal = 0;
    mm128_t blndBuf[n_neighbors];
    int f_blendpos = 0;
    
    //SIMD-related variables
    __m256i ma = _mm256_set1_epi8(1);
    __m256i mb = _mm256_set1_epi8(-1);
    __m256i blndcnt_lsb = _mm256_set1_epi8(0);
    __m256i blndcnt_msb = _mm256_set1_epi8(0);
    
    memset(buf, 0xff, w*16);
    memset(blndBuf, 0, n_neighbors*16); //176/8
    memset(&tq, 0, sizeof(tiny_queue_t));
    kv_resize(mm128_t, km, *p, p->n + len/w);

    for (i = l = f_blendpos = buf_pos = min_pos = 0; i < len; ++i) {
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
            if (kmer[0] == kmer[1]) continue; // skip "symmetric k-mers" as we don't know it strand
            z = kmer[0] < kmer[1]? 0 : 1; // strand

            ++l;
            if (l >= k && kmer_span < 256){
                
                //@IMPORTANT compute hash values in SIMD as well?
                hkmer = hash64(kmer[z], blndMask);
                blndBuf[f_blendpos].x = hkmer << 14 | kmer_span;
                blndBuf[f_blendpos].y = i;

                if(++f_blendpos == n_neighbors) f_blendpos = 0;

                if(l >= n_neighbors+k-1){

                    blendVal = calc_blend_rm_simd(&blndcnt_lsb, &blndcnt_msb, &ma, &mb, hkmer, 
                                                  blndBuf[f_blendpos].x>>14, mask32, blndK);

                    //@IMPORTANT: here we use tot_span but we could use only kmer_span too
                    //it would be more precise but would lead to large gaps between seeds.
                    tot_span = i - (uint32_t)blndBuf[f_blendpos].y + (uint32_t)blndBuf[f_blendpos].x&sMask;
                    
                    info.x = blendVal << 14 | tot_span;
                    info.y = (uint64_t)rid<<32 | (uint32_t)i<<1 | z;
                }else
                    calc_blend_simd(&blndcnt_lsb, &blndcnt_msb, &ma, &mb, hkmer, mask32, blndK);
            }
        } else l = 0, tq.count = tq.front = 0, kmer_span = 0;
        buf[buf_pos] = info; // need to do this here as appropriate buf_pos and buf[buf_pos] are needed below
        
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
    }
    if (min.x != UINT64_MAX)
        kv_push(mm128_t, km, *p, min);
}

/**
 * Find symmetric (w,k)-minimizers on a DNA sequence and BLEND n_neighbors many consecutive minimizers
 *
 * @param km     thread-local memory pool; using NULL falls back to malloc()
 * @param str    DNA sequence
 * @param len    length of $str
 * @param w      find a BLEND value for every $w consecutive k-mers
 * @param blend_bits      use blend_bits many bits when generating the hash values of seeds
 * @param k      k-mer size
 * @param n_neighbors How many neighbors consecutive minimizer k-mers should be combined to generate a strobemer seed
 * @param rid    reference ID; will be copied to the output $p array
 * @param is_hpc homopolymer-compressed or not
 * @param p      minimizers
 *               p->a[i].x = BLEND(n_neighbors k-mers)<<14 | k-mer span of the first minimizer k-mer
 *               p->a[i].y = rid<<32 | lastPos<<1 | strand
 *               where lastPos is the position of the last base of the i-th minimizer (first minimizer in the strobemer)
 *               , and strand indicates whether the minimizer comes from the top or the bottom strand.
 *               Callers may want to set "p->n = 0"; otherwise results are appended to p
 */
void mm_sketch_sb_blend(void *km,
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
    uint64_t shift1 = 2*(k-1), mask = (1ULL<<2*k)-1, mask32 = (1ULL<<32)-1, sMask = (1ULL<<14)-1, iMask = (1ULL<<31)-1, blndMask = (1ULL<<blndK)-1, kmer[2] = {0,0}, hkmer = 0; //for iMask, the actual value should be shifted right first
    int i, j, l, buf_pos, f_min_pos, kmer_span = 0;

    uint32_t tot_span;
    tiny_queue_t tq;

    mm128_t f_buf[w];
    mm128_t f_min = { UINT64_MAX, UINT64_MAX };
    mm128_t f_rem;
    
    //BLEND Variables
    uint64_t blendVal = 0;
    mm128_t f_blndBuf[n_neighbors];
    int f_blendpos = 0;
    uint64_t f_nm = 0; //number of minimizers processed
    
    //SSE4-related variables
    __m256i ma = _mm256_set1_epi8(1);
    __m256i mb = _mm256_set1_epi8(-1);
    __m256i f_blndcnt_lsb = _mm256_set1_epi8(0);
    __m256i f_blndcnt_msb = _mm256_set1_epi8(0);
    
    memset(f_buf, 0xff, w*16);
    memset(f_blndBuf, 0, n_neighbors*16);
    memset(&tq, 0, sizeof(tiny_queue_t));
    kv_resize(mm128_t, km, *p, p->n + len/w);

    for (i = l = f_blendpos = buf_pos = f_min_pos = 0; i < len; ++i) {
        int c = seq_nt4_table[(uint8_t)str[i]];
        mm128_t info = { UINT64_MAX, UINT64_MAX };
        mm128_t f_info = { UINT64_MAX, UINT64_MAX };
        mm128_t r_info = { UINT64_MAX, UINT64_MAX };
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
            if (kmer[0] == kmer[1]) continue; // skip "symmetric k-mers" as we don't know it strand
            z = kmer[0] < kmer[1]? 0 : 1; // strand

            ++l;
            if (l >= k && kmer_span < 256){
                hkmer = hash64(kmer[z], blndMask);
                f_info.x = hkmer << 14 | kmer_span;
                f_info.y = (uint64_t)rid<<32 | (uint32_t)i<<1 | z;
            }
        } else l = 0, tq.count = tq.front = 0, kmer_span = 0;
        f_buf[buf_pos] = f_info; // need to do this here as appropriate f_buf[buf_pos] are needed below
        
        // special case for the first window - because identical k-mers are not stored yet
        if (l == w + k - 1 && f_min.x != UINT64_MAX) {
            for (j = buf_pos + 1; j < w; ++j){
                if (f_min.x == f_buf[j].x && f_buf[j].y != f_min.y) {                   
                    f_blndBuf[f_blendpos].x = f_buf[j].x;
                    f_blndBuf[f_blendpos].y = (f_buf[j].y&iMask)>>1;
                    tot_span = f_blndBuf[f_blendpos].y;

                    if(++f_blendpos == n_neighbors) f_blendpos = 0;
                    if(++f_nm >= n_neighbors){
                        blendVal = calc_blend_rm_simd(&f_blndcnt_lsb, &f_blndcnt_msb, &ma, &mb, f_buf[j].x>>14,
                                                   f_blndBuf[f_blendpos].x>>14, mask32, blndK);
                        tot_span = tot_span - f_blndBuf[f_blendpos].y + f_blndBuf[f_blendpos].x&sMask;
                        info.x = blendVal << 14 | tot_span;
                        info.y = f_buf[j].y;
                        kv_push(mm128_t, km, *p, info);
                    }else //only addition of f_buf[j]
                        calc_blend_simd(&f_blndcnt_lsb, &f_blndcnt_msb, &ma, &mb, f_buf[j].x>>14, mask32, blndK);
                }
            }
            for (j = 0; j < buf_pos; ++j)
                if (f_min.x == f_buf[j].x && f_buf[j].y != f_min.y) {
                    f_blndBuf[f_blendpos].x = f_buf[j].x;
                    f_blndBuf[f_blendpos].y = (f_buf[j].y&iMask)>>1;
                    tot_span = f_blndBuf[f_blendpos].y;

                    if(++f_blendpos == n_neighbors) f_blendpos = 0;
                    if(++f_nm >= n_neighbors){
                        blendVal = calc_blend_rm_simd(&f_blndcnt_lsb, &f_blndcnt_msb, &ma, &mb, f_buf[j].x>>14,
                                                   f_blndBuf[f_blendpos].x>>14, mask32, blndK);
                        tot_span = tot_span - f_blndBuf[f_blendpos].y + f_blndBuf[f_blendpos].x&sMask;
                        info.x = blendVal << 14 | tot_span;
                        info.y = f_buf[j].y;
                        kv_push(mm128_t, km, *p, info);
                    }else
                        calc_blend_simd(&f_blndcnt_lsb, &f_blndcnt_msb, &ma, &mb, f_buf[j].x>>14, mask32, blndK);
                }
        }

        if (f_info.x <= f_min.x) { // a new minimum; then write the old f_min
            if (l >= w + k && f_min.x != UINT64_MAX) {
                f_blndBuf[f_blendpos].x = f_min.x;
                f_blndBuf[f_blendpos].y = (f_min.y&iMask)>>1;
                tot_span = f_blndBuf[f_blendpos].y;

                if(++f_blendpos == n_neighbors) f_blendpos = 0;
                if(++f_nm >= n_neighbors){
                    blendVal = calc_blend_rm_simd(&f_blndcnt_lsb, &f_blndcnt_msb, &ma, &mb, f_min.x>>14,
                                               f_blndBuf[f_blendpos].x>>14, mask32, blndK);
                    tot_span = tot_span - f_blndBuf[f_blendpos].y + f_blndBuf[f_blendpos].x&sMask;
                    info.x = blendVal << 14 | tot_span;
                    info.y = f_min.y;
                    kv_push(mm128_t, km, *p, info);
                }else 
                    calc_blend_simd(&f_blndcnt_lsb, &f_blndcnt_msb, &ma, &mb, f_min.x>>14, mask32, blndK);
            }
            f_min = f_info, f_min_pos = buf_pos;
        } else if (buf_pos == f_min_pos) { // old f_min has moved outside the window
            if (l >= w + k - 1 && f_min.x != UINT64_MAX) {
                f_blndBuf[f_blendpos].x = f_min.x;
                f_blndBuf[f_blendpos].y = (f_min.y&iMask)>>1;
                tot_span = f_blndBuf[f_blendpos].y;

                if(++f_blendpos == n_neighbors) f_blendpos = 0;
                if(++f_nm >= n_neighbors){
                    blendVal = calc_blend_rm_simd(&f_blndcnt_lsb, &f_blndcnt_msb, &ma, &mb, f_min.x>>14,
                                               f_blndBuf[f_blendpos].x>>14, mask32, blndK);
                    tot_span = tot_span - f_blndBuf[f_blendpos].y + f_blndBuf[f_blendpos].x&sMask;
                    info.x = blendVal << 14 | tot_span;
                    info.y = f_min.y;
                    kv_push(mm128_t, km, *p, info);
                }else 
                    calc_blend_simd(&f_blndcnt_lsb, &f_blndcnt_msb, &ma, &mb, f_min.x>>14, mask32, blndK);
            }
            for (j = buf_pos + 1, f_min.x = UINT64_MAX; j < w; ++j) // the two loops are necessary when there are identical k-mers. This one starts from the oldest (first in: buf_pos + 1) 
                if (f_min.x >= f_buf[j].x) f_min = f_buf[j], f_min_pos = j; // >= is important s.t. f_min is always the closest k-mer... chosing the last one because we will store *all* identical minimizers and continue with the last one once all identical ones are stored. @IMPORTANT: should we really store all identical k-mers? it is true that they are the minimizers for their own window but not sure how effective it is
            for (j = 0; j <= buf_pos; ++j)
                if (f_min.x >= f_buf[j].x) f_min = f_buf[j], f_min_pos = j;
            if (l >= w + k - 1 && f_min.x != UINT64_MAX) { // write identical k-mers
                for (j = buf_pos + 1; j < w; ++j) // these two loops make sure the output is sorted
                    if (f_min.x == f_buf[j].x && f_min.y != f_buf[j].y) {
                        f_blndBuf[f_blendpos].x = f_buf[j].x;
                        f_blndBuf[f_blendpos].y = (f_buf[j].y&iMask)>>1;
                        tot_span = f_blndBuf[f_blendpos].y;

                        if(++f_blendpos == n_neighbors) f_blendpos = 0;
                        if(++f_nm >= n_neighbors){
                            blendVal = calc_blend_rm_simd(&f_blndcnt_lsb, &f_blndcnt_msb, &ma, &mb, f_buf[j].x>>14,
                                                       f_blndBuf[f_blendpos].x>>14, mask32, blndK);
                            tot_span = tot_span - f_blndBuf[f_blendpos].y + f_blndBuf[f_blendpos].x&sMask;
                            info.x = blendVal << 14 | tot_span;
                            info.y = f_buf[j].y;
                            kv_push(mm128_t, km, *p, info);
                        }else 
                            calc_blend_simd(&f_blndcnt_lsb, &f_blndcnt_msb, &ma, &mb, f_buf[j].x>>14, mask32,blndK);
                    }
                for (j = 0; j <= buf_pos; ++j)
                    if (f_min.x == f_buf[j].x && f_min.y != f_buf[j].y) {
                        f_blndBuf[f_blendpos].x = f_buf[j].x;
                        f_blndBuf[f_blendpos].y = (f_buf[j].y&iMask)>>1;
                        tot_span = f_blndBuf[f_blendpos].y;

                        if(++f_blendpos == n_neighbors) f_blendpos = 0;
                        if(++f_nm >= n_neighbors){
                            blendVal = calc_blend_rm_simd(&f_blndcnt_lsb, &f_blndcnt_msb, &ma, &mb, f_buf[j].x>>14,
                                                       f_blndBuf[f_blendpos].x>>14, mask32, blndK);
                            tot_span = tot_span - f_blndBuf[f_blendpos].y + f_blndBuf[f_blendpos].x&sMask;
                            info.x = blendVal << 14 | tot_span;
                            info.y = f_buf[j].y;
                            kv_push(mm128_t, km, *p, info);
                        }else 
                            calc_blend_simd(&f_blndcnt_lsb, &f_blndcnt_msb, &ma, &mb, f_buf[j].x>>14, mask32,blndK);
                    }
            }
        }
        if(++buf_pos == w) buf_pos = 0;
    }

    if (f_min.x != UINT64_MAX){
        f_blndBuf[f_blendpos].x = f_min.x;
        f_blndBuf[f_blendpos].y = (f_min.y&iMask)>>1;
        tot_span = f_blndBuf[f_blendpos].y;

        if(++f_blendpos == n_neighbors) f_blendpos = 0;
        if(++f_nm >= n_neighbors){
            blendVal = calc_blend_rm_simd(&f_blndcnt_lsb, &f_blndcnt_msb, &ma, &mb, f_min.x>>14,
                                       f_blndBuf[f_blendpos].x>>14, mask32, blndK);
            tot_span = tot_span - f_blndBuf[f_blendpos].y + f_blndBuf[f_blendpos].x&sMask;
            f_min.x = blendVal << 14 | tot_span;
            kv_push(mm128_t, km, *p, f_min);
        }
    }
}

/**
 * Find symmetric (w,k)-minimizers on a DNA sequence and BLEND it with its (n_neighbors-1) preceding neighbor k-mers
 * This is an experimental function and not tested yet. The idea is to mask low-confidence bits using another hash
 * function so that we can replace the low confidence bits with hopefully a high confidence value we receive from
 * the second (or maybe more) hash function. The function may have bugs, should be used with caution.
 * @param km     thread-local memory pool; using NULL falls back to malloc()
 * @param str    DNA sequence
 * @param len    length of $str
 * @param w      find a BLEND value for every $w consecutive k-mers
 * @param blend_bits      use blend_bits many bits when generating the hash values of seeds
 * @param k      k-mer size
 * @param n_neighbors How many neighbor k-mers (including the minimizer k-mer) should be combined to generate a seed
 * @param rid    reference ID; will be copied to the output $p array
 * @param is_hpc homopolymer-compressed or not
 * @param p      minimizers
 *               p->a[i].x = BLEND(n_neighbors k-mers)<<14 | n_neighbors k-mers span
 *               p->a[i].y = rid<<32 | lastPos<<1 | strand
 *               where lastPos is the position of the last base of the i-th minimizer,
 *               and strand indicates whether the minimizer comes from the top or the bottom strand.
 *               Callers may want to set "p->n = 0"; otherwise results are appended to p
 */
void mm_sketch_sk_blend(void *km,
                     const char *str,
                     int len,
                     int w,
                     int blend_bits,
                     int k,
                     int n_neighbors,
                     uint32_t rid,
                     int is_hpc,
                     mm128_v *p){

    assert(len > 0 && (w > 0 && w+k < 8192) && (k > 0 && k <= 28) && (n_neighbors > 0 && n_neighbors+k < 8192) && (blend_bits <= 56));

    int blndK = (blend_bits>0)?blend_bits:2*k;
    uint64_t shift1 = 2*(k-1), mask = (1ULL<<2*k)-1, blndMask = (1ULL<<blndK)-1, mask32 = (1ULL<<32)-1, kmer[2] = {0,0}, hkmer[4] = {0,0,0,0};
    int i, j, l, buf_pos, min_pos, kmer_span = 0, tot_span;
    mm128_t buf[w];
    mm128_t min = { UINT64_MAX, UINT64_MAX };
    tiny_queue_t tq;
    
    //BLEND Variables
    int64_t blendVal = 0, r_blendVal = 0;
    int64_t sk_blendVal = 0, skr_blendVal = 0; //skewed values
    b304_t blndBuf[n_neighbors];
    int f_blendpos = -1;
    int l_blendpos;

    //@IMPORTANT: skew_threshold is set by a fixed calculation for now.
    int skew_threshold = (n_neighbors/5 < 64)?n_neighbors/5:63;
    assert(skew_threshold > 0);

    //SSE4-related variables
    __m256i ma = _mm256_set1_epi8(1);
    __m256i mb = _mm256_set1_epi8(-1);
    __m256i mg = _mm256_set1_epi8(skew_threshold);
    __m256i blndcnt_lsb = _mm256_set1_epi8(0);
    __m256i blndcnt_msb = _mm256_set1_epi8(0);
    __m256i r_blndcnt_lsb = _mm256_set1_epi8(0);
    __m256i r_blndcnt_msb = _mm256_set1_epi8(0);

    __m256i sk_blndcnt_lsb = _mm256_set1_epi8(0);
    __m256i sk_blndcnt_msb = _mm256_set1_epi8(0);
    __m256i skr_blndcnt_lsb = _mm256_set1_epi8(0);
    __m256i skr_blndcnt_msb = _mm256_set1_epi8(0);

    int tmp1, tmp2;
    
    memset(buf, 0xff, w*16);
    memset(blndBuf, 0, n_neighbors*38); //304/8
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

            ++l;
            if (l >= k && kmer_span < 256){
                
                hkmer[0] = hash64(kmer[0], blndMask);
                hkmer[1] = hash64(kmer[1], blndMask);
                hkmer[2] = MurmurHash3(kmer[0], blndMask);
                hkmer[3] = MurmurHash3(kmer[1], blndMask);

                blndcnt_lsb = _mm256_adds_epi8(blndcnt_lsb, 
                                               _mm256_blendv_epi8(ma, mb, 
                                                                  movemask_inverse(hkmer[0]&mask32)));
                r_blndcnt_lsb = _mm256_adds_epi8(r_blndcnt_lsb, 
                                               _mm256_blendv_epi8(ma, mb, 
                                                                  movemask_inverse(hkmer[1]&mask32)));

                sk_blndcnt_lsb = _mm256_adds_epi8(sk_blndcnt_lsb, 
                                               _mm256_blendv_epi8(ma, mb, 
                                                                  movemask_inverse(hkmer[2]&mask32)));
                skr_blndcnt_lsb = _mm256_adds_epi8(skr_blndcnt_lsb, 
                                               _mm256_blendv_epi8(ma, mb, 
                                                                  movemask_inverse(hkmer[3]&mask32)));

                if(blndK > 32){
                    blndcnt_msb = _mm256_adds_epi8(blndcnt_msb,
                                              _mm256_blendv_epi8(ma, mb,
                                                                 movemask_inverse((hkmer[0]>>32)&mask32)));

                    r_blndcnt_msb = _mm256_adds_epi8(r_blndcnt_msb,
                                              _mm256_blendv_epi8(ma, mb,
                                                                 movemask_inverse((hkmer[1]>>32)&mask32)));

                    sk_blndcnt_msb = _mm256_adds_epi8(sk_blndcnt_msb,
                                              _mm256_blendv_epi8(ma, mb,
                                                                 movemask_inverse((hkmer[2]>>32)&mask32)));

                    skr_blndcnt_msb = _mm256_adds_epi8(skr_blndcnt_msb,
                                              _mm256_blendv_epi8(ma, mb,
                                                                 movemask_inverse((hkmer[3]>>32)&mask32)));
                }

                if(f_blendpos == -1) f_blendpos = l_blendpos;
                if(l >= n_neighbors+k-1){

                    //bits set to 1 if corresponding count < skew_threshold
                    tmp1 = _mm256_movemask_epi8(_mm256_cmpgt_epi8(mg, _mm256_abs_epi8(blndcnt_lsb)));
                    //bits set to 1 if corresponding skewed count > skew_threshold
                    tmp2 = _mm256_movemask_epi8(_mm256_cmpgt_epi8(_mm256_abs_epi8(sk_blndcnt_lsb), mg));

                    //we replace the counts in the original counter where a value is < skew_threshold and the same
                    //value in the skewed counter is > skew_threshold
                    blendVal = _mm256_movemask_epi8(_mm256_blendv_epi8(blndcnt_lsb, sk_blndcnt_lsb,
                                                                       movemask_inverse(tmp1&tmp2)))&mask32;

                    //same for the reverse complements:
                    tmp1 = _mm256_movemask_epi8(_mm256_cmpgt_epi8(mg, _mm256_abs_epi8(r_blndcnt_lsb)));
                    tmp2 = _mm256_movemask_epi8(_mm256_cmpgt_epi8(_mm256_abs_epi8(skr_blndcnt_lsb), mg));
                    r_blendVal = _mm256_movemask_epi8(_mm256_blendv_epi8(r_blndcnt_lsb, skr_blndcnt_lsb,
                                                                         movemask_inverse(tmp1&tmp2)))&mask32;

                    //removing the last element from the count as we will add a new one in the next iteration
                    blndcnt_lsb = _mm256_adds_epi8(blndcnt_lsb, 
                                                   _mm256_blendv_epi8(mb, ma, 
                                                                      movemask_inverse(blndBuf[f_blendpos].x&mask32)));

                    r_blndcnt_lsb = _mm256_adds_epi8(r_blndcnt_lsb, 
                                                   _mm256_blendv_epi8(mb, ma, 
                                                                      movemask_inverse(blndBuf[f_blendpos].y&mask32)));

                    sk_blndcnt_lsb = _mm256_adds_epi8(sk_blndcnt_lsb, 
                                                   _mm256_blendv_epi8(mb, ma, 
                                                                      movemask_inverse(blndBuf[f_blendpos].sk_x&mask32)));

                    skr_blndcnt_lsb = _mm256_adds_epi8(skr_blndcnt_lsb, 
                                                   _mm256_blendv_epi8(mb, ma, 
                                                                      movemask_inverse(blndBuf[f_blendpos].sk_y&mask32)));
                    if(blndK > 32){

                        tmp1 = _mm256_movemask_epi8(_mm256_cmpgt_epi8(mg, _mm256_abs_epi8(blndcnt_msb)));
                        tmp2 = _mm256_movemask_epi8(_mm256_cmpgt_epi8(_mm256_abs_epi8(sk_blndcnt_msb), mg));
                        blendVal |= ((uint64_t)_mm256_movemask_epi8(_mm256_blendv_epi8(blndcnt_msb, sk_blndcnt_msb,
                                                                            movemask_inverse(tmp1&tmp2))))<<32;

                        tmp1 = _mm256_movemask_epi8(_mm256_cmpgt_epi8(mg, _mm256_abs_epi8(r_blndcnt_msb)));
                        tmp2 = _mm256_movemask_epi8(_mm256_cmpgt_epi8(_mm256_abs_epi8(skr_blndcnt_msb), mg));
                        r_blendVal |= ((uint64_t)_mm256_movemask_epi8(_mm256_blendv_epi8(r_blndcnt_msb, skr_blndcnt_msb,
                                                                              movemask_inverse(tmp1&tmp2))))<<32;

                        blndcnt_msb = _mm256_adds_epi8(blndcnt_msb,
                                                      _mm256_blendv_epi8(mb, ma,
                                                                         movemask_inverse((blndBuf[f_blendpos].x>>32)&mask32)));

                        r_blndcnt_msb = _mm256_adds_epi8(r_blndcnt_msb,
                                                      _mm256_blendv_epi8(mb, ma,
                                                                         movemask_inverse((blndBuf[f_blendpos].y>>32)&mask32)));

                        sk_blndcnt_msb = _mm256_adds_epi8(sk_blndcnt_msb,
                                                      _mm256_blendv_epi8(mb, ma,
                                                                         movemask_inverse((blndBuf[f_blendpos].sk_x>>32)&mask32)));

                        skr_blndcnt_msb = _mm256_adds_epi8(skr_blndcnt_msb,
                                                      _mm256_blendv_epi8(mb, ma,
                                                                         movemask_inverse((blndBuf[f_blendpos].sk_y>>32)&mask32)));
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
                    //@IMPORTANT: should we really include the first few hash values in the index?
                    z = (kmer[0] < kmer[1])?0:1;
                    info.x = hkmer[z] << 14 | kmer_span;
                    info.y = (uint64_t)rid<<32 | (uint32_t)i<<1 | z;
                }
            }
        } else l = 0, tq.count = tq.front = 0, kmer_span = 0;
        buf[buf_pos] = info; // need to do this here as appropriate buf_pos and buf[buf_pos] are needed below
        blndBuf[l_blendpos].x = hkmer[0];
        blndBuf[l_blendpos].y = hkmer[1];
        blndBuf[l_blendpos].sk_x = hkmer[2];
        blndBuf[l_blendpos].sk_y = hkmer[3];
        blndBuf[l_blendpos].i = i;
        blndBuf[l_blendpos].k = kmer_span;
        
        if (l == w + k - 1 && min.x != UINT64_MAX){ // special case for the first window - because identical k-mers are not stored yet
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
            if (l >= w + k - 1 && min.x != UINT64_MAX){ // write identical k-mers
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
               int is_skewed,
               int is_strobs,
               mm128_v *p){
    
    if(is_skewed > 0)
        mm_sketch_sk_blend(km, str, len, w, blend_bits, k, n_neighbors, rid, is_hpc, p);
    else if(is_strobs)
        mm_sketch_sb_blend(km, str, len, w, blend_bits, k, n_neighbors, rid, is_hpc, p);
    else mm_sketch_blend(km, str, len, w, blend_bits, k, n_neighbors, rid, is_hpc, p);
}
