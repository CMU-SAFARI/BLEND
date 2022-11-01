#!/bin/bash

mkdir -p hg002-pb-ccs-52X && cd hg002-pb-ccs-52X;

#FTP directory: https://ftp.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/AshkenazimTrio/HG002_NA24385_son/PacBio_CCS_15kb_20kb_chemistry2/reads/
wget https://ftp.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/AshkenazimTrio/HG002_NA24385_son/PacBio_CCS_15kb_20kb_chemistry2/reads/m64011_190901_095311.fastq.gz
wget https://ftp.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/AshkenazimTrio/HG002_NA24385_son/PacBio_CCS_15kb_20kb_chemistry2/reads/m64011_190830_220126.fastq.gz
wget https://ftp.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/AshkenazimTrio/HG002_NA24385_son/PacBio_CCS_15kb_20kb_chemistry2/reads/m64012_190920_173625.fastq.gz
wget https://ftp.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/AshkenazimTrio/HG002_NA24385_son/PacBio_CCS_15kb_20kb_chemistry2/reads/m64012_190921_234837.fastq.gz
wget https://ftp.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/AshkenazimTrio/HG002_NA24385_son/PacBio_CCS_15kb_20kb_chemistry2/reads/m64015_190920_185703.fastq.gz
wget https://ftp.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/AshkenazimTrio/HG002_NA24385_son/PacBio_CCS_15kb_20kb_chemistry2/reads/m64015_190922_010918.fastq.gz

zcat m6401* > SRR10382244-9.fastq; rm m6401*.gz
seqtk seq -A SRR10382244-9.fastq > SRR10382244-9.fasta

wget https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/references/GRCh37/hs37d5.fa.gz;
wget https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/references/GRCh37/hs37d5.fa.gz.fai;
wget https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/references/GRCh37/hs37d5.fa.gz.gzi;
samtools faidx hs37d5.fa.gz 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X Y MT > ref.fa
samtools faidx ref.fa
rm hs37d5.fa.gz*

echo '1	0	249250621
2	0	243199373
3	0	198022430
4	0	191154276
5	0	180915260
6	0	171115067
7	0	159138663
8	0	146364022
9	0	141213431
10	0	135534747
11	0	135006516
12	0	133851895
13	0	115169878
14	0	107349540
15	0	102531392
16	0	90354753
17	0	81195210
18	0	78077248
19	0	59128983
20	0	63025520
21	0	48129895
22	0	51304566
X	0	155270560
Y	0	59373566
MT	0	16569' > ref.bed

mkdir vcf; cd vcf

wget https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/AshkenazimTrio/HG002_NA24385_son/NIST_SV_v0.6/HG002_SVs_Tier1_v0.6.bed
wget https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/AshkenazimTrio/HG002_NA24385_son/NIST_SV_v0.6/HG002_SVs_Tier1_v0.6.vcf.gz
wget https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/AshkenazimTrio/HG002_NA24385_son/NIST_SV_v0.6/HG002_SVs_Tier1_v0.6.vcf.gz.tbi
