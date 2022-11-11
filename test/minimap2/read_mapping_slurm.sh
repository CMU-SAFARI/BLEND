#!/bin/bash

THREAD=32
THREAD_SORT=8
TOT_THREAD=40

SLURM_OPTIONS="-p bio"

#e.coli-pb-sequelii
OUTDIR="./e.coli-pb-sequelii/read_mapping/"
READS="../data/e.coli-pb-sequelii/Ecoli.PB.HiFi.100X.fastq"
REF="../data/e.coli-pb-sequelii/ref.fa"
PRESET="map-hifi"

mkdir -p ${OUTDIR}

PREFIX="Ecoli.PB.HiFi.100X"
sbatch -J mm2.${PREFIX} -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c ${TOT_THREAD} $SLURM_OPTIONS --wrap="/usr/bin/time -vpo ${OUTDIR}/${PREFIX}.time bash ../scripts/minimap2-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESET} ${THREAD} ${THREAD_SORT}"

PREFIX="Ecoli.PB.HiFi.100X_eq"
PARAMS="-k23 -w50"
sbatch -J mm2.${PREFIX} -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c ${TOT_THREAD} $SLURM_OPTIONS --wrap="/usr/bin/time -vpo ${OUTDIR}/${PREFIX}.time bash ../scripts/minimap2-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESET} ${THREAD} ${THREAD_SORT} \"${PARAMS}\""

#e.coli-pb-rs
OUTDIR="./e.coli-pb-rs/read_mapping/"
READS="../data/e.coli-pb-rs/SRR1509640_subreads.fastq"
REF="../data/e.coli-pb-rs/ref.fa"
PRESET="map-pb"

mkdir -p ${OUTDIR}

PREFIX="SRR1509640_subreads"
sbatch -J mm2.${PREFIX} -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c ${TOT_THREAD} $SLURM_OPTIONS --wrap="/usr/bin/time -vpo ${OUTDIR}/${PREFIX}.time bash ../scripts/minimap2-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESET} ${THREAD} ${THREAD_SORT}"

#yeast-pb-pbsim-200x
OUTDIR="./yeast-pb-pbsim-200x/read_mapping/"
READS="../data/yeast-pb-pbsim2/pbsim_yeast_200x.fasta"
REF="../data/yeast-pb-pbsim2/ref.fa"
PRESET="map-pb"

mkdir -p ${OUTDIR}

PREFIX="pbsim_yeast_200x"
sbatch -J mm2.${PREFIX} -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c ${TOT_THREAD} $SLURM_OPTIONS --wrap="/usr/bin/time -vpo ${OUTDIR}/${PREFIX}.time bash ../scripts/minimap2-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESET} ${THREAD} ${THREAD_SORT}"

#yeast-ont-pbsim-100x
OUTDIR="./yeast-ont-pbsim-100x/read_mapping/"
READS="../data/yeast-ont-pbsim2/pbsim_yeast_100x.fasta"
REF="../data/yeast-ont-pbsim2/ref.fa"
PRESET="map-ont"

mkdir -p ${OUTDIR}

PREFIX="pbsim_yeast_100x"
sbatch -J mm2.${PREFIX} -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c ${TOT_THREAD} $SLURM_OPTIONS --wrap="/usr/bin/time -vpo ${OUTDIR}/${PREFIX}.time bash ../scripts/minimap2-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESET} ${THREAD} ${THREAD_SORT}"

#yeast-illumina
OUTDIR="./yeast-illumina/read_mapping/"
READS1="../data/yeast-illumina/ERR1938683_1.fastq"
READS2="../data/yeast-illumina/ERR1938683_2.fastq"
REF="../data/yeast-illumina/ref.fa"
PRESET="sr"

mkdir -p ${OUTDIR}

PREFIX="ERR1938683"
sbatch -J mm2.${PREFIX} -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c ${TOT_THREAD} $SLURM_OPTIONS --wrap="/usr/bin/time -vpo ${OUTDIR}/${PREFIX}.time bash ../scripts/minimap2-map_short.sh ${OUTDIR} ${PREFIX} ${READS1} ${READS2} ${REF} ${THREAD} ${THREAD_SORT}"

PREFIX="ERR1938683_eq"
PARAMS="-k25 -w11"
sbatch -J mm2.${PREFIX} -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c ${TOT_THREAD} $SLURM_OPTIONS --wrap="/usr/bin/time -vpo ${OUTDIR}/${PREFIX}.time bash ../scripts/minimap2-map_short.sh ${OUTDIR} ${PREFIX} ${READS1} ${READS2} ${REF} ${THREAD} ${THREAD_SORT} \"${PARAMS}\""

#d.ananassae-pb-sequelii
OUTDIR="./d.ananassae-pb-sequelii/read_mapping/"
READS="../data/d.ananassae-pb-sequelii/Dana.PB.HiFi.50X.fastq"
REF="../data/d.ananassae-pb-sequelii/ref.fa"
PRESET="map-hifi"

mkdir -p ${OUTDIR}

PREFIX="Dana.PB.HiFi.50X"
sbatch -J mm2.${PREFIX} -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c ${TOT_THREAD} $SLURM_OPTIONS --wrap="/usr/bin/time -vpo ${OUTDIR}/${PREFIX}.time bash ../scripts/minimap2-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESET} ${THREAD} ${THREAD_SORT}"

PREFIX="Dana.PB.HiFi.50X_eq"
PARAMS="-k23 -w50"
sbatch -J mm2.${PREFIX} -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c ${TOT_THREAD} $SLURM_OPTIONS --wrap="/usr/bin/time -vpo ${OUTDIR}/${PREFIX}.time bash ../scripts/minimap2-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESET} ${THREAD} ${THREAD_SORT} \"${PARAMS}\""

#chm13-pb-sequelii-16X
OUTDIR="./chm13-pb-sequelii-16X/read_mapping/"
READS="../data/chm13-pb-sequelii-16X/SRR11292122-3_subreads.fastq"
REF="../data/chm13-pb-sequelii-16X/ref.fa"
PRESET="map-hifi"

mkdir -p ${OUTDIR}

PREFIX="SRR11292122-3_subreads"
sbatch -J mm2.${PREFIX} -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c ${TOT_THREAD} $SLURM_OPTIONS --wrap="/usr/bin/time -vpo ${OUTDIR}/${PREFIX}.time bash ../scripts/minimap2-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESET} ${THREAD} ${THREAD_SORT}"

PREFIX="SRR11292122-3_subreads_eq"
PARAMS="-k23 -w50"
sbatch -J mm2.${PREFIX} -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c ${TOT_THREAD} $SLURM_OPTIONS --wrap="/usr/bin/time -vpo ${OUTDIR}/${PREFIX}.time bash ../scripts/minimap2-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESET} ${THREAD} ${THREAD_SORT} \"${PARAMS}\""

#chm13-ont-pbsim2
OUTDIR="./chm13-ont-pbsim2/read_mapping/"
READS="../data/chm13-ont-pbsim2/pbsim_chm13_30x.fasta"
REF="../data/chm13-ont-pbsim2/ref.fa"
PRESET="map-ont"

mkdir -p ${OUTDIR}

PREFIX="pbsim_chm13_30x"
sbatch -J mm2.${PREFIX} -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c ${TOT_THREAD} $SLURM_OPTIONS --wrap="/usr/bin/time -vpo ${OUTDIR}/${PREFIX}.time bash ../scripts/minimap2-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESET} ${THREAD} ${THREAD_SORT}"

#hg002-pb-ccs-52X
OUTDIR="./hg002-pb-ccs-52X/read_mapping/"
READS="../data/hg002-pb-ccs-52X/SRR10382244-9.fastq"
REF="../data/hg002-pb-ccs-52X/ref.fa"
PRESET="map-hifi"

mkdir -p ${OUTDIR}

PREFIX="SRR10382244-9"
sbatch -J mm2.${PREFIX} -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c ${TOT_THREAD} $SLURM_OPTIONS --wrap="/usr/bin/time -vpo ${OUTDIR}/${PREFIX}.time bash ../scripts/minimap2-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESET} ${THREAD} ${THREAD_SORT}; /usr/bin/time -vpo ${OUTDIR}/${PREFIX}_sniffles.time sniffles --allow-overwrite -i ${OUTDIR}/${PREFIX}_minimap2.bam --threads ${TOT_THREAD} -v ${OUTDIR}/${PREFIX}_minimap2.vcf.gz"

PREFIX="SRR10382244-9_eq"
PARAMS="-k23 -w50"
sbatch -J mm2.${PREFIX} -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c ${TOT_THREAD} $SLURM_OPTIONS --wrap="/usr/bin/time -vpo ${OUTDIR}/${PREFIX}.time bash ../scripts/minimap2-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESET} ${THREAD} ${THREAD_SORT} \"${PARAMS}\"; /usr/bin/time -vpo ${OUTDIR}/${PREFIX}_sniffles.time sniffles --allow-overwrite -i ${OUTDIR}/${PREFIX}_minimap2.bam --threads ${TOT_THREAD} -v ${OUTDIR}/${PREFIX}_minimap2.vcf.gz"
