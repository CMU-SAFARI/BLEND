#!/bin/bash

#Download Simulated ONT reads (30X coverage) and the reference genome used in the BLEND submission
wget https://zenodo.org/record/7261610/files/chm13-ont-pbsim2.tar.gz; tar -xzf chm13-ont-pbsim2.tar.gz; rm chm13-ont-pbsim2.tar.gz;

cd chm13-ont-pbsim2

#Download CHM13 v2 (reference)
# wget https://s3-us-west-2.amazonaws.com/human-pangenomics/T2T/CHM13/assemblies/analysis_set/chm13v2.0.fa.gz; gunzip chm13v2.0.fa.gz; mv chm13v2.0.fa ref.fa; samtools faidx ref.fa

# echo 'chr1	0	248387328
# chr2	0	242696752
# chr3	0	201105948
# chr4	0	193574945
# chr5	0	182045439
# chr6	0	172126628
# chr7	0	160567428
# chr8	0	146259331
# chr9	0	150617247
# chr10	0	134758134
# chr11	0	135127769
# chr12	0	133324548
# chr13	0	113566686
# chr14	0	101161492
# chr15	0	99753195
# chr16	0	96330374
# chr17	0	84276897
# chr18	0	80542538
# chr19	0	61707364
# chr20	0	66210255
# chr21	0	45090682
# chr22	0	51324926
# chrX	0	154259566
# chrY	0	62460029
# chrM	0	16569' > ref.bed;