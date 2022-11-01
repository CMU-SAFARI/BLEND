#!/bin/bash

THREAD=32
THREAD_SORT=8
TOT_THREAD=40

SLURM_OPTIONS="-p bio"

#yeast-illumina
OUTDIR="./yeast-illumina/read_mapping/"
READS1="../data/yeast-illumina/ERR1938683_1.fastq"
READS2="../data/yeast-illumina/ERR1938683_2.fastq"
REF="../data/yeast-illumina/ref.fa"

mkdir -p ${OUTDIR}

PREFIX="ERR1938683"
sbatch -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c ${THREAD} -J ${PREFIX} ${SLURM_OPTIONS} --wrap="bash ../scripts/strobealign-map_short.sh ${OUTDIR} ${PREFIX} ${READS1} ${READS2} ${REF} ${THREAD} ${THREAD_SORT}"
