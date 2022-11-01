#!/bin/bash

THREAD=32

SLURM_OPTIONS="-p bio"

#e.coli-pb-sequelii
OUTDIR="./e.coli-pb-sequelii/read_mapping/"
PREFIX="Ecoli.PB.HiFi.100X"
READS="../data/e.coli-pb-sequelii/Ecoli.PB.HiFi.100X.fastq"
REF="../data/e.coli-pb-sequelii/ref.fa"

mkdir -p ${OUTDIR}
sbatch -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c ${THREAD} -J clsh.${PREFIX} ${SLURM_OPTIONS} --wrap="bash ../scripts/conlsh-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${THREAD}"

#e.coli-pb-rs
OUTDIR="./e.coli-pb-rs/read_mapping/"
PREFIX="SRR1509640_subreads"
READS="../data/e.coli-pb-rs/SRR1509640_subreads.fastq"
REF="../data/e.coli-pb-rs/ref.fa"

mkdir -p ${OUTDIR}
sbatch -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c ${THREAD} -J clsh.${PREFIX} ${SLURM_OPTIONS} --wrap="bash ../scripts/conlsh-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${THREAD}"

#yeast-pb-pbsim-200x
OUTDIR="./yeast-pb-pbsim-200x/read_mapping/"
PREFIX="pbsim_yeast_200x"
READS="../data/yeast-pb-pbsim2/pbsim_yeast_200x.fastq"
REF="../data/yeast-pb-pbsim2/ref.fa"

mkdir -p ${OUTDIR}
sbatch -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c ${THREAD} -J clsh.${PREFIX} ${SLURM_OPTIONS} --wrap="bash ../scripts/conlsh-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${THREAD}"

#yeast-ont-pbsim-100x
OUTDIR="./yeast-ont-pbsim-100x/read_mapping/"
PREFIX="pbsim_yeast_100x"
READS="../data/yeast-ont-pbsim2/pbsim_yeast_100x.fastq"
REF="../data/yeast-ont-pbsim2/ref.fa"

mkdir -p ${OUTDIR}
sbatch -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c ${THREAD} -J clsh.${PREFIX} ${SLURM_OPTIONS} --wrap="bash ../scripts/conlsh-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${THREAD}"

#d.ananassae-pb-sequelii
OUTDIR="./d.ananassae-pb-sequelii/read_mapping/"
PREFIX="Dana.PB.HiFi.50X"
READS="../data/d.ananassae-pb-sequelii/Dana.PB.HiFi.50X.fastq"
REF="../data/d.ananassae-pb-sequelii/ref.fa"

mkdir -p ${OUTDIR}
sbatch -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c ${THREAD} -J clsh.${PREFIX} ${SLURM_OPTIONS} --wrap="bash ../scripts/conlsh-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${THREAD}"

#chm13-pb-sequelii-16X
OUTDIR="./chm13-pb-sequelii-16X/read_mapping/"
PREFIX="SRR11292122-3_subreads"
READS="../data/chm13-pb-sequelii-16X/SRR11292122-3_subreads.fastq"
REF="../data/chm13-pb-sequelii-16X/ref.fa"

mkdir -p ${OUTDIR}
sbatch -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c ${THREAD} -J clsh.${PREFIX} ${SLURM_OPTIONS} --wrap="bash ../scripts/conlsh-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${THREAD}"

#chm13-ont-pbsim2
OUTDIR="./chm13-ont-pbsim2/read_mapping/"
READS="../data/chm13-ont-pbsim2/pbsim_chm13_30x.fastq"
REF="../data/chm13-ont-pbsim2/ref.fa"

mkdir -p ${OUTDIR}

PREFIX="pbsim_chm13_30x"
sbatch -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c ${THREAD} -J clsh.${PREFIX} ${SLURM_OPTIONS} --wrap="bash ../scripts/conlsh-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${THREAD}"

#We exclude the following run as S-conLSH cannot generate sortable & indexable BAM files
#hg002-pb-ccs-52X
# OUTDIR="./hg002-pb-ccs-52X/read_mapping/"
# READS="../data/hg002-pb-ccs-52X/SRR10382244-9.fastq"
# REF="../data/hg002-pb-ccs-52X/ref.fa"

# mkdir -p ${OUTDIR}

# #S-conLSH won't run the following code because we cannot generate a sorted BAM file. We run the following code:

# #cat e.coli-pb-sequelii/read_mapping/Ecoli.PB.HiFi.100X_conlsh.sam | samtools sort -l5 -m4G -@ 32 -o e.coli-pb-sequelii/read_mapping/Ecoli.PB.HiFi.100X_conlsh.bam

# #We get the following error:
# # [E::sam_parse1] CIGAR and query sequence are of different length
# # samtools sort: truncated file. Aborting
# # [E::sam_parse1] CIGAR and query sequence are of different length

# PREFIX="SRR10382244-9"
# sbatch -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c ${THREAD} -J clsh.${PREFIX} ${SLURM_OPTIONS} --wrap="bash ../scripts/conlsh-map.sh ${OUTDIR} ${PREFIX} ${READS} ${REF} ${THREAD}; /usr/bin/time -vpo ${OUTDIR}/${PREFIX}_sniffles.time sniffles --allow-overwrite -i ${OUTDIR}/${PREFIX}_conlsh.bam --threads ${THREAD} -v ${OUTDIR}/${PREFIX}_conlsh.vcf.gz"