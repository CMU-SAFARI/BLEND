#!/bin/bash

OUTDIR=$1
PREFIX=$2
READS=$3
REF=$4
THREAD=$5

/usr/bin/time -v -p -o "${OUTDIR}/${PREFIX}_conlsh.time" S-conLSH --threads ${THREAD} ${OUTDIR} ${REF} ${READS} --align 1 > "${OUTDIR}/${PREFIX}_conlsh.sam"

