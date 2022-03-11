#!/bin/bash

echo 'Percentage,Tool,Data' > combined_dist.csv
awk -F',' 'BEGIN{}{val=int($2*100/1400000); for(i=0; i<val; ++i){print $1","$3","$4} }END{}' human.csv >> combined_dist.csv
awk -F',' 'BEGIN{}{val=int($2*100/100000); for(i=0; i<val; ++i){print $1","$3","$4} }END{}' dana.csv >> combined_dist.csv
awk -F',' 'BEGIN{}{val=int($2*100/3500); for(i=0; i<val; ++i){print $1","$3","$4} }END{}' ecoli.csv >> combined_dist.csv
awk -F',' 'BEGIN{}{val=int($2*100/16000); for(i=0; i<val; ++i){print $1","$3","$4} }END{}' yeastpb.csv >> combined_dist.csv
awk -F',' 'BEGIN{}{val=int($2*100/9000); for(i=0; i<val; ++i){print $1","$3","$4} }END{}' yeastont.csv >> combined_dist.csv

python3 gc.py combined_dist.csv

rm combined_dist.csv
