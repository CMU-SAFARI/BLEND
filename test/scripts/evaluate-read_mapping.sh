#!/bin/bash

for i in `echo *.bam`; do bam stats --in $i --basic 2> $i.stats; done
for i in `echo *.bam`; do samtools view -hb -F1540 $i | bedtools coverage -a ./ref.bed -b stdin > $i.breadth; done
for i in `echo *.bam`; do mosdepth -F 1540 -x $i $i > $i.mosdepth.out 2> $i.mosdepth.err; done
for i in `echo *.bam`; do samtools view -F 4 $i | wc -l > $i.samtools.out 2> $i.samtools.err; done

