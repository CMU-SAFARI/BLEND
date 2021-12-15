#!/bin/bash

THREAD=32

#e.coli-pb-sequelii
OUTDIR="./e.coli-pb-sequelii/overlap/"
PREFIX="Ecoli.PB.HiFi.100X"
READS="../data/e.coli-pb-sequelii/Ecoli.PB.HiFi.100X.fastq"
PRESETX="ava-hifi"
PRESETGEN="bacteria"

mkdir -p ${OUTDIR}
bash ../scripts/blend-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESETX} ${PRESETGEN} ${THREAD} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#yeast-pb-pbsim-200x
OUTDIR="./yeast-pb-pbsim/overlap/"
PREFIX="pbsim_yeast_200x"
READS="../data/yeast-pb-pbsim/pbsim_yeast_200x.fastq"
PRESETX="ava-pb"
PRESETGEN="eukaryote"

mkdir -p ${OUTDIR}
bash ../scripts/blend-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESETX} ${PRESETGEN} ${THREAD} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#d.ananassae-pb-sequelii
OUTDIR="./d.ananassae-pb-sequelii/overlap/"
PREFIX="Dana.PB.HiFi.50X"
READS="../data/d.ananassae-pb-sequelii/Dana.PB.HiFi.50X.fastq"
PRESETX="ava-hifi"
PRESETGEN="eukaryote"

mkdir -p ${OUTDIR}
bash ../scripts/blend-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESETX} ${PRESETGEN} ${THREAD} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#chm13-pb-sequelii-16X
OUTDIR="./chm13-pb-sequelii-16X/overlap/"
PREFIX="SRR11292122-3_subreads"
READS="../data/chm13-pb-sequelii-16X/SRR11292122-3_subreads.fastq"
PRESETX="ava-hifi"
PRESETGEN="human"

mkdir -p ${OUTDIR}
bash ../scripts/blend-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESETX} ${PRESETGEN} ${THREAD} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

