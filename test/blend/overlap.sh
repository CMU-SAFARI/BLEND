#!/bin/bash

THREAD=32

#e.coli-pb-sequelii
OUTDIR="./e.coli-pb-sequelii/overlap/"
READS="../data/e.coli-pb-sequelii/Ecoli.PB.HiFi.100X.fastq"
PRESETX="ava-hifi"

mkdir -p ${OUTDIR}

PREFIX="Ecoli.PB.HiFi.100X_strobemers"
bash ../scripts/blend-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESETX} ${THREAD} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

PREFIX="Ecoli.PB.HiFi.100X"
PARAMS="--immediate"
bash ../scripts/blend-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESETX} ${THREAD} ${PARAMS} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#yeast-pb-pbsim-200x
OUTDIR="./yeast-pb-pbsim-200x/overlap/"
READS="../data/yeast-pb-pbsim2/pbsim_yeast_200x.fasta"
PRESETX="ava-pb"

mkdir -p ${OUTDIR}

PREFIX="pbsim_yeast_200x"
bash ../scripts/blend-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESETX} ${THREAD} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

PREFIX="pbsim_yeast_200x_strobemers"
PARAMS="--strobemers -k19 -w5 --neighbors=5 --fixed-bits=38"
bash ../scripts/blend-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESETX} ${THREAD} ${PARAMS} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#yeast-ont-pbsim-100x
OUTDIR="./yeast-ont-pbsim-100x/overlap/"
READS="../data/yeast-ont-pbsim2/pbsim_yeast_100x.fasta"
PRESETX="ava-ont"

mkdir -p ${OUTDIR}

PREFIX="pbsim_yeast_100x"
bash ../scripts/blend-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESETX} ${THREAD} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

PREFIX="pbsim_yeast_100x_strobemers"
PARAMS="--strobemers -k15 -w5 --neighbors=5 --fixed-bits=30"
bash ../scripts/blend-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESETX} ${THREAD} ${PARAMS} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#d.ananassae-pb-sequelii
OUTDIR="./d.ananassae-pb-sequelii/overlap/"
READS="../data/d.ananassae-pb-sequelii/Dana.PB.HiFi.50X.fastq"
PRESETX="ava-hifi"

mkdir -p ${OUTDIR}

PREFIX="Dana.PB.HiFi.50X_strobemers"
bash ../scripts/blend-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESETX} ${THREAD} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

PREFIX="Dana.PB.HiFi.50X"
PARAMS="--immediate"
bash ../scripts/blend-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESETX} ${THREAD} ${PARAMS} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#chm13-pb-sequelii-16X
OUTDIR="./chm13-pb-sequelii-16X/overlap/"
READS="../data/chm13-pb-sequelii-16X/SRR11292122-3_subreads.fastq"
PRESETX="ava-hifi"

mkdir -p ${OUTDIR}

PREFIX="SRR11292122-3_subreads_strobemers"
bash ../scripts/blend-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESETX} ${THREAD} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

PREFIX="SRR11292122-3_subreads"
PARAMS="--immediate"
bash ../scripts/blend-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESETX} ${THREAD} ${PARAMS} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

