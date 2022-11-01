#!/bin/bash

THREAD=32

#e.coli-pb-sequelii
OUTDIR="./e.coli-pb-sequelii/overlap/"
READS="../data/e.coli-pb-sequelii/Ecoli.PB.HiFi.100X.fastq"
PRESETX="ava-hifi"

mkdir -p ${OUTDIR}

#The following is the run using default parameters:
PREFIX="Ecoli.PB.HiFi.100X"
bash ../scripts/blend-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESETX} ${THREAD} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

PREFIX="Ecoli.PB.HiFi.100X_blendi"
PARAMS="--immediate"
bash ../scripts/blend-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESETX} ${THREAD} "${PARAMS}" > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#e.coli-pb-rs
OUTDIR="./e.coli-pb-rs/overlap/"
READS="../data/e.coli-pb-rs/SRR1509640_subreads.fastq"
PRESETX="ava-pb"

mkdir -p ${OUTDIR}

#The following is the run using default parameters:
PREFIX="SRR1509640_subreads"
bash ../scripts/blend-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESETX} ${THREAD} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

PREFIX="SRR1509640_subreads_blends"
PARAMS="--strobemers"
bash ../scripts/blend-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESETX} ${THREAD} "${PARAMS}" > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#yeast-pb-pbsim-200x
OUTDIR="./yeast-pb-pbsim-200x/overlap/"
READS="../data/yeast-pb-pbsim2/pbsim_yeast_200x.fasta"
PRESETX="ava-pb"

mkdir -p ${OUTDIR}

#The following is the run using default parameters:
PREFIX="pbsim_yeast_200x"
bash ../scripts/blend-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESETX} ${THREAD} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

PREFIX="pbsim_yeast_200x_blends"
PARAMS="--strobemers"
bash ../scripts/blend-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESETX} ${THREAD} "${PARAMS}" > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#yeast-ont-pbsim-100x
OUTDIR="./yeast-ont-pbsim-100x/overlap/"
READS="../data/yeast-ont-pbsim2/pbsim_yeast_100x.fasta"
PRESETX="ava-ont"

mkdir -p ${OUTDIR}

#The following is the run using default parameters:
PREFIX="pbsim_yeast_100x"
bash ../scripts/blend-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESETX} ${THREAD} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

PREFIX="pbsim_yeast_100x_blends"
PARAMS="--strobemers"
bash ../scripts/blend-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESETX} ${THREAD} "${PARAMS}" > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#d.ananassae-pb-sequelii
OUTDIR="./d.ananassae-pb-sequelii/overlap/"
READS="../data/d.ananassae-pb-sequelii/Dana.PB.HiFi.50X.fastq"
PRESETX="ava-hifi"

mkdir -p ${OUTDIR}

#The following is the run using default parameters:
PREFIX="Dana.PB.HiFi.50X"
bash ../scripts/blend-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESETX} ${THREAD} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

PREFIX="Dana.PB.HiFi.50X_blendi"
PARAMS="--immediate"
bash ../scripts/blend-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESETX} ${THREAD} "${PARAMS}" > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#chm13-pb-sequelii-16X
OUTDIR="./chm13-pb-sequelii-16X/overlap/"
READS="../data/chm13-pb-sequelii-16X/SRR11292122-3_subreads.fastq"
PRESETX="ava-hifi"

mkdir -p ${OUTDIR}

#The following is the run using default parameters:
PREFIX="SRR11292122-3_subreads"
bash ../scripts/blend-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESETX} ${THREAD} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

PREFIX="SRR11292122-3_subreads_blendi"
PARAMS="--immediate"
bash ../scripts/blend-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESETX} ${THREAD} "${PARAMS}" > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#chm13-ont-pbsim2
OUTDIR="./chm13-ont-pbsim2/overlap/"
READS="../data/chm13-ont-pbsim2/pbsim_chm13_30x.fasta"
PRESETX="ava-ont"

mkdir -p ${OUTDIR}

#The following is the run using default parameters:
PREFIX="pbsim_chm13_30x"
bash ../scripts/blend-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESETX} ${THREAD} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

PREFIX="pbsim_chm13_30x_blends"
PARAMS="--strobemers"
bash ../scripts/blend-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESETX} ${THREAD} "${PARAMS}" > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err
