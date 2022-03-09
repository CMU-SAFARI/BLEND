#!/bin/bash

THREAD=32
THREAD_SORT=8
TOT_THREAD=40

#e.coli-pb-sequelii
OUTDIR="./e.coli-pb-sequelii/read_mapping/"
READS="../data/e.coli-pb-sequelii/Ecoli.PB.HiFi.100X.fastq"
REF="../data/e.coli-pb-sequelii/ref.fa"
PRESETX="map-hifi"

mkdir -p ${OUTDIR}

PREFIX="Ecoli.PB.HiFi.100X_strobemers"
/usr/bin/time -v -p -o ${OUTDIR}/${PREFIX}.time bash ../scripts/blend-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESETX} ${THREAD} ${THREAD_SORT} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

PREFIX="Ecoli.PB.HiFi.100X"
PARAMS="--immediate"
/usr/bin/time -v -p -o ${OUTDIR}/${PREFIX}.time bash ../scripts/blend-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESETX} ${THREAD} ${THREAD_SORT} ${PARAMS} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#yeast-pb-pbsim-200x
OUTDIR="./yeast-pb-pbsim-200x/read_mapping/"
READS="../data/yeast-pb-pbsim2/pbsim_yeast_200x.fasta"
REF="../data/yeast-pb-pbsim2/ref.fa"
PRESETX="map-pb"

mkdir -p ${OUTDIR}

PREFIX="pbsim_yeast_200x"
/usr/bin/time -v -p -o ${OUTDIR}/${PREFIX}.time bash ../scripts/blend-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESETX} ${THREAD} ${THREAD_SORT} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

PREFIX="pbsim_yeast_200x_strobemers"
PARAMS="--strobemers"
/usr/bin/time -v -p -o ${OUTDIR}/${PREFIX}.time bash ../scripts/blend-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESETX} ${THREAD} ${THREAD_SORT} ${PARAMS} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#yeast-ont-pbsim-100x
OUTDIR="./yeast-ont-pbsim-100x/read_mapping/"
READS="../data/yeast-ont-pbsim2/pbsim_yeast_100x.fasta"
REF="../data/yeast-ont-pbsim2/ref.fa"
PRESETX="map-ont"

mkdir -p ${OUTDIR}

PREFIX="pbsim_yeast_100x"
/usr/bin/time -v -p -o ${OUTDIR}/${PREFIX}.time bash ../scripts/blend-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESETX} ${THREAD} ${THREAD_SORT} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

PREFIX="pbsim_yeast_100x_strobemers"
PARAMS="--strobemers"
/usr/bin/time -v -p -o ${OUTDIR}/${PREFIX}.time bash ../scripts/blend-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESETX} ${THREAD} ${THREAD_SORT} ${PARAMS} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#yeast-illumina
OUTDIR="./yeast-illumina/read_mapping/"
READS1="../data/yeast-illumina/ERR1938683_1.fastq"
READS2="../data/yeast-illumina/ERR1938683_2.fastq"
REF="../data/yeast-illumina/ref.fa"
PRESETX="sr"

mkdir -p ${OUTDIR}

PREFIX="ERR1938683"
/usr/bin/time -v -p -o ${OUTDIR}/${PREFIX}.time bash ../scripts/blend-map_short.sh ${OUTDIR} ${PREFIX} ${READS1} ${READS2} ${REF} ${THREAD} ${THREAD_SORT} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

PREFIX="ERR1938683_strobemers"
PARAMS="--strobemers"
/usr/bin/time -v -p -o ${OUTDIR}/${PREFIX}.time bash ../scripts/blend-map_short.sh ${OUTDIR} ${PREFIX} ${READS1} ${READS2} ${REF} ${THREAD} ${THREAD_SORT} ${PARAMS} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#d.ananassae-pb-sequelii
OUTDIR="./d.ananassae-pb-sequelii/read_mapping/"
READS="../data/d.ananassae-pb-sequelii/Dana.PB.HiFi.50X.fastq"
REF="../data/d.ananassae-pb-sequelii/ref.fa"
PRESETX="map-hifi"

mkdir -p ${OUTDIR}

PREFIX="Dana.PB.HiFi.50X_strobemers"
/usr/bin/time -v -p -o ${OUTDIR}/${PREFIX}.time bash ../scripts/blend-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESETX} ${THREAD} ${THREAD_SORT} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

PREFIX="Dana.PB.HiFi.50X"
PARAMS="--immediate"
/usr/bin/time -v -p -o ${OUTDIR}/${PREFIX}.time bash ../scripts/blend-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESETX} ${THREAD} ${THREAD_SORT} ${PARAMS} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#chm13-pb-sequelii-16X
OUTDIR="./chm13-pb-sequelii-16X/read_mapping/"
READS="../data/chm13-pb-sequelii-16X/SRR11292122-3_subreads.fastq"
REF="../data/chm13-pb-sequelii-16X/ref.fa"
PRESETX="map-hifi"

mkdir -p ${OUTDIR}

PREFIX="SRR11292122-3_subreads_strobemers"
/usr/bin/time -v -p -o ${OUTDIR}/${PREFIX}.time bash ../scripts/blend-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESETX} ${THREAD} ${THREAD_SORT} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

PREFIX="SRR11292122-3_subreads"
PARAMS="--immediate"
/usr/bin/time -v -p -o ${OUTDIR}/${PREFIX}.time bash ../scripts/blend-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESETX} ${THREAD} ${THREAD_SORT} ${PARAMS} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

