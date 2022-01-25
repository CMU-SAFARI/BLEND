#!/bin/bash

OUTDIR=$1
PREFIX=$2
READS=$3
REF=$4
PRESET=$5 #CCS, CLR, ONT, CONTIG
THREAD=$6
THREAD_SORT=$7

/usr/bin/time -v -p -o "${OUTDIR}/${PREFIX}_lra-index.time" lra index -${PRESET} ${REF}
/usr/bin/time -v -p -o "${OUTDIR}/${PREFIX}_lra.time" lra align -${PRESET} -t ${THREAD} -p s ${REF} ${READS} | samtools sort -l5 -m4G -@ ${THREAD_SORT} -o "${OUTDIR}/${PREFIX}_lra.bam"
samtools index "${OUTDIR}/${PREFIX}_lra.bam"

