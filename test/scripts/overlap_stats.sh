#!/bin/bash

prefix=$1
# tool=$2
# sample=$3

awk -v FS='\t' 'BEGIN{rowcnt=0; totblock=0; totmin = 0; totmincnt=0;}{rowcnt++; totblock += $11; if(substr($14,0,2) == "cm"){totmin += substr($14,6,length($14));totmincnt += 1}}END{print "Total Overlap " rowcnt; print "Average Block Length " totblock/rowcnt; print "Average Num of Minimizers: " totmin/totmincnt}' ${prefix}.paf > ${prefix}_overlap.stats
# awk -v samplea="${sample}" -v toola="${tool}" -v FS='\t' '{print $11","toola","samplea}' ${prefix}.paf | sort -n -k1 -t',' > ${prefix}_block-histogram.csv

