#!/bin/bash

OUTDIR=$1
PREFIX=$2
READS=$3
PRESET=$4
THREAD=$5

/usr/bin/time -v -p -o "${OUTDIR}/${PREFIX}_minimap2.time" minimap2 -x ${PRESET} -t ${THREAD} ${READS} ${READS} > "${OUTDIR}/${PREFIX}_minimap2.paf"
/usr/bin/time -v -p -o "${OUTDIR}/${PREFIX}_miniasm.time" miniasm -s 500 -c 2 -f ${READS} "${OUTDIR}/${PREFIX}_minimap2.paf" | awk '/^S/{print ">"$2"\n"$3}' | fold > "${OUTDIR}/${PREFIX}_minimap2_contigs.fasta"

