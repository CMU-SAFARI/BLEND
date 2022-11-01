#!/bin/bash

THREAD=32

#e.coli-pb-sequelii
OUTDIR="./e.coli-pb-sequelii/overlap/"
PREFIX="Ecoli.PB.HiFi.100X"
READS="../data/e.coli-pb-sequelii/Ecoli.PB.HiFi.100X.fasta"

mkdir -p ${OUTDIR}
bash ../scripts/mhap-overlap-hifi.sh ${OUTDIR} ${PREFIX} ${READS} ${THREAD} ../scripts/ > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#e.coli-pb-rs
OUTDIR="./e.coli-pb-rs/overlap/"
PREFIX="SRR1509640_subreads"
READS="../data/e.coli-pb-rs/SRR1509640_subreads.fasta"

mkdir -p ${OUTDIR}
bash ../scripts/mhap-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${THREAD} ../scripts/ > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#yeast-pb-pbsim-200x
OUTDIR="./yeast-pb-pbsim-200x/overlap/"
PREFIX="pbsim_yeast_200x"
READS="../data/yeast-pb-pbsim2/pbsim_yeast_200x.fasta"

mkdir -p ${OUTDIR}
bash ../scripts/mhap-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${THREAD} ../scripts/ > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#yeast-ont-pbsim-100x
OUTDIR="./yeast-ont-pbsim-100x/overlap/"
PREFIX="pbsim_yeast_100x"
READS="../data/yeast-ont-pbsim2/pbsim_yeast_100x.fasta"

mkdir -p ${OUTDIR}
bash ../scripts/mhap-overlap.sh ${OUTDIR} ${PREFIX} ${READS} ${THREAD} ../scripts/ > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#d.ananassae-pb-sequelii
OUTDIR="./d.ananassae-pb-sequelii/overlap/"
PREFIX="Dana.PB.HiFi.50X"
READS="../data/d.ananassae-pb-sequelii/Dana.PB.HiFi.50X.fasta"

mkdir -p ${OUTDIR}
bash ../scripts/mhap-overlap-hifi.sh ${OUTDIR} ${PREFIX} ${READS} ${THREAD} ../scripts/ > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#chm13-pb-sequelii-16X
OUTDIR="./chm13-pb-sequelii-16X/overlap/"
PREFIX="SRR11292122-3_subreads"
READS="../data/chm13-pb-sequelii-16X/SRR11292122-3_subreads.fasta"

mkdir -p ${OUTDIR}
bash ../scripts/mhap-overlap-hifi.sh ${OUTDIR} ${PREFIX} ${READS} ${THREAD} ../scripts/ > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#chm13-ont-pbsim2
OUTDIR="./chm13-ont-pbsim2/overlap/"
PREFIX="pbsim_chm13_30x"
READS="../data/chm13-ont-pbsim2/pbsim_chm13_30x.fasta"

mkdir -p ${OUTDIR}
bash ../scripts/mhap-overlap-hifi.sh ${OUTDIR} ${PREFIX} ${READS} ${THREAD} ../scripts/ > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err
