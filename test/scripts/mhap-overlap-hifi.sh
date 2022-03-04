#!/bin/bash

OUTDIR=$1
PREFIX=$2
READS=$3
THREAD=$4
SCRIPT_LOC=$5

/usr/bin/time -v -p -o "${OUTDIR}/${PREFIX}_mhap.time" mhap --store-full-id --ordered-kmer-size 18 --num-hashes 128 --num-min-matches 5 --ordered-sketch-size 1000 --threshold 0.95 --num-threads ${THREAD} -s ${READS} -q ${READS} | "${SCRIPT_LOC}/mhap2paf.pl" > ${OUTDIR}/${PREFIX}_mhap.paf
/usr/bin/time -v -p -o "${OUTDIR}/${PREFIX}_miniasm.time" miniasm -s 500 -c 2 -f ${READS} "${OUTDIR}/${PREFIX}_mhap.paf" | awk '/^S/{print ">"$2"\n"$3}' | fold > "${OUTDIR}/${PREFIX}_mhap_contigs.fasta"

