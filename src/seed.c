#include "mmpriv.h"
#include "kalloc.h"
#include "ksort.h"

void mm_seed_mz_flt(void *km, mm128_v *mv, int32_t q_occ_max, float q_occ_frac)
{
	mm128_t *a;
	size_t i, j, st;
	if (mv->n <= q_occ_max || q_occ_frac <= 0.0f || q_occ_max <= 0) return;
	KMALLOC(km, a, mv->n);
	for (i = 0; i < mv->n; ++i)
		a[i].x = mv->a[i].x, a[i].y = i;
	radix_sort_128x(a, a + mv->n);
	for (st = 0, i = 1; i <= mv->n; ++i) {
		if (i == mv->n || a[i].x != a[st].x) {
			int32_t cnt = i - st;
			if (cnt > q_occ_max && cnt > mv->n * q_occ_frac)
				for (j = st; j < i; ++j)
					mv->a[a[j].y].x = 0;
			st = i;
		}
	}
	kfree(km, a);
	for (i = j = 0; i < mv->n; ++i)
		if (mv->a[i].x != 0)
			mv->a[j++] = mv->a[i];
	mv->n = j;
}

/*
n_m_ is not necessarily number of seeds in a query sequence. Instead: number of seeds that appear in both
query sequence and target sequences.
returned mm_seed_t 
however the size of m is still fixed to the number of seeds in query sequence (worst case scenerio)
*/
mm_seed_t *mm_seed_collect_all(void *km, const mm_idx_t *mi, const mm128_v *mv, int32_t *n_m_)
{
	mm_seed_t *m;
	size_t i;
	int32_t k;
	m = (mm_seed_t*)kmalloc(km, mv->n * sizeof(mm_seed_t));
	for (i = k = 0; i < mv->n; ++i) {
		const uint64_t *cr; //cr is what kh_value(h,k) returns -- values for a key or position array of values in target
		mm_seed_t *q; //to point to the seed matches in the target sequences based on a query seed
		mm128_t *p = &mv->a[i]; //query seed
		//@IMPORTANT: Right now we shift 14 bits to right and take the least significant
		//32-bits. Some of the most significant bits remain garbage but we could use them
		//think about it later. -- update: it's now enabled. Subject to change.
		uint32_t q_pos = (uint32_t)p->y, q_span = p->x & 0x3fff; //@IMPORTANT: 14bits reserved for the span so should use 3fff instead if we can figure out the entire position storage mechanism
		int t;
		//we are checking whether (t) we have seeds with the same hash (p->x>>14) value in the index (mi)
		//t number of target matches for a single query seed
		cr = mm_idx_get(mi, p->x>>14, &t);
		if (t == 0) continue; //if there is no match, continue?
		q = &m[k++];
		q->q_pos = q_pos, q->q_span = q_span, q->cr = cr, q->n = t, q->seg_id = p->y >> 32;
		q->is_tandem = q->flt = 0;
		//@IMPORTANT: we disable tandem repeat feature for now as we cannot say anything about it
		//when using the blend values -- update: it's now enabled. Subject to change.
		if (i > 0 && p->x>>14 == mv->a[i - 1].x>>14) q->is_tandem = 1;
		if (i < mv->n - 1 && p->x>>14 == mv->a[i + 1].x>>14) q->is_tandem = 1;
	}
	*n_m_ = k;
	return m;
}

#define MAX_MAX_HIGH_OCC 128

void mm_seed_select(int32_t n, mm_seed_t *a, int len, int max_occ, int max_max_occ, int dist)
{ // for high-occ minimizers, choose up to max_high_occ in each high-occ streak
	extern void ks_heapdown_uint64_t(size_t i, size_t n, uint64_t*);
	extern void ks_heapmake_uint64_t(size_t n, uint64_t*);
	int32_t i, last0, m;
	uint64_t b[MAX_MAX_HIGH_OCC]; // this is to avoid a heap allocation

	if (n == 0 || n == 1) return;
	for (i = m = 0; i < n; ++i)
		if (a[i].n > max_occ) ++m;
	if (m == 0) return; // no high-frequency k-mers; do nothing
	for (i = 0, last0 = -1; i <= n; ++i) {
		if (i == n || a[i].n <= max_occ) {
			if (i - last0 > 1) {
				int32_t ps = last0 < 0? 0 : (uint32_t)a[last0].q_pos>>1;
				int32_t pe = i == n? len : (uint32_t)a[i].q_pos>>1;
				int32_t j, k, st = last0 + 1, en = i;
				int32_t max_high_occ = (int32_t)((double)(pe - ps) / dist + .499);
				if (max_high_occ > 0) {
					if (max_high_occ > MAX_MAX_HIGH_OCC)
						max_high_occ = MAX_MAX_HIGH_OCC;
					for (j = st, k = 0; j < en && k < max_high_occ; ++j, ++k)
						b[k] = (uint64_t)a[j].n<<32 | j;
					ks_heapmake_uint64_t(k, b); // initialize the binomial heap
					for (; j < en; ++j) { // if there are more, choose top max_high_occ
						if (a[j].n < (int32_t)(b[0]>>32)) { // then update the heap
							b[0] = (uint64_t)a[j].n<<32 | j;
							ks_heapdown_uint64_t(0, k, b);
						}
					}
					for (j = 0; j < k; ++j) a[(uint32_t)b[j]].flt = 1;
				}
				for (j = st; j < en; ++j) a[j].flt ^= 1;
				for (j = st; j < en; ++j)
					if (a[j].n > max_max_occ)
						a[j].flt = 1;
			}
			last0 = i;
		}
	}
}

mm_seed_t *mm_collect_matches(void *km, int *_n_m, int qlen, int max_occ, int max_max_occ, int dist, const mm_idx_t *mi, const mm128_v *mv, int64_t *n_a, int *rep_len, int *n_mini_pos, uint64_t **mini_pos)
{
	int rep_st = 0, rep_en = 0, n_m, n_m0;
	size_t i;
	mm_seed_t *m;
	*n_mini_pos = 0;
	*mini_pos = (uint64_t*)kmalloc(km, mv->n * sizeof(uint64_t));
	m = mm_seed_collect_all(km, mi, mv, &n_m0);
	if (dist > 0 && max_max_occ > max_occ) {
		// printf("%s1\n", __func__);
		mm_seed_select(n_m0, m, qlen, max_occ, max_max_occ, dist);
	} else {
		// printf("%s2\n", __func__);
		for (i = 0; i < n_m0; ++i)
			if (m[i].n > max_occ)
				m[i].flt = 1;
	}
	//repacking m (seed matches) again 
	for (i = 0, n_m = 0, *rep_len = 0, *n_a = 0; i < n_m0; ++i) {
		mm_seed_t *q = &m[i];
		//fprintf(stderr, "X\t%d\t%d\t%d\n", q->q_pos>>1, q->n, q->flt);
		if (q->flt) {
			int en = (q->q_pos >> 1) + 1, st = en - q->q_span;
			if (st > rep_en) {
				*rep_len += rep_en - rep_st;
				rep_st = st, rep_en = en;
			} else rep_en = en;
		} else {
			*n_a += q->n;
			(*mini_pos)[(*n_mini_pos)++] = (uint64_t)q->q_span<<32 | q->q_pos>>1;
			m[n_m++] = *q;
		}
	}
	*rep_len += rep_en - rep_st;
	*_n_m = n_m;
	return m;
}
