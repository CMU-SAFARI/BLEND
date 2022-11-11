#!/bin/bash

echo 'Breadth of Coverage (%):';
for i in `echo *.breadth`; do echo $i; awk -F'\t' 'BEGIN{cnt=0;tot=0;numr=0}{numr+=$4; cnt+=$5; tot+=$6;}END{printf("%.3f\n", 100*cnt/tot)}' $i; done
echo;
echo 'Mean Depth of Coverage:';
for i in `echo *.summary.txt`; do echo $i; grep "total" $i | awk -F'\t' '{printf("%.2f\n", $4)}'; done
echo;
echo 'Number of Alignments';
for i in `echo *.samtools.out`; do echo $i; cat $i; done
echo;

echo 'Read mapping accuracy (reported only for simulated reads)';
for i in `echo *mapeval`; do echo $i; cat $i; done

echo 'Timing and memory usage results:'
for i in `echo *.time`; do echo $i; 
	awk '{
		if(NR == 2){
			time = $NF
		}else if(NR == 3){
			time += $NF
			printf("CPU Time: %.2f\n", time)
		} else if(NR == 10){
			printf("Memory (GB): %.2f\n", $NF/1000000)
			print ""
		}
	}' $i; done
