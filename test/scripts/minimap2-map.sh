#!/bin/bash

OUTDIR=$1
PREFIX=$2
READS=$3
REF=$4
PRESET=$5
THREAD=$6
THREAD_SORT=$7
PARAMS=$8 #parameters to set on top of the default parameters

/usr/bin/time -v -p -o "${OUTDIR}/${PREFIX}_minimap2_index.time" minimap2 -x ${PRESET} -t ${THREAD} -d "${OUTDIR}/${PREFIX}_minimap2.ind" ${PARAMS} ${REF}
/usr/bin/time -v -p -o "${OUTDIR}/${PREFIX}_minimap2_map.time" minimap2 -ax ${PRESET} -t ${THREAD} --secondary=no ${PARAMS} "${OUTDIR}/${PREFIX}_minimap2.ind" ${READS} | samtools sort -l5 -m4G -@ ${THREAD_SORT} -o "${OUTDIR}/${PREFIX}_minimap2.bam"
samtools index "${OUTDIR}/${PREFIX}_minimap2.bam"

