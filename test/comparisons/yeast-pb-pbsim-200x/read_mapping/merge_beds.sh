#!/bin/bash

for i in `echo *.bam.bed`; do echo $i; fname=`basename $i | sed s/.bam.bed/.bam.joined.bed/g`;
	awk -v FS='\t' 'NR==FNR {h[$1] = $2; next} {split($1,arr,"!"); print arr[1],$2,$3,h[arr[1]],$3-h[arr[1]]}' ../../../data/yeast-pb-pbsim2/pbsim_yeast_200x_alignment.bed $i > $fname
done

