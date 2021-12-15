#!/bin/bash

BASE_DIR=$1

mkdir -p ${BASE_DIR}/dnadiff
for i in `echo ${BASE_DIR}/*.fasta`; do fname=`basename $i | sed s/.fasta/_dnadiff/g`; 
nucmer -l 100 -c 1000 -t 32 -p ${BASE_DIR}/dnadiff/$fname ${BASE_DIR}/ref.fa $i > ${BASE_DIR}/dnadiff/$fname.stdout 2> ${BASE_DIR}/dnadiff/$fname.stderr;
dnadiff -d ${BASE_DIR}/dnadiff/$fname.delta -p ${BASE_DIR}/dnadiff/$fname >> ${BASE_DIR}/dnadiff/$fname.stdout 2>> ${BASE_DIR}/dnadiff/$fname.stderr; 
done

mkdir -p ${BASE_DIR}/quast
quast -t 32 -m 0 -o ${BASE_DIR}/quast --large -r ${BASE_DIR}/ref.fa -k ${BASE_DIR}/*.fasta ${BASE_DIR}/ref.fa > ${BASE_DIR}/quast/quast.stdout 2> ${BASE_DIR}/quast/quast.stderr

for i in `echo ${BASE_DIR}/*.paf`; do fname=`basename $i | sed s/.paf//g`; bash ../../../scripts/overlap_stats.sh ${BASE_DIR}/$fname; done

bash ../../../scripts/overlap_stats_blastout.sh ${BASE_DIR}/mhap

bash ../../../scripts/overlap_stats_blastout.sh ${BASE_DIR}/blasr

echo 'Dnadiff results (genome fraction and average identity is based on AlignedBases and AvgIdentity (M-to-M) in the second line of AvgIdentity:';
for i in `echo ${BASE_DIR}/dnadiff/*.report`; do echo $i; grep "AlignedBases" $i; grep "AvgIdentity" $i | head -2; done

echo;
echo 'QUAST reasults are under the quast directory.';
echo 'For the Assembly Length, Largest Contig, N50, Number of contigs, Avg GC, GC distribution, K-mer completeness results,'
echo 'Please check either report.html or report.pdf under the quast directory'

echo;
echo 'Overlap Statistics';
for i in `echo ${BASE_DIR}/*_overlap.stats`; do echo $i; cat $i; done

