#!/bin/bash

for i in `echo *.sam`; do echo $i; fname=`basename $i | sed s/.sam/.bam.bed/g`;
cat $i | awk -v FS='\t' '{if(substr($3,0,4) == "chrI"){if(substr($0,0,3) == "S1_"){print $1"\tchrI\t"($4-1);}}}' > $fname;
cat $i | awk -v FS='\t' '{if(substr($3,0,5) == "chrII"){if(substr($0,0,3) == "S2_"){print $1"\tchrII\t"($4-1);}}}' >> $fname;
cat $i | awk -v FS='\t' '{if(substr($3,0,6) == "chrIII"){if(substr($0,0,3) == "S3_"){print $1"\tchrIII\t"($4-1);}}}' >> $fname;
cat $i | awk -v FS='\t' '{if(substr($3,0,5) == "chrIV"){if(substr($0,0,3) == "S4_"){print $1"\tchrIV\t"($4-1);}}}' >> $fname;
cat $i | awk -v FS='\t' '{if(substr($3,0,5) == "chrIX"){if(substr($0,0,3) == "S5_"){print $1"\tchrIX\t"($4-1);}}}' >> $fname;
cat $i | awk -v FS='\t' '{if(substr($3,0,4) == "chrM"){if(substr($0,0,3) == "S6_"){print $1"\tchrM\t"($4-1);}}}' >> $fname;
cat $i | awk -v FS='\t' '{if(substr($3,0,4) == "chrV"){if(substr($0,0,3) == "S7_"){print $1"\tchrV\t"($4-1);}}}' >> $fname;
cat $i | awk -v FS='\t' '{if(substr($3,0,5) == "chrVI"){if(substr($0,0,3) == "S8_"){print $1"\tchrVI\t"($4-1);}}}' >> $fname;
cat $i | awk -v FS='\t' '{if(substr($3,0,6) == "chrVII"){if(substr($0,0,3) == "S9_"){print $1"\tchrVII\t"($4-1);}}}' >> $fname;
cat $i | awk -v FS='\t' '{if(substr($3,0,7) == "chrVIII"){if(substr($0,0,4) == "S10_"){print $1"\tchrVIII\t"($4-1);}}}' >> $fname;
cat $i | awk -v FS='\t' '{if(substr($3,0,4) == "chrX"){if(substr($0,0,4) == "S11_"){print $1"\tchrX\t"($4-1);}}}' >> $fname;
cat $i | awk -v FS='\t' '{if(substr($3,0,5) == "chrXI"){if(substr($0,0,4) == "S12_"){print $1"\tchrXI\t"($4-1);}}}' >> $fname;
cat $i | awk -v FS='\t' '{if(substr($3,0,6) == "chrXII"){if(substr($0,0,4) == "S13_"){print $1"\tchrXII\t"($4-1);}}}' >> $fname;
cat $i | awk -v FS='\t' '{if(substr($3,0,7) == "chrXIII"){if(substr($0,0,4) == "S14_"){print $1"\tchrXIII\t"($4-1);}}}' >> $fname;
cat $i | awk -v FS='\t' '{if(substr($3,0,6) == "chrXIV"){if(substr($0,0,4) == "S15_"){print $1"\tchrXIV\t"($4-1);}}}' >> $fname;
cat $i | awk -v FS='\t' '{if(substr($3,0,5) == "chrXV"){if(substr($0,0,4) == "S16_"){print $1"\tchrXV\t"($4-1);}}}' >> $fname;
cat $i | awk -v FS='\t' '{if(substr($3,0,6) == "chrXVI"){if(substr($0,0,4) == "S17_"){print $1"\tchrXVI\t"($4-1);}}}' >> $fname;
done

