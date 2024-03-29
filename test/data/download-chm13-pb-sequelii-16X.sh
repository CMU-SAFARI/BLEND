#!/bin/bash

mkdir -p chm13-pb-sequelii-16X && cd chm13-pb-sequelii-16X;
#Download Human CHM13 PacBio HiFi reads (16X coverage) and the reference genome used in the BLEND submission
wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR112/022/SRR11292122/SRR11292122_subreads.fastq.gz 
wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR112/023/SRR11292123/SRR11292123_subreads.fastq.gz
zcat SRR11292122_subreads.fastq.gz SRR11292123_subreads.fastq.gz > SRR11292122-3_subreads.fastq
seqtk seq -A SRR11292122-3_subreads.fastq > SRR11292122-3_subreads.fasta

# Download the reference (this is an older version, initial version of BLEND was evaluated using CHM v1.1)
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/009/914/755/GCA_009914755.3_T2T-CHM13v1.1/GCA_009914755.3_T2T-CHM13v1.1_genomic.fna.gz; gunzip GCA_009914755.3_T2T-CHM13v1.1_genomic.fna.gz; mv GCA_009914755.3_T2T-CHM13v1.1_genomic.fna ref.fa; samtools faidx ref.fa

# BED file of the reference full regions (older version)
echo 'CP068277.2	0	248387328
CP068276.2	0	242696752
CP068275.2	0	201105948
CP068274.2	0	193574945
CP068273.2	0	182045439
CP068272.2	0	172126628
CP068271.2	0	160567428
CP068270.2	0	146259331
CP068269.2	0	150617247
CP068268.2	0	134758134
CP068267.2	0	135127769
CP068266.2	0	133324548
CP068265.2	0	113566686
CP068264.2	0	101161492
CP068263.2	0	99753195
CP068262.2	0	96330374
CP068261.2	0	84276897
CP068260.2	0	80542538
CP068259.2	0	61707364
CP068258.2	0	66210255
CP068257.2	0	45090682
CP068256.2	0	51324926
CP068255.2	0	154259566
CP068254.1	0	16569' > ref.bed
