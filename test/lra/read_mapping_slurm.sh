#!/bin/bash

THREAD=32
THREAD_SORT=8
TOT_THREAD=40

SLURM_OPTIONS="-p bio"

#e.coli-pb-sequelii
OUTDIR="./e.coli-pb-sequelii/read_mapping/"
PREFIX="Ecoli.PB.HiFi.100X"
READS="../data/e.coli-pb-sequelii/Ecoli.PB.HiFi.100X.fastq"
REF="../data/e.coli-pb-sequelii/ref.fa"
PRESET="CCS"

mkdir -p ${OUTDIR}
sbatch -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c ${TOT_THREAD} -J lra.${PREFIX} ${SLURM_OPTIONS} --wrap="bash ../scripts/lra-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESET} ${THREAD} ${THREAD_SORT}"

#e.coli-pb-rs
OUTDIR="./e.coli-pb-rs/read_mapping/"
PREFIX="SRR1509640_subreads"
READS="../data/e.coli-pb-rs/SRR1509640_subreads.fastq"
REF="../data/e.coli-pb-rs/ref.fa"
PRESET="CLR"

mkdir -p ${OUTDIR}
sbatch -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c ${TOT_THREAD} -J lra.${PREFIX} ${SLURM_OPTIONS} --wrap="bash ../scripts/lra-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESET} ${THREAD} ${THREAD_SORT}"

#yeast-pb-pbsim-200x
OUTDIR="./yeast-pb-pbsim-200x/read_mapping/"
PREFIX="pbsim_yeast_200x"
READS="../data/yeast-pb-pbsim2/pbsim_yeast_200x.fasta"
REF="../data/yeast-pb-pbsim2/ref.fa"
PRESET="CLR"

mkdir -p ${OUTDIR}
sbatch -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c ${TOT_THREAD} -J lra.${PREFIX} ${SLURM_OPTIONS} --wrap="bash ../scripts/lra-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESET} ${THREAD} ${THREAD_SORT}"

#yeast-ont-pbsim-100x
OUTDIR="./yeast-ont-pbsim-100x/read_mapping/"
PREFIX="pbsim_yeast_100x"
READS="../data/yeast-ont-pbsim2/pbsim_yeast_100x.fasta"
REF="../data/yeast-ont-pbsim2/ref.fa"
PRESET="ONT"

mkdir -p ${OUTDIR}
sbatch -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c ${TOT_THREAD} -J lra.${PREFIX} ${SLURM_OPTIONS} --wrap="bash ../scripts/lra-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESET} ${THREAD} ${THREAD_SORT}"

#d.ananassae-pb-sequelii
OUTDIR="./d.ananassae-pb-sequelii/read_mapping/"
PREFIX="Dana.PB.HiFi.50X"
READS="../data/d.ananassae-pb-sequelii/Dana.PB.HiFi.50X.fastq"
REF="../data/d.ananassae-pb-sequelii/ref.fa"
PRESET="CCS"

mkdir -p ${OUTDIR}
sbatch -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c ${TOT_THREAD} -J lra.${PREFIX} ${SLURM_OPTIONS} --wrap="bash ../scripts/lra-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESET} ${THREAD} ${THREAD_SORT}"

#chm13-pb-sequelii-16X
OUTDIR="./chm13-pb-sequelii-16X/read_mapping/"
PREFIX="SRR11292122-3_subreads"
READS="../data/chm13-pb-sequelii-16X/SRR11292122-3_subreads.fastq"
REF="../data/chm13-pb-sequelii-16X/ref.fa"
PRESET="CCS"

mkdir -p ${OUTDIR}
sbatch -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c ${TOT_THREAD} -J lra.${PREFIX} ${SLURM_OPTIONS} --wrap="bash ../scripts/lra-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESET} ${THREAD} ${THREAD_SORT}"

#chm13-ont-pbsim2
OUTDIR="./chm13-ont-pbsim2/read_mapping/"
READS="../data/chm13-ont-pbsim2/pbsim_chm13_30x.fasta"
REF="../data/chm13-ont-pbsim2/ref.fa"
PRESET="ONT"

mkdir -p ${OUTDIR}

PREFIX="pbsim_chm13_30x"
sbatch -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c ${TOT_THREAD} -J lra.${PREFIX} ${SLURM_OPTIONS} --wrap="bash ../scripts/lra-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESET} ${THREAD} ${THREAD_SORT}"

#hg002-pb-ccs-52X
OUTDIR="./hg002-pb-ccs-52X/read_mapping/"
READS="../data/hg002-pb-ccs-52X/SRR10382244-9.fastq"
REF="../data/hg002-pb-ccs-52X/ref.fa"
PRESET="CCS"

mkdir -p ${OUTDIR}

PREFIX="SRR10382244-9"
sbatch -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c ${TOT_THREAD} -J lra.${PREFIX} ${SLURM_OPTIONS} --wrap="bash ../scripts/lra-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${PRESET} ${THREAD} ${THREAD_SORT}; /usr/bin/time -vpo ${OUTDIR}/${PREFIX}_sniffles.time sniffles --allow-overwrite -i ${OUTDIR}/${PREFIX}_lra.bam --threads ${TOT_THREAD} -v ${OUTDIR}/${PREFIX}_lra.vcf.gz"
