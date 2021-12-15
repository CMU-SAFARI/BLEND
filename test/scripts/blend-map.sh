#!/bin/bash

OUTDIR=$1
PREFIX=$2
READS=$3
REF=$4
PRESETX=$5
PRESETGEN=$6
THREAD=$7
THREAD_SORT=$8

/usr/bin/time -v -p -o "${OUTDIR}/${PREFIX}_blend_index.time" blend -x ${PRESETX} --genome ${PRESETGEN} -t ${THREAD} -d "${OUTDIR}/${PREFIX}_blend.ind" ${REF}
/usr/bin/time -v -p -o "${OUTDIR}/${PREFIX}_blend_map.time" blend -ax ${PRESETX} --genome ${PRESETGEN} -t ${THREAD} --secondary=no "${OUTDIR}/${PREFIX}_blend.ind" ${READS} | samtools sort -l5 -m4G -@ ${THREAD_SORT} -o "${OUTDIR}/${PREFIX}_blend.bam"
samtools index "${OUTDIR}/${PREFIX}_blend.bam"

