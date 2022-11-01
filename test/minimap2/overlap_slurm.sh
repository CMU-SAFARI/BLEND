#!/bin/bash

#Hifi "_eq" reads should have had -k31 but Minimap2 can only use k <= 28. So we set them to 28

THREAD=32

SLURM_OPTIONS="-p bio"

#e.coli-pb-sequelii
OUTDIR="./e.coli-pb-sequelii/overlap/"
READS="../data/e.coli-pb-sequelii/Ecoli.PB.HiFi.100X.fastq"
PRESET="ava-pb"

mkdir -p ${OUTDIR}

PREFIX="Ecoli.PB.HiFi.100X"
sbatch -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c 32 -J mmo.${PREFIX} ${SLURM_OPTIONS} --wrap="bash ../scripts/minimap2-overlap-hifi.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESET} ${THREAD}"

PREFIX="Ecoli.PB.HiFi.100X_eq"
PARAMS="-k28 -w200"
sbatch -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c 32 -J mmo.${PREFIX} ${SLURM_OPTIONS} --wrap="bash ../scripts/minimap2-overlap-hifi.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESET} ${THREAD} \"${PARAMS}\""

#e.coli-pb-rs
OUTDIR="./e.coli-pb-rs/overlap/"
READS="../data/e.coli-pb-rs/SRR1509640_subreads.fastq"
PRESET="ava-pb"

mkdir -p ${OUTDIR}

PREFIX="SRR1509640_subreads"
sbatch -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c 32 -J mmo.${PREFIX} ${SLURM_OPTIONS} --wrap="bash ../scripts/minimap2-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESET} ${THREAD}"

PREFIX="SRR1509640_subreads_eq"
PARAMS="-k23 -w10"
sbatch -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c 32 -J mmo.${PREFIX} ${SLURM_OPTIONS} --wrap="bash ../scripts/minimap2-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESET} ${THREAD} \"${PARAMS}\""

#yeast-pb-pbsim-200x
OUTDIR="./yeast-pb-pbsim-200x/overlap/"
READS="../data/yeast-pb-pbsim2/pbsim_yeast_200x.fasta"
PRESET="ava-pb"

mkdir -p ${OUTDIR}

PREFIX="pbsim_yeast_200x"
sbatch -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c 32 -J mmo.${PREFIX} ${SLURM_OPTIONS} --wrap="bash ../scripts/minimap2-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESET} ${THREAD}"

PREFIX="pbsim_yeast_200x_eq"
PARAMS="-k23 -w10"
sbatch -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c 32 -J mmo.${PREFIX} ${SLURM_OPTIONS} --wrap="bash ../scripts/minimap2-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESET} ${THREAD} \"${PARAMS}\""

#yeast-ont-pbsim-100x
OUTDIR="./yeast-ont-pbsim-100x/overlap/"
READS="../data/yeast-ont-pbsim2/pbsim_yeast_100x.fasta"
PRESET="ava-ont"

mkdir -p ${OUTDIR}

PREFIX="pbsim_yeast_100x"
sbatch -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c 32 -J mmo.${PREFIX} ${SLURM_OPTIONS} --wrap="bash ../scripts/minimap2-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESET} ${THREAD}"

PREFIX="pbsim_yeast_100x_eq"
PARAMS="-k19 -w10"
sbatch -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c 32 -J mmo.${PREFIX} ${SLURM_OPTIONS} --wrap="bash ../scripts/minimap2-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESET} ${THREAD} \"${PARAMS}\""

#d.ananassae-pb-sequelii
OUTDIR="./d.ananassae-pb-sequelii/overlap/"
READS="../data/d.ananassae-pb-sequelii/Dana.PB.HiFi.50X.fastq"
PRESET="ava-pb"

mkdir -p ${OUTDIR}

PREFIX="Dana.PB.HiFi.50X"
sbatch -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c 32 -J mmo.${PREFIX} ${SLURM_OPTIONS} --wrap="bash ../scripts/minimap2-overlap-hifi.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESET} ${THREAD}"

PREFIX="Dana.PB.HiFi.50X_eq"
PARAMS="-k28 -w200"
sbatch -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c 32 -J mmo.${PREFIX} ${SLURM_OPTIONS} --wrap="bash ../scripts/minimap2-overlap-hifi.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESET} ${THREAD} \"${PARAMS}\""

#chm13-pb-sequelii-16X
OUTDIR="./chm13-pb-sequelii-16X/overlap/"
READS="../data/chm13-pb-sequelii-16X/SRR11292122-3_subreads.fastq"
PRESET="ava-pb"

mkdir -p ${OUTDIR}

PREFIX="SRR11292122-3_subreads"
sbatch -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c 32 -J mmo.${PREFIX} ${SLURM_OPTIONS} --wrap="bash ../scripts/minimap2-overlap-hifi.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESET} ${THREAD}"

PREFIX="SRR11292122-3_subreads_eq"
PARAMS="-k28 -w200"
sbatch -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c 32 -J mmo.${PREFIX} ${SLURM_OPTIONS} --wrap="bash ../scripts/minimap2-overlap-hifi.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESET} ${THREAD} \"${PARAMS}\""

#chm13-ont-pbsim2
OUTDIR="./chm13-ont-pbsim2/overlap/"
READS="../data/chm13-ont-pbsim2/pbsim_chm13_30x.fasta"
PRESET="ava-ont"

mkdir -p ${OUTDIR}

PREFIX="pbsim_chm13_30x"
sbatch -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c 32 -J mmo.${PREFIX} ${SLURM_OPTIONS} --wrap="bash ../scripts/minimap2-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESET} ${THREAD}"

PREFIX="pbsim_chm13_30x_eq"
PARAMS="-k19 -w10"
sbatch -o ${OUTDIR}/${PREFIX}.out -e ${OUTDIR}/${PREFIX}.err -c 32 -J mmo.${PREFIX} ${SLURM_OPTIONS} --wrap="bash ../scripts/minimap2-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${PRESET} ${THREAD} \"${PARAMS}\""
