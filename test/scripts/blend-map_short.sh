#!/bin/bash

OUTDIR=$1
PREFIX=$2
READS1=$3
READS2=$4
REF=$5
PRESETGEN=$6
THREAD=$7
THREAD_SORT=$8
PARAMS=$9 #parameters to set on top of the default parameters

/usr/bin/time -v -p -o "${OUTDIR}/${PREFIX}_blend_index.time" blend -x sr --genome ${PRESETGEN} -t ${THREAD} -d "${OUTDIR}/${PREFIX}_blend.ind" ${PARAMS} ${REF}
/usr/bin/time -v -p -o "${OUTDIR}/${PREFIX}_blend_map.time" blend -ax sr --genome ${PRESETGEN} -t ${THREAD} ${PARAMS} "${OUTDIR}/${PREFIX}_blend.ind" ${READS1} ${READS2} | samtools sort -l5 -m4G -@ ${THREAD_SORT} -o "${OUTDIR}/${PREFIX}_blend.bam"
samtools index "${OUTDIR}/${PREFIX}_blend.bam"

