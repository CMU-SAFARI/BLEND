#!/bin/bash

for i in `echo *.bam.bed`; do echo $i; fname=`basename $i | sed s/.bam.bed/.bam.joined.bed/g`;
awk -v FS='\t' 'NR==FNR {h[$1] = $2; next} {print $1,$2,$3,h[$1],$3-h[$1]}' ../../../data/yeast-ont-pbsim2/pbsim_yeast_100x_alignment.bed $i > $fname
done

