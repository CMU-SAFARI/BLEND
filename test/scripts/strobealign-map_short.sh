#!/bin/bash

OUTDIR=$1
PREFIX=$2
READS1=$3
READS2=$4
REF=$5
THREAD=$6
THREAD_SORT=$7
PARAMS=$8 #parameters to set on top of the default parameters

/usr/bin/time -vpo "${OUTDIR}/${PREFIX}_strobealign_map.time" strobealign -t ${THREAD} ${PARAMS} ${REF} ${READS1} ${READS2} | samtools sort -l5 -m4G -@ ${THREAD_SORT} -o "${OUTDIR}/${PREFIX}_strobealign.bam"
samtools index "${OUTDIR}/${PREFIX}_strobealign.bam"
