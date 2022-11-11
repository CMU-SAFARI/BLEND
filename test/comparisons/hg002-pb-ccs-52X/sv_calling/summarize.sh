#!/bin/bash
# echo 'SV results compared to the entire Tier 1 set:'
# for i in `echo ./{blend,minimap2,lra,winnowmap}/giab_report.txt`; do echo $i; 
# 	awk '{
# 		if(NR == 2){
# 			printf("Recall: %.4f\n", $2);
# 		}else if(NR == 3){
# 			printf("Precision: %.4f\n", $2);
# 		}else if(NR == 4){
# 			printf("F1 score: %.4f\n", $2);
# 		}else if(NR <= 10 && $1 == "tp"){
# 			printf("True positives: %d\n", $2);
# 		}else if(NR <= 10 && $1 == "fn"){
# 			printf("False negatives %d\n", $2);
# 		}else if(NR <= 10 && $1 == "fp"){
# 			printf("False positives %d\n", $2);
# 		}
# 	}' $i; done

# echo;
echo 'SV results compared to the sequence-resolved SVs in the Tier 1 set:'
for i in `echo ./*_pass/giab_report.txt`; do echo $i; 
	awk '{
		if(NR == 2){
			printf("Recall: %.4f\n", $2);
		}else if(NR == 3){
			printf("Precision: %.4f\n", $2);
		}else if(NR == 4){
			printf("F1 score: %.4f\n", $2);
		}else if(NR <= 10 && $1 == "tp"){
			printf("True positives: %d\n", $2);
		}else if(NR <= 10 && $1 == "fn"){
			printf("False negatives %d\n", $2);
		}else if(NR <= 10 && $1 == "fp"){
			printf("False positives %d\n", $2);
		}
	}' $i; done