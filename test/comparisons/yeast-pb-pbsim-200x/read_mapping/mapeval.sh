#!/bin/bash

for i in `echo *.bam`; do samtools view -h $i | ../../../scripts/paftools.js mapeval -m2 - > $i.mapeval;done
rm lra.bam.mapeval

