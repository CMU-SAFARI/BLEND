#!/bin/bash

BASE_DIR=$1
THREAD=$2

mkdir -p ${BASE_DIR}/dnadiff
for i in `echo ${BASE_DIR}/*.fasta`; do fname=`basename $i | sed s/.fasta/_dnadiff/g`; 
nucmer -l 100 -c 1000 -t ${THREAD} -p ${BASE_DIR}/dnadiff/$fname ${BASE_DIR}/ref.fa $i > ${BASE_DIR}/dnadiff/$fname.stdout 2> ${BASE_DIR}/dnadiff/$fname.stderr;
dnadiff -d ${BASE_DIR}/dnadiff/$fname.delta -p ${BASE_DIR}/dnadiff/$fname >> ${BASE_DIR}/dnadiff/$fname.stdout 2>> ${BASE_DIR}/dnadiff/$fname.stderr; 
done

mkdir -p ${BASE_DIR}/quast
quast -t ${THREAD} -m 0 -o ${BASE_DIR}/quast --k-mer-size 13 --large -r ${BASE_DIR}/ref.fa -k ${BASE_DIR}/*.fasta ${BASE_DIR}/ref.fa > ${BASE_DIR}/quast/quast.stdout 2> ${BASE_DIR}/quast/quast.stderr

for i in `echo ${BASE_DIR}/*.paf`; do fname=`basename $i | sed s/.paf//g`; bash ../../../scripts/overlap_stats.sh ${BASE_DIR}/$fname; done
