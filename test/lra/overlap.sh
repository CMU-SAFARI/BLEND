#!/bin/bash

#We tried running LRA for read overlapping but it cannot generate 

THREAD=32

#e.coli-pb-sequelii
OUTDIR="./e.coli-pb-sequelii/overlap/"
PREFIX="Ecoli.PB.HiFi.100X"
READS="../data/e.coli-pb-sequelii/Ecoli.PB.HiFi.100X.fastq"
READS2="../data/e.coli-pb-sequelii/Ecoli.PB.HiFi.100X.fasta"
PRESET="CCS"

mkdir -p ${OUTDIR}
bash ../scripts/lra-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${READS2} ${PRESET} ${THREAD} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#e.coli-pb-rs
OUTDIR="./e.coli-pb-rs/overlap/"
PREFIX="SRR1509640_subreads"
READS="../data/e.coli-pb-rs/SRR1509640_subreads.fastq"
READS2="../data/e.coli-pb-rs/SRR1509640_subreads.fasta"
PRESET="CLR"

mkdir -p ${OUTDIR}
bash ../scripts/lra-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${READS2} ${PRESET} ${THREAD} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#yeast-pb-pbsim-200x
OUTDIR="./yeast-pb-pbsim-200x/overlap/"
PREFIX="pbsim_yeast_200x"
READS="../data/yeast-pb-pbsim2/pbsim_yeast_200x.fasta"
READS2="../data/yeast-pb-pbsim2/pbsim_yeast_200x.fasta"
PRESET="CLR"

mkdir -p ${OUTDIR}
bash ../scripts/lra-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${READS2} ${PRESET} ${THREAD} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#yeast-ont-pbsim-100x
OUTDIR="./yeast-ont-pbsim-100x/overlap/"
PREFIX="pbsim_yeast_100x"
READS="../data/yeast-ont-pbsim2/pbsim_yeast_100x.fasta"
READS2="../data/yeast-ont-pbsim2/pbsim_yeast_100x.fasta"
PRESET="ONT"

mkdir -p ${OUTDIR}
bash ../scripts/lra-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${READS2} ${PRESET} ${THREAD} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#d.ananassae-pb-sequelii
OUTDIR="./d.ananassae-pb-sequelii/overlap/"
PREFIX="Dana.PB.HiFi.50X"
READS="../data/d.ananassae-pb-sequelii/Dana.PB.HiFi.50X.fastq"
READS2="../data/d.ananassae-pb-sequelii/Dana.PB.HiFi.50X.fasta"
PRESET="CCS"

mkdir -p ${OUTDIR}
bash ../scripts/lra-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${READS2} ${PRESET} ${THREAD} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#chm13-pb-sequelii-16X
OUTDIR="./chm13-pb-sequelii-16X/overlap/"
PREFIX="SRR11292122-3_subreads"
READS="../data/chm13-pb-sequelii-16X/SRR11292122-3_subreads.fastq"
READS2="../data/chm13-pb-sequelii-16X/SRR11292122-3_subreads.fasta"
PRESET="CCS"

mkdir -p ${OUTDIR}
bash ../scripts/lra-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${READS2} ${PRESET} ${THREAD} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

