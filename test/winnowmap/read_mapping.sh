#!/bin/bash

THREAD=32
THREAD_SORT=8
TOT_THREAD=40

#chm13-pb-sequelii-16X
OUTDIR="./chm13-pb-sequelii-16X/read_mapping/"
PREFIX="SRR11292122-3_subreads"
READS="../data/chm13-pb-sequelii-16X/SRR11292122-3_subreads.fastq"
REF="../data/chm13-pb-sequelii-16X/ref.fa"

mkdir -p ${OUTDIR}
/usr/bin/time -v -p -o ${OUTDIR}/${PREFIX}.time bash ../scripts/winnowmap-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${THREAD} ${THREAD_SORT} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#d.ananassae-pb-sequelii
OUTDIR="./d.ananassae-pb-sequelii/read_mapping/"
PREFIX="Dana.PB.HiFi.50X"
READS="../data/d.ananassae-pb-sequelii/Dana.PB.HiFi.50X.fastq"
REF="../data/d.ananassae-pb-sequelii/ref.fa"

mkdir -p ${OUTDIR}
/usr/bin/time -v -p -o ${OUTDIR}/${PREFIX}.time bash ../scripts/winnowmap-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${THREAD} ${THREAD_SORT} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#e.coli-pb-sequelii
OUTDIR="./e.coli-pb-sequelii/read_mapping/"
PREFIX="Ecoli.PB.HiFi.100X"
READS="../data/e.coli-pb-sequelii/Ecoli.PB.HiFi.100X.fastq"
REF="../data/e.coli-pb-sequelii/ref.fa"

mkdir -p ${OUTDIR}
/usr/bin/time -v -p -o ${OUTDIR}/${PREFIX}.time bash ../scripts/winnowmap-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${THREAD} ${THREAD_SORT} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#yeast-pb-pbsim-200x
OUTDIR="./yeast-pb-pbsim-200x/read_mapping/"
PREFIX="pbsim_yeast_200x"
READS="../data/yeast-pb-pbsim/pbsim_yeast_200x.fastq"
REF="../data/yeast-pb-pbsim/ref.fa"

mkdir -p ${OUTDIR}
/usr/bin/time -v -p -o ${OUTDIR}/${PREFIX}.time bash ../scripts/winnowmap-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${THREAD} ${THREAD_SORT} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

