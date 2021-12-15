#!/bin/bash

OUTDIR=$1
PREFIX=$2
READS=$3
REF=$4
THREAD=$5

/usr/bin/time -v -p -o "${OUTDIR}/${PREFIX}_blasr.time" blasr ${READS} ${REF} --nproc ${THREAD} --out "${OUTDIR}/${PREFIX}_blasr.out"

