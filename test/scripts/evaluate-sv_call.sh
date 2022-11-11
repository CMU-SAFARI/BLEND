#!/bin/bash

for i in `echo ./*.vcf.gz`; do fname=`basename $i | sed s/.vcf.gz//g`; 
    if [ "$fname" == "base" ] ; then continue; fi;  
    #The following commented out command compares the entire sets, which is not the suggested methodology. BLEND still provides the
    #best F1 scores for this comparison too but we do not report these results in our paper as this is not the suggested method by GIAB
    #truvari bench --giabreport -b ./base.vcf.gz -c $i --reference ./ref.fa -o ./${fname} > ./${fname}.truvari.out 2> ./${fname}.truvari.err
    
    truvari bench --giabreport --passonly -b ./base.vcf.gz -c $i --reference ./ref.fa --includebed ref.bed -o ./"${fname}"_pass > ./"${fname}"_pass.truvari.out 2> ./"${fname}"_pass.truvari.err
done
