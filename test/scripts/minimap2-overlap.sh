#!/bin/bash

OUTDIR=$1
PREFIX=$2
READS=$3
PRESET=$4
THREAD=$5
PARAMS=$6 #parameters to set on top of the default parameters

/usr/bin/time -v -p -o "${OUTDIR}/${PREFIX}_minimap2.time" minimap2 -x ${PRESET} -t ${THREAD} ${PARAMS} ${READS} ${READS} > "${OUTDIR}/${PREFIX}_minimap2.paf"
/usr/bin/time -v -p -o "${OUTDIR}/${PREFIX}_miniasm.time" miniasm -s 500 -c 2 -f ${READS} "${OUTDIR}/${PREFIX}_minimap2.paf" | awk '/^S/{print ">"$2"\n"$3}' | fold > "${OUTDIR}/${PREFIX}_minimap2_contigs.fasta"

