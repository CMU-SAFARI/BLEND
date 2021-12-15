#!/bin/bash

OUTDIR=$1
PREFIX=$2
READS=$3
THREAD=$4

/usr/bin/time -v -p -o "${OUTDIR}/${PREFIX}_mhap.time" mhap --num-threads ${THREAD} -s ${READS} -q ${READS} > ${OUTDIR}/${PREFIX}_mhap.out

