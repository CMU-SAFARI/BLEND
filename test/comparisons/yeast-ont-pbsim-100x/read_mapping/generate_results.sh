#!/bin/bash

bash convert_bam_to_bed-onlycorrect.sh
bash convert_sam_to_bed-onlycorrect.sh
bash merge_beds.sh

echo "Precision (BLEND)"
echo "chrI:"
blend_chrI=$(cat blend.bam.joined.bed | awk -v FS=' ' '{if($2 == "chrI") print $1}' | sort | uniq | awk 'END {x = NR/2548; printf "%.4f\n", x}')
echo $blend_chrI;
echo "chrII:"
blend_chrII=$(cat blend.bam.joined.bed | awk -v FS=' ' '{if($2 == "chrII") print $1}' | sort | uniq | awk 'END {x = NR/9083; printf "%.4f\n", x}')
echo $blend_chrII;
echo "chrIII:"
blend_chrIII=$(cat blend.bam.joined.bed | awk -v FS=' ' '{if($2 == "chrIII") print $1}' | sort | uniq | awk 'END {x = NR/3557; printf "%.4f\n", x}')
echo $blend_chrIII;
echo "chrIV:"
blend_chrIV=$(cat blend.bam.joined.bed | awk -v FS=' ' '{if($2 == "chrIV") print $1}' | sort | uniq | awk 'END {x = NR/16822; printf "%.4f\n", x}')
echo $blend_chrIV;
echo "chrV:"
blend_chrV=$(cat blend.bam.joined.bed | awk -v FS=' ' '{if($2 == "chrV") print $1}' | sort | uniq | awk 'END {x = NR/6496; printf "%.4f\n", x}')
echo $blend_chrV;

echo "Precision (Minimap2)"
echo "chrI:"
minimap2_chrI=$(cat minimap2.bam.joined.bed | awk -v FS=' ' '{if($2 == "chrI") print $1}' | sort | uniq | awk 'END {x = NR/2548; printf "%.4f\n", x}')
echo $minimap2_chrI;
echo "chrII:"
minimap2_chrII=$(cat minimap2.bam.joined.bed | awk -v FS=' ' '{if($2 == "chrII") print $1}' | sort | uniq | awk 'END {x = NR/9083; printf "%.4f\n", x}')
echo $minimap2_chrII;
echo "chrIII:"
minimap2_chrIII=$(cat minimap2.bam.joined.bed | awk -v FS=' ' '{if($2 == "chrIII") print $1}' | sort | uniq | awk 'END {x = NR/3557; printf "%.4f\n", x}')
echo $minimap2_chrIII;
echo "chrIV:"
minimap2_chrIV=$(cat minimap2.bam.joined.bed | awk -v FS=' ' '{if($2 == "chrIV") print $1}' | sort | uniq | awk 'END {x = NR/16822; printf "%.4f\n", x}')
echo $minimap2_chrIV;
echo "chrV:"
minimap2_chrV=$(cat minimap2.bam.joined.bed | awk -v FS=' ' '{if($2 == "chrV") print $1}' | sort | uniq | awk 'END {x = NR/6496; printf "%.4f\n", x}')
echo $minimap2_chrV;

echo "Precision (LRA)"
echo "chrI:"
lra_chrI=$(cat lra.bam.joined.bed | awk -v FS=' ' '{if($2 == "chrI") print $1}' | sort | uniq | awk 'END {x = NR/2548; printf "%.4f\n", x}')
echo $lra_chrI;
echo "chrII:"
lra_chrII=$(cat lra.bam.joined.bed | awk -v FS=' ' '{if($2 == "chrII") print $1}' | sort | uniq | awk 'END {x = NR/9083; printf "%.4f\n", x}')
echo $lra_chrII;
echo "chrIII:"
lra_chrIII=$(cat lra.bam.joined.bed | awk -v FS=' ' '{if($2 == "chrIII") print $1}' | sort | uniq | awk 'END {x = NR/3557; printf "%.4f\n", x}')
echo $lra_chrIII;
echo "chrIV:"
lra_chrIV=$(cat lra.bam.joined.bed | awk -v FS=' ' '{if($2 == "chrIV") print $1}' | sort | uniq | awk 'END {x = NR/16822; printf "%.4f\n", x}')
echo $lra_chrIV;
echo "chrV:"
lra_chrV=$(cat lra.bam.joined.bed | awk -v FS=' ' '{if($2 == "chrV") print $1}' | sort | uniq | awk 'END {x = NR/6496; printf "%.4f\n", x}')
echo $lra_chrV;

echo "Precision (Winnowmap)"
echo "chrI:"
winnowmap_chrI=$(cat winnowmap.bam.joined.bed | awk -v FS=' ' '{if($2 == "chrI") print $1}' | sort | uniq | awk 'END {x = NR/2548; printf "%.4f\n", x}')
echo $winnowmap_chrI;
echo "chrII:"
winnowmap_chrII=$(cat winnowmap.bam.joined.bed | awk -v FS=' ' '{if($2 == "chrII") print $1}' | sort | uniq | awk 'END {x = NR/9083; printf "%.4f\n", x}')
echo $winnowmap_chrII;
echo "chrIII:"
winnowmap_chrIII=$(cat winnowmap.bam.joined.bed | awk -v FS=' ' '{if($2 == "chrIII") print $1}' | sort | uniq | awk 'END {x = NR/3557; printf "%.4f\n", x}')
echo $winnowmap_chrIII;
echo "chrIV:"
winnowmap_chrIV=$(cat winnowmap.bam.joined.bed | awk -v FS=' ' '{if($2 == "chrIV") print $1}' | sort | uniq | awk 'END {x = NR/16822; printf "%.4f\n", x}')
echo $winnowmap_chrIV;
echo "chrV:"
winnowmap_chrV=$(cat winnowmap.bam.joined.bed | awk -v FS=' ' '{if($2 == "chrV") print $1}' | sort | uniq | awk 'END {x = NR/6496; printf "%.4f\n", x}')
echo $winnowmap_chrV;

echo "Precision (S-conLSH)"
echo "chrI:"
conlsh_chrI=$(cat conlsh.bam.joined.bed | awk -v FS=' ' '{if($2 == "chrI") print $1}' | sort | uniq | awk 'END {x = NR/2548; printf "%.4f\n", x}')
echo $conlsh_chrI;
echo "chrII:"
conlsh_chrII=$(cat conlsh.bam.joined.bed | awk -v FS=' ' '{if($2 == "chrII") print $1}' | sort | uniq | awk 'END {x = NR/9083; printf "%.4f\n", x}')
echo $conlsh_chrII;
echo "chrIII:"
conlsh_chrIII=$(cat conlsh.bam.joined.bed | awk -v FS=' ' '{if($2 == "chrIII") print $1}' | sort | uniq | awk 'END {x = NR/3557; printf "%.4f\n", x}')
echo $conlsh_chrIII;
echo "chrIV:"
conlsh_chrIV=$(cat conlsh.bam.joined.bed | awk -v FS=' ' '{if($2 == "chrIV") print $1}' | sort | uniq | awk 'END {x = NR/16822; printf "%.4f\n", x}')
echo $conlsh_chrIV;
echo "chrV:"
conlsh_chrV=$(cat conlsh.bam.joined.bed | awk -v FS=' ' '{if($2 == "chrV") print $1}' | sort | uniq | awk 'END {x = NR/6496; printf "%.4f\n", x}')
echo $conlsh_chrV;

echo 'Read,Chromosome,Alignment,True Location,Distance,Tool' > combined_alignment_chrI-V.filtered.csv
awk -v FS=' ' '{if($5 <= 50 && $5 >= -50)print $1","$2","$3","$4","$5",BLEND"}' blend.bam.joined.bed | awk -v var1="$blend_chrI" -v var2="$blend_chrII" -v var3="$blend_chrIII" -v var4="$blend_chrIV" -v var5="$blend_chrV"  -v FS=',' '{if($2 == "chrI"){print $1","$2" (Precision: "var1"),"$3","$4","$5","$6}else if($2 == "chrII"){print $1","$2" (Precision: "var2"),"$3","$4","$5","$6}else if($2 == "chrIII"){print $1","$2" (Precision: "var3"),"$3","$4","$5","$6}else if($2 == "chrIV"){print $1","$2" (Precision: "var4"),"$3","$4","$5","$6}else if($2 == "chrV"){print $1","$2" (Precision: "var5"),"$3","$4","$5","$6}}' >> combined_alignment_chrI-V.filtered.csv

awk -v FS=' ' '{if($5 <= 50 && $5 >= -50)print $1","$2","$3","$4","$5",Minimap2"}' minimap2.bam.joined.bed | awk -v var1="$minimap2_chrI" -v var2="$minimap2_chrII" -v var3="$minimap2_chrIII" -v var4="$minimap2_chrIV" -v var5="$minimap2_chrV" -v FS=',' '{if($2 == "chrI"){print $1","$2" (Precision: "var1"),"$3","$4","$5","$6}else if($2 == "chrII"){print $1","$2" (Precision: "var2"),"$3","$4","$5","$6}else if($2 == "chrIII"){print $1","$2" (Precision: "var3"),"$3","$4","$5","$6}else if($2 == "chrIV"){print $1","$2" (Precision: "var4"),"$3","$4","$5","$6}else if($2 == "chrV"){print $1","$2" (Precision: "var5"),"$3","$4","$5","$6}}' >> combined_alignment_chrI-V.filtered.csv

awk -v FS=' ' '{if($5 <= 50 && $5 >= -50)print $1","$2","$3","$4","$5",LRA"}' lra.bam.joined.bed | awk -v var1="$lra_chrI" -v var2="$lra_chrII" -v var3="$lra_chrIII" -v var4="$lra_chrIV" -v var5="$lra_chrV" -v FS=',' '{if($2 == "chrI"){print $1","$2" (Precision: "var1"),"$3","$4","$5","$6}else if($2 == "chrII"){print $1","$2" (Precision: "var2"),"$3","$4","$5","$6}else if($2 == "chrIII"){print $1","$2" (Precision: "var3"),"$3","$4","$5","$6}else if($2 == "chrIV"){print $1","$2" (Precision: "var4"),"$3","$4","$5","$6}else if($2 == "chrV"){print $1","$2" (Precision: "var5"),"$3","$4","$5","$6}}' >> combined_alignment_chrI-V.fixltered.csv

awk -v FS=' ' '{if($5 <= 50 && $5 >= -50)print $1","$2","$3","$4","$5",Winnowmap"}' winnowmap.bam.joined.bed | awk -v var1="$winnowmap_chrI" -v var2="$winnowmap_chrII" -v var3="$winnowmap_chrIII" -v var4="$winnowmap_chrIV" -v var5="$winnowmap_chrV" -v FS=',' '{if($2 == "chrI"){print $1","$2" (Precision: "var1"),"$3","$4","$5","$6}else if($2 == "chrII"){print $1","$2" (Precision: "var2"),"$3","$4","$5","$6}else if($2 == "chrIII"){print $1","$2" (Precision: "var3"),"$3","$4","$5","$6}else if($2 == "chrIV"){print $1","$2" (Precision: "var4"),"$3","$4","$5","$6}else if($2 == "chrV"){print $1","$2" (Precision: "var5"),"$3","$4","$5","$6}}' >> combined_alignment_chrI-V.filtered.csv

awk -v FS=' ' '{if($5 <= 50 && $5 >= -50)print $1","$2","$3","$4","$5",S-conLSH"}' conlsh.bam.joined.bed | awk -v var1="$conlsh_chrI" -v var2="$conlsh_chrII" -v var3="$conlsh_chrIII" -v var4="$conlsh_chrIV" -v var5="$conlsh_chrV" -v FS=',' '{if($2 == "chrI"){print $1","$2" (Precision: "var1"),"$3","$4","$5","$6}else if($2 == "chrII"){print $1","$2" (Precision: "var2"),"$3","$4","$5","$6}else if($2 == "chrIII"){print $1","$2" (Precision: "var3"),"$3","$4","$5","$6}else if($2 == "chrIV"){print $1","$2" (Precision: "var4"),"$3","$4","$5","$6}else if($2 == "chrV"){print $1","$2" (Precision: "var5"),"$3","$4","$5","$6}}' >> combined_alignment_chrI-V.filtered.csv

bash evaluate-read_mapping.sh
bash mapeval.sh
bash summarize-evaluate-read_mapping.sh

