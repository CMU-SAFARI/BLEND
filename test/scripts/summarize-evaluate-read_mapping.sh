#!/bin/bash

echo 'Mapping Rate:';
for i in `echo *.stats`; do echo $i; head -1 $i; grep "MappingRate" $i; done
echo;
echo 'Breadth of Cov (Last column)';
for i in `echo *.breadth`; do echo $i; awk -F'\t' 'BEGIN{cnt=0;tot=0;numr=0}{numr+=$4; cnt+=$5; tot+=$6;}END{print "total\t0\t"tot"\t"numr"\t"cnt"\t"tot"\t"cnt/tot}' $i; done
echo;
echo 'Mean and Max Depth Coverage (last and last-2 columns)';
for i in `echo *.summary.txt`; do echo $i; grep "total" $i; done
echo;
echo 'Number of Alignments';
for i in `echo *.samtools.out`; do echo $i; cat $i; done

