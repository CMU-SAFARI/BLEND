#!/bin/bash

THREAD=32

#chm13-pb-sequelii-16X
OUTDIR="./chm13-pb-sequelii-16X/overlap/"
PREFIX="SRR11292122-3_subreads"
READS="../data/chm13-pb-sequelii-16X/SRR11292122-3_subreads.fastq"
PRESET="ava-pb"

mkdir -p ${OUTDIR}
bash ../scripts/minimap2-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESET} ${THREAD} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#d.ananassae-pb-sequelii
OUTDIR="./d.ananassae-pb-sequelii/overlap/"
PREFIX="Dana.PB.HiFi.50X"
READS="../data/d.ananassae-pb-sequelii/Dana.PB.HiFi.50X.fastq"
PRESET="ava-pb"

mkdir -p ${OUTDIR}
bash ../scripts/minimap2-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESET} ${THREAD} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#e.coli-pb-sequelii
OUTDIR="./e.coli-pb-sequelii/overlap/"
PREFIX="Ecoli.PB.HiFi.100X"
READS="../data/e.coli-pb-sequelii/Ecoli.PB.HiFi.100X.fastq"
PRESET="ava-pb"

mkdir -p ${OUTDIR}
bash ../scripts/minimap2-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESET} ${THREAD} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#yeast-pb-pbsim-200x
OUTDIR="./yeast-pb-pbsim-200x/overlap/"
PREFIX="pbsim_yeast_200x"
READS="../data/yeast-pb-pbsim/pbsim_yeast_200x.fastq"
PRESET="ava-pb"

mkdir -p ${OUTDIR}
bash ../scripts/minimap2-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESET} ${THREAD} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

