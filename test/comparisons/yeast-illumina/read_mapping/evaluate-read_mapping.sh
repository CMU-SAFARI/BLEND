#!/bin/bash

#filtering: primary alignments, unmapped, PCR or optical duplicate, supplementary alignments

for i in `echo *.bam`; do bam stats --in $i --basic 2> $i.stats; done
for i in `echo *.bam`; do samtools view -hb -F 1796 $i | bedtools coverage -a ./ref.bed -b stdin > $i.breadth; done
for i in `echo *.bam`; do mosdepth -F 1796 -x $i $i > $i.mosdepth.out 2> $i.mosdepth.err; done
for i in `echo *.bam`; do samtools view -F 1796 $i | wc -l > $i.samtools.out 2> $i.samtools.err; done

