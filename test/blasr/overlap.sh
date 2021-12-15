#!/bin/bash

THREAD=32

#chm13-pb-sequelii-16X
OUTDIR="./chm13-pb-sequelii-16X/overlap/"
PREFIX="SRR11292122-3_subreads"
READS="../data/chm13-pb-sequelii-16X/SRR11292122-3_subreads.fastq"
READS2="../data/chm13-pb-sequelii-16X/SRR11292122-3_subreads.fasta"

mkdir -p ${OUTDIR}
/usr/bin/time -v -p -o ${OUTDIR}/${PREFIX}.time bash ../scripts/blasr-map.sh ${OUTDIR} ${PREFIX} ${READS} ${READS2} ${THREAD} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#d.ananassae-pb-sequelii
OUTDIR="./d.ananassae-pb-sequelii/overlap/"
PREFIX="Dana.PB.HiFi.50X"
READS="../data/d.ananassae-pb-sequelii/Dana.PB.HiFi.50X.fastq"
READS2="../data/d.ananassae-pb-sequelii/Dana.PB.HiFi.50X.fasta"

mkdir -p ${OUTDIR}
/usr/bin/time -v -p -o ${OUTDIR}/${PREFIX}.time bash ../scripts/blasr-map.sh ${OUTDIR} ${PREFIX} ${READS} ${READS2} ${THREAD} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#e.coli-pb-sequelii
OUTDIR="./e.coli-pb-sequelii/overlap/"
PREFIX="Ecoli.PB.HiFi.100X"
READS="../data/e.coli-pb-sequelii/Ecoli.PB.HiFi.100X.fastq"
READS2="../data/e.coli-pb-sequelii/Ecoli.PB.HiFi.100X.fasta"

mkdir -p ${OUTDIR}
/usr/bin/time -v -p -o ${OUTDIR}/${PREFIX}.time bash ../scripts/blasr-map.sh ${OUTDIR} ${PREFIX} ${READS} ${READS2} ${THREAD} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

#yeast-pb-pbsim-200x
OUTDIR="./yeast-pb-pbsim-200x/overlap/"
PREFIX="pbsim_yeast_200x"
READS="../data/yeast-pb-pbsim/pbsim_yeast_200x.fastq"
READS2="../data/yeast-pb-pbsim/pbsim_yeast_200x.fasta"

mkdir -p ${OUTDIR}
/usr/bin/time -v -p -o ${OUTDIR}/${PREFIX}.time bash ../scripts/blasr-map.sh ${OUTDIR} ${PREFIX} ${READS} ${READS2} ${THREAD} > ${OUTDIR}/${PREFIX}.out 2> ${OUTDIR}/${PREFIX}.err

