#!/bin/bash

OUTDIR=$1
PREFIX=$2
READS=$3
PRESETX=$4
PRESETGEN=$5
THREAD=$6
PARAMS=$7 #parameters to set on top of the default parameters

/usr/bin/time -v -p -o "${OUTDIR}/${PREFIX}_blend.time" blend -x ${PRESETX} --genome ${PRESETGEN} -t ${THREAD} ${PARAMS} ${READS} ${READS} > "${OUTDIR}/${PREFIX}_blend.paf"
/usr/bin/time -v -p -o "${OUTDIR}/${PREFIX}_miniasm.time" miniasm -s 500 -c 2 -f ${READS} "${OUTDIR}/${PREFIX}_blend.paf" | awk '/^S/{print ">"$2"\n"$3}' | fold > "${OUTDIR}/${PREFIX}_blend_contigs.fasta"

