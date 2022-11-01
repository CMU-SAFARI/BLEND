#!/bin/bash

THREAD=32
THREAD_SORT=8
TOT_THREAD=40

#e.coli-pb-sequelii
OUTDIR="./e.coli-pb-sequelii/read_mapping/"
READS="../data/e.coli-pb-sequelii/Ecoli.PB.HiFi.100X.fastq"
REF="../data/e.coli-pb-sequelii/ref.fa"
PRESET="map-hifi"

mkdir -p ${OUTDIR}

PREFIX="Ecoli.PB.HiFi.100X"
/usr/bin/time -vpo ${OUTDIR}/${PREFIX}.time bash ../scripts/minimap2-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESET} ${THREAD} ${THREAD_SORT} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

PREFIX="Ecoli.PB.HiFi.100X_eq"
PARAMS="-k23 -w50"
/usr/bin/time -vpo ${OUTDIR}/${PREFIX}.time bash ../scripts/minimap2-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESET} ${THREAD} ${THREAD_SORT} "${PARAMS}" > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#e.coli-pb-rs
OUTDIR="./e.coli-pb-rs/read_mapping/"
READS="../data/e.coli-pb-rs/SRR1509640_subreads.fastq"
REF="../data/e.coli-pb-rs/ref.fa"
PRESET="map-hifi"

mkdir -p ${OUTDIR}

PREFIX="SRR1509640_subreads"
/usr/bin/time -vpo ${OUTDIR}/${PREFIX}.time bash ../scripts/minimap2-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESET} ${THREAD} ${THREAD_SORT} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

PREFIX="SRR1509640_subreads_eq"
PARAMS="-k23 -w50"
/usr/bin/time -vpo ${OUTDIR}/${PREFIX}.time bash ../scripts/minimap2-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESET} ${THREAD} ${THREAD_SORT} "${PARAMS}" > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#yeast-pb-pbsim-200x
OUTDIR="./yeast-pb-pbsim-200x/read_mapping/"
READS="../data/yeast-pb-pbsim2/pbsim_yeast_200x.fasta"
REF="../data/yeast-pb-pbsim2/ref.fa"
PRESET="map-pb"

mkdir -p ${OUTDIR}

PREFIX="pbsim_yeast_200x"
/usr/bin/time -vpo ${OUTDIR}/${PREFIX}.time bash ../scripts/minimap2-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESET} ${THREAD} ${THREAD_SORT} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#yeast-ont-pbsim-100x
OUTDIR="./yeast-ont-pbsim-100x/read_mapping/"
READS="../data/yeast-ont-pbsim2/pbsim_yeast_100x.fasta"
REF="../data/yeast-ont-pbsim2/ref.fa"
PRESET="map-ont"

mkdir -p ${OUTDIR}

PREFIX="pbsim_yeast_100x"
/usr/bin/time -vpo ${OUTDIR}/${PREFIX}.time bash ../scripts/minimap2-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESET} ${THREAD} ${THREAD_SORT} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#yeast-illumina
OUTDIR="./yeast-illumina/read_mapping/"
READS1="../data/yeast-illumina/ERR1938683_1.fastq"
READS2="../data/yeast-illumina/ERR1938683_2.fastq"
REF="../data/yeast-illumina/ref.fa"
PRESET="sr"

mkdir -p ${OUTDIR}

PREFIX="ERR1938683"
/usr/bin/time -vpo ${OUTDIR}/${PREFIX}.time bash ../scripts/minimap2-map_short.sh ${OUTDIR} ${PREFIX} ${READS1} ${READS2} ${REF} ${THREAD} ${THREAD_SORT} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

PREFIX="ERR1938683_eq"
PARAMS="-k25 -w11"
/usr/bin/time -vpo ${OUTDIR}/${PREFIX}.time bash ../scripts/minimap2-map_short.sh ${OUTDIR} ${PREFIX} ${READS1} ${READS2} ${REF} ${THREAD} ${THREAD_SORT} "${PARAMS}" > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#d.ananassae-pb-sequelii
OUTDIR="./d.ananassae-pb-sequelii/read_mapping/"
READS="../data/d.ananassae-pb-sequelii/Dana.PB.HiFi.50X.fastq"
REF="../data/d.ananassae-pb-sequelii/ref.fa"
PRESET="map-hifi"

mkdir -p ${OUTDIR}

PREFIX="Dana.PB.HiFi.50X"
/usr/bin/time -vpo ${OUTDIR}/${PREFIX}.time bash ../scripts/minimap2-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESET} ${THREAD} ${THREAD_SORT} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

PREFIX="Dana.PB.HiFi.50X_eq"
PARAMS="-k23 -w50"
/usr/bin/time -vpo ${OUTDIR}/${PREFIX}.time bash ../scripts/minimap2-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESET} ${THREAD} ${THREAD_SORT} "${PARAMS}" > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#chm13-pb-sequelii-16X
OUTDIR="./chm13-pb-sequelii-16X/read_mapping/"
READS="../data/chm13-pb-sequelii-16X/SRR11292122-3_subreads.fastq"
REF="../data/chm13-pb-sequelii-16X/ref.fa"
PRESET="map-hifi"

mkdir -p ${OUTDIR}

PREFIX="SRR11292122-3_subreads"
/usr/bin/time -vpo ${OUTDIR}/${PREFIX}.time bash ../scripts/minimap2-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESET} ${THREAD} ${THREAD_SORT} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

PREFIX="SRR11292122-3_subreads_eq"
PARAMS="-k23 -w50"
/usr/bin/time -vpo ${OUTDIR}/${PREFIX}.time bash ../scripts/minimap2-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESET} ${THREAD} ${THREAD_SORT} "${PARAMS}" > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#chm13-ont-pbsim2
OUTDIR="./chm13-ont-pbsim2/read_mapping/"
READS="../data/chm13-ont-pbsim2/pbsim_chm13_30x.fasta"
REF="../data/chm13-ont-pbsim2/ref.fa"
PRESET="map-ont"

mkdir -p ${OUTDIR}

PREFIX="pbsim_chm13_30x"
/usr/bin/time -vpo ${OUTDIR}/${PREFIX}.time bash ../scripts/minimap2-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESET} ${THREAD} ${THREAD_SORT} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#hg002-pb-ccs-52X
OUTDIR="./hg002-pb-ccs-52X/read_mapping/"
READS="../data/hg002-pb-ccs-52X/SRR10382244-9.fastq"
REF="../data/hg002-pb-ccs-52X/ref.fa"
PRESET="map-hifi"

mkdir -p ${OUTDIR}

PREFIX="SRR10382244-9"
/usr/bin/time -vpo ${OUTDIR}/${PREFIX}.time bash ../scripts/minimap2-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESET} ${THREAD} ${THREAD_SORT} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err
/usr/bin/time -vpo ${OUTDIR}/${PREFIX}_sniffles.time sniffles --allow-overwrite -i ${OUTDIR}/${PREFIX}_minimap2.bam --threads ${TOT_THREAD} -v ${OUTDIR}/${PREFIX}_minimap2.vcf.gz

PREFIX="SRR10382244-9_eq"
PARAMS="-k23 -w50"
/usr/bin/time -vpo ${OUTDIR}/${PREFIX}.time bash ../scripts/minimap2-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESET} ${THREAD} ${THREAD_SORT} "${PARAMS}" > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err
/usr/bin/time -vpo ${OUTDIR}/${PREFIX}_sniffles.time sniffles --allow-overwrite -i ${OUTDIR}/${PREFIX}_minimap2.bam --threads ${TOT_THREAD} -v ${OUTDIR}/${PREFIX}_minimap2.vcf.gz
