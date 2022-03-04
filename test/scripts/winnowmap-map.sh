#!/bin/bash

OUTDIR=$1
PREFIX=$2
READS=$3
REF=$4
THREAD=$5
THREAD_SORT=$6
PRESET=$7

/usr/bin/time -v -p -o "${OUTDIR}/${PREFIX}_meryl_count.time" meryl count k=15 output "${OUTDIR}/${PREFIX}_merylDB" ${REF}
/usr/bin/time -v -p -o "${OUTDIR}/${PREFIX}_meryl_print.time" meryl print greater-than distinct=0.9998 "${OUTDIR}/${PREFIX}_merylDB" > "${OUTDIR}/${PREFIX}_repetitive_k15.txt"
/usr/bin/time -v -p -o "${OUTDIR}/${PREFIX}_winnowmap.time" winnowmap -W "${OUTDIR}/${PREFIX}_repetitive_k15.txt" -ax ${PRESET} -t ${THREAD} ${REF} ${READS} | samtools sort -l5 -m4G -@ ${THREAD_SORT} -o "${OUTDIR}/${PREFIX}_winnowmap.bam"
samtools index "${OUTDIR}/${PREFIX}_winnowmap.bam"

