#!/bin/bash

for i in `echo ./*/summary.txt`; do echo $i; awk '{if(NR == 6){print "Precision (%): "$2*100}else if(NR == 7){print "Recall (%): "$2*100}else if(NR == 8){print "F1 Score: "($2/100)*100}}' $i; done

