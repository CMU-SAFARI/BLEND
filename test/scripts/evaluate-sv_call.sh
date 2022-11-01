#!/bin/bash

for i in `echo ./*.vcf.gz`; do fname=`basename $i | sed s/.vcf.gz//g`; 
    if [ "$fname" == "base" ] ; then continue; fi;  
    truvari bench -b ./base.vcf.gz -c $i --reference ./ref.fa -o ./${fname} > ./${fname}.truvari.out 2> ./${fname}.truvari.err
done
