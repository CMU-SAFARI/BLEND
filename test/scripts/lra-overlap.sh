#!/bin/bash

OUTDIR=$1
PREFIX=$2
READS=$3
REF=$4 #FASTA version of reads
PRESET=$5 #CCS, CLR, ONT, CONTIG
THREAD=$6

/usr/bin/time -v -p -o "${OUTDIR}/${PREFIX}_lra-index.time" lra index -${PRESET} ${REF}
/usr/bin/time -v -p -o "${OUTDIR}/${PREFIX}_lra.time" lra align -${PRESET} -t ${THREAD} -p p ${REF} ${READS} > "${OUTDIR}/${PREFIX}_lra.paf"

