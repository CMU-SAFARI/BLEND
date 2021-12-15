#!/bin/bash

THREAD=32
THREAD_SORT=8
TOT_THREAD=40

#e.coli-pb-sequelii
OUTDIR="./e.coli-pb-sequelii/read_mapping/"
PREFIX="Ecoli.PB.HiFi.100X"
READS="../data/e.coli-pb-sequelii/Ecoli.PB.HiFi.100X.fastq"
REF="../data/e.coli-pb-sequelii/ref.fa"
PRESETX="map-hifi"
PRESETGEN="bacteria"

mkdir -p ${OUTDIR}
bash ../scripts/blend-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESETX} ${PRESETGEN} ${THREAD} ${THREAD_SORT} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#yeast-pb-pbsim-200x
OUTDIR="./yeast-pb-pbsim-200x/read_mapping/"
PREFIX="pbsim_yeast_200x"
READS="../data/yeast-pb-pbsim/pbsim_yeast_200x.fastq"
REF="../data/yeast-pb-pbsim/ref.fa"
PRESETX="map-pb"
PRESETGEN="eukaryote"

mkdir -p ${OUTDIR}
bash ../scripts/blend-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESETX} ${PRESETGEN} ${THREAD} ${THREAD_SORT} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#yeast-illumina
OUTDIR="./yeast-illumina/read_mapping/"
PREFIX="ERR1938683"
READS1="../data/yeast-illumina/ERR1938683_1.fastq"
READS2="../data/yeast-illumina/ERR1938683_2.fastq"
REF="../data/yeast-illumina/ref.fa"
PRESETX="sr"
PRESETGEN="eukaryote"

mkdir -p ${OUTDIR}
/usr/bin/time -v -p -o ${OUTDIR}/${PREFIX}.time bash ../scripts/blend-map_short.sh ${OUTDIR} ${PREFIX} ${READS1} ${READS2} ${REF} ${PRESETGEN} ${THREAD} ${THREAD_SORT} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#d.ananassae-pb-sequelii
OUTDIR="./d.ananassae-pb-sequelii/read_mapping/"
PREFIX="Dana.PB.HiFi.50X"
READS="../data/d.ananassae-pb-sequelii/Dana.PB.HiFi.50X.fastq"
REF="../data/d.ananassae-pb-sequelii/ref.fa"
PRESETX="map-hifi"
PRESETGEN="eukaryote"

mkdir -p ${OUTDIR}
bash ../scripts/blend-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESETX} ${PRESETGEN} ${THREAD} ${THREAD_SORT} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#chm13-pb-sequelii-16X
OUTDIR="./chm13-pb-sequelii-16X/read_mapping/"
PREFIX="SRR11292122-3_subreads"
READS="../data/chm13-pb-sequelii-16X/SRR11292122-3_subreads.fastq"
REF="../data/chm13-pb-sequelii-16X/ref.fa"
PRESETX="map-hifi"
PRESETGEN="human"

mkdir -p ${OUTDIR}
bash ../scripts/blend-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESETX} ${PRESETGEN} ${THREAD} ${THREAD_SORT} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

