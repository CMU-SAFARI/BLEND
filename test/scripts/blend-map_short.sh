#!/bin/bash

OUTDIR=$1
PREFIX=$2
READS1=$3
READS2=$4
REF=$5
THREAD=$6
THREAD_SORT=$7
PARAMS=$8 #parameters to set on top of the default parameters

/usr/bin/time -v -p -o "${OUTDIR}/${PREFIX}_blend_index.time" blend -x sr -t ${THREAD} -d "${OUTDIR}/${PREFIX}_blend.ind" ${PARAMS} ${REF}
/usr/bin/time -v -p -o "${OUTDIR}/${PREFIX}_blend_map.time" blend -ax sr -t ${THREAD} ${PARAMS} "${OUTDIR}/${PREFIX}_blend.ind" ${READS1} ${READS2} | samtools sort -l5 -m4G -@ ${THREAD_SORT} -o "${OUTDIR}/${PREFIX}_blend.bam"
samtools index "${OUTDIR}/${PREFIX}_blend.bam"

