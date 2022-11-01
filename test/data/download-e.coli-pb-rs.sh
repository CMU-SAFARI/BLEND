#!/bin/bash

mkdir -p ./e.coli-pb-rs/; cd e.coli-pb-rs/

wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/000/SRR1509640/SRR1509640_subreads.fastq.gz; gunzip SRR1509640_subreads.fastq.gz;
seqtk seq -A SRR1509640_subreads.fastq > SRR1509640_subreads.fasta

wget -O ref.fa.gz 'https://www.ebi.ac.uk/ena/browser/api/fasta/GCA_000732965.1?download=true&gzip=true'; gunzip ref.fa.gz;
samtools faidx ref.fa

echo 'ENA|CP008957|CP008957.1	0	5547323
ENA|CP008958|CP008958.1	0	92076' > ref.bed
