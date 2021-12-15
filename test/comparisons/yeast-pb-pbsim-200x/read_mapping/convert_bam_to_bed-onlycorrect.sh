#!/bin/bash

for i in `echo *.bam`; do echo $i; fname=`basename $i | sed s/.bam/.bam.bed/g`;
samtools view $i "chrI" | awk -v FS='\t' '{if(substr($0,0,3) == "S1_"){print $1"\tchrI\t"($4-1);}}' > $fname;
samtools view $i "chrII" | awk -v FS='\t' '{if(substr($0,0,3) == "S2_"){print $1"\tchrII\t"($4-1);}}' >> $fname;
samtools view $i "chrIII" | awk -v FS='\t' '{if(substr($0,0,3) == "S3_"){print $1"\tchrIII\t"($4-1);}}' >> $fname;
samtools view $i "chrIV" | awk -v FS='\t' '{if(substr($0,0,3) == "S4_"){print $1"\tchrIV\t"($4-1);}}' >> $fname;
samtools view $i "chrIX" | awk -v FS='\t' '{if(substr($0,0,3) == "S5_"){print $1"\tchrIX\t"($4-1);}}' >> $fname;
samtools view $i "chrM" | awk -v FS='\t' '{if(substr($0,0,3) == "S6_"){print $1"\tchrM\t"($4-1);}}' >> $fname;
samtools view $i "chrV" | awk -v FS='\t' '{if(substr($0,0,3) == "S7_"){print $1"\tchrV\t"($4-1);}}' >> $fname;
samtools view $i "chrVI" | awk -v FS='\t' '{if(substr($0,0,3) == "S8_"){print $1"\tchrVI\t"($4-1);}}' >> $fname;
samtools view $i "chrVII" | awk -v FS='\t' '{if(substr($0,0,3) == "S9_"){print $1"\tchrVII\t"($4-1);}}' >> $fname;
samtools view $i "chrVIII" | awk -v FS='\t' '{if(substr($0,0,4) == "S10_"){print $1"\tchrVIII\t"($4-1);}}' >> $fname;
samtools view $i "chrX" | awk -v FS='\t' '{if(substr($0,0,4) == "S11_"){print $1"\tchrX\t"($4-1);}}' >> $fname;
samtools view $i "chrXI" | awk -v FS='\t' '{if(substr($0,0,4) == "S12_"){print $1"\tchrXI\t"($4-1);}}' >> $fname;
samtools view $i "chrXII" | awk -v FS='\t' '{if(substr($0,0,4) == "S13_"){print $1"\tchrXII\t"($4-1);}}' >> $fname;
samtools view $i "chrXIII" | awk -v FS='\t' '{if(substr($0,0,4) == "S14_"){print $1"\tchrXIII\t"($4-1);}}' >> $fname;
samtools view $i "chrXIV" | awk -v FS='\t' '{if(substr($0,0,4) == "S15_"){print $1"\tchrXIV\t"($4-1);}}' >> $fname;
samtools view $i "chrXV" | awk -v FS='\t' '{if(substr($0,0,4) == "S16_"){print $1"\tchrXV\t"($4-1);}}' >> $fname;
samtools view $i "chrXVI" | awk -v FS='\t' '{if(substr($0,0,4) == "S17_"){print $1"\tchrXVI\t"($4-1);}}' >> $fname;
done

