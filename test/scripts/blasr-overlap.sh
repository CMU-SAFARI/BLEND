#!/bin/bash

OUTDIR=$1
PREFIX=$2
READS=$3
THREAD=$4

/usr/bin/time -v -p -o "${OUTDIR}/${PREFIX}_blasr.time" blasr ${READS} ${READS} --nproc ${THREAD} --out "${OUTDIR}/${PREFIX}_blasr.out"

