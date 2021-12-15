#!/bin/bash

OUTDIR=$1
PREFIX=$2
READS1=$3
READS2=$4
REF=$5
THREAD=$6
THREAD_SORT=$7

/usr/bin/time -v -p -o "${OUTDIR}/${PREFIX}_minimap2_index.time" minimap2 -x sr -t ${THREAD} -d "${OUTDIR}/${PREFIX}_minimap2.ind" ${REF}
/usr/bin/time -v -p -o "${OUTDIR}/${PREFIX}_minimap2_map.time" minimap2 -ax sr -t ${THREAD} "${OUTDIR}/${PREFIX}_minimap2.ind" ${READS1} ${READS2} | samtools sort -l5 -m4G -@ ${THREAD_SORT} -o "${OUTDIR}/${PREFIX}_minimap2.bam"
samtools index "${OUTDIR}/${PREFIX}_minimap2.bam"

