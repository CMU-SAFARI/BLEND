#!/bin/bash

######################################################
#PART1: Find minimizers with and without the BLEND functionality and report the non-identical sequences with the same hash value that are picked as minimizers
#We calculate edit distance between these non-identical sequences that generate the same hash value and report in *_sim.csv files.
#The statistics regarding the collision (e.g., edit distance of these colliding sequence pairs) are in the *_collision_stats.txt files
######################################################

#BLEND (--neighbors = 3) (seed length = 14 + 3 - 1 = 16-mers)
samtools faidx ../../data/e.coli-pb-sequelii/ref.fa "ecoli.genome" | blend -k 14 --neighbors 3 -w 10 --dbg-blend_hash -d ind - > blend_n3_sim.csv 2> blend_n3_collision_stats.txt
# Making sure the sequence pairs are unique (i.e., no repetitive collisions)
echo 'Hash Value,Minimizer 1,Minimizer 2,Edit Distance' > blend_n3_sim.tmp
awk -F',' '{if(dict[$2] != 1){print $0; dict[$2]=1;}}' blend_n3_sim.csv >> blend_n3_sim.tmp; rm blend_n3_sim.csv; mv blend_n3_sim.tmp blend_n3_sim.csv

#BLEND (--neighbors = 5) (seed length = 16-mers)
samtools faidx ../../data/e.coli-pb-sequelii/ref.fa "ecoli.genome" | blend -k 12 --neighbors 5 -w 10 --dbg-blend_hash -d ind - > blend_n5_sim.csv 2> blend_n5_collision_stats.txt
# Making sure the sequence pairs are unique (i.e., no repetitive collisions)
echo 'Hash Value,Minimizer 1,Minimizer 2,Edit Distance' > blend_n5_sim.tmp
awk -F',' '{if(dict[$2] != 1){print $0; dict[$2]=1;}}' blend_n5_sim.csv >> blend_n5_sim.tmp; rm blend_n5_sim.csv; mv blend_n5_sim.tmp blend_n5_sim.csv

#BLEND (--neighbors = 7) (seed length = 16-mers)
samtools faidx ../../data/e.coli-pb-sequelii/ref.fa "ecoli.genome" | blend -k 10 --neighbors 7 -w 10 --dbg-blend_hash -d ind - > blend_n7_sim.csv 2> blend_n7_collision_stats.txt
# Making sure the sequence pairs are unique (i.e., no repetitive collisions)
echo 'Hash Value,Minimizer 1,Minimizer 2,Edit Distance' > blend_n7_sim.tmp
awk -F',' '{if(dict[$2] != 1){print $0; dict[$2]=1;}}' blend_n7_sim.csv >> blend_n7_sim.tmp; rm blend_n7_sim.csv; mv blend_n7_sim.tmp blend_n7_sim.csv

#BLEND (--neighbors = 9) (seed length = 16-mers)
samtools faidx ../../data/e.coli-pb-sequelii/ref.fa "ecoli.genome" | blend -k 8 --neighbors 9 -w 10 --dbg-blend_hash -d ind - > blend_n9_sim.csv 2> blend_n9_collision_stats.txt
# Making sure the sequence pairs are unique (i.e., no repetitive collisions)
echo 'Hash Value,Minimizer 1,Minimizer 2,Edit Distance' > blend_n9_sim.tmp
awk -F',' '{if(dict[$2] != 1){print $0; dict[$2]=1;}}' blend_n9_sim.csv >> blend_n9_sim.tmp; rm blend_n9_sim.csv; mv blend_n9_sim.tmp blend_n9_sim.csv

#BLEND (--neighbors = 11) (seed length = 16-mers)
samtools faidx ../../data/e.coli-pb-sequelii/ref.fa "ecoli.genome" | blend -k 6 --neighbors 11 -w 10 --dbg-blend_hash -d ind - > blend_n11_sim.csv 2> blend_n11_collision_stats.txt
# Making sure the sequence pairs are unique (i.e., no repetitive collisions)
echo 'Hash Value,Minimizer 1,Minimizer 2,Edit Distance' > blend_n11_sim.tmp
awk -F',' '{if(dict[$2] != 1){print $0; dict[$2]=1;}}' blend_n11_sim.csv >> blend_n11_sim.tmp; rm blend_n11_sim.csv; mv blend_n11_sim.tmp blend_n11_sim.csv

#BLEND (--neighbors = 13) (seed length = 16-mers)
samtools faidx ../../data/e.coli-pb-sequelii/ref.fa "ecoli.genome" | blend -k 4 --neighbors 13 -w 10 --dbg-blend_hash -d ind - > blend_n13_sim.csv 2> blend_n13_collision_stats.txt
# Making sure the sequence pairs are unique (i.e., no repetitive collisions)
echo 'Hash Value,Minimizer 1,Minimizer 2,Edit Distance' > blend_n13_sim.tmp
awk -F',' '{if(dict[$2] != 1){print $0; dict[$2]=1;}}' blend_n13_sim.csv >> blend_n13_sim.tmp; rm blend_n13_sim.csv; mv blend_n13_sim.tmp blend_n13_sim.csv

#Regular hash function that minimap2 uses (the dbg-hash flag disables the BLEND functionality) (seed length = 16+3-1 = 16-mers)
samtools faidx ../../data/e.coli-pb-sequelii/ref.fa "ecoli.genome" | blend -k 14 --neighbors 3 -w 10 --dbg-hash -d ind - > minimap2_sim.csv 2> minimap2_collision_stats.txt
# Making sure the sequence pairs are unique (i.e., no repetitive collisions)
echo 'Hash Value,Minimizer 1,Minimizer 2,Edit Distance' > minimap2_sim.tmp
awk -F',' '{if(dict[$2] != 1){print $0; dict[$2]=1;}}' minimap2_sim.csv >> minimap2_sim.tmp; rm minimap2_sim.csv; mv minimap2_sim.tmp minimap2_sim.csv

#At this point, the ratio values in the *_stats.txt files should be included in the fuzzy_matches.csv file using the same csv format that fuzzy_matches.csv already has.
#Please update fuzzy_matches.csv with your results, before generating the figures.

#the following code generates sequence pairs (2nd and 3rd oclumns) that have a collision with their hash values (first column) with edit distance <= 3 (~20% diff.)
# for i in `echo *_sim.csv`; do fname=`basename $i | sed 's/_sim.csv/_sim_e3.csv/g'`; awk '{if($4 <= 3)print $0}' $i > $fname; done

######################################################
#PART2: 1) We extract 25-mers from the e.coli reference genome and align them back to the same reference genome by allowing mismatches up to 3 characters
#2) We also extract the aligned regions from the reference genome.
#Our set includes: 1) The extracted 25-mers that have an alignment with at least 1 mismatch in the reference genome and 2) the portions in the reference genome that our extracted 25-mers align to with at most 3 mismatches.
#We then find matching 16-mers within this dataset. We report non-identical 16-mers with the same hash value along with their distances (*_kmer.csv files).
#Note the extra --dbg-sim-hash flag we add in this experiment although the rest of the commands are exactly the same as above.
#The --dbg-sim-hash ensures we do not find minimizers, rather we go through all 16-mers within 25-character long sequences that we include in our dataset.
######################################################

#Extract non-overlapping 25-mers (separated by 100 characters to avoid potential repeats) from the E. coli genome
for ((i = 1; i < 4944400; i = i+100)); do (( end = i + 24 )); samtools faidx ../../data/e.coli-pb-sequelii/ref.fa ecoli.genome:$i"-"$end >> ecoli_kmers.fasta; done
#1) Align 25-mers to the reference genome it is extracted from. Allow at most 3 mismatches. 2) Extract the alignments with at least 1 mismatch
bowtie -v 3 -a -f ../../data/e.coli-pb-sequelii/ref.fa ecoli_kmers.fasta | awk '{if($2 == "+" && $8 != null)print $0}' > bowtie.out

# #The following will generate a FASTA file for each group of sequences that align to each other. The IDs without the "_sim_" subsequence are the original k-mer we sampled
# The rest of the reads are the reference sequences that align to the sampled sequence
mkdir aligned_kmers
awk '{start = $4+1; end=start+24;
if(last!=$1){
	print ">"$1 > "./aligned_kmers/ecoli_"$5".fasta"; 
	print $5 >> "./aligned_kmers/ecoli_"$5".fasta"; 
	last=$1
	if(last5 != null)
		close("./aligned_kmers/ecoli_"last5".fasta")
	last5=$5
} 
print ">ecoli.genome_sim_"start"_"end >> "./aligned_kmers/ecoli_"$5".fasta"; 
c = "samtools faidx ../../data/e.coli-pb-sequelii/ref.fa ecoli.genome:"start"-"end" | grep -v \">\"";
c | getline line;
close( c );
print line >> "./aligned_kmers/ecoli_"$5".fasta";
}' bowtie.out

rm ./bowtie.out

#BLEND (--neighbors = 3) (seed length = 14 + 3 - 1 = 16-mers)
rm blend_n3_kmer.csv
for i in `echo ./aligned_kmers/*.fasta`; do blend -k 14 --neighbors 3 -w 10 --dbg-blend_hash --dbg-sim-hash -d ind $i >> blend_n3_kmer.csv 2> tmp.err; rm tmp.err; done
# Making sure the sequence pairs are unique (i.e., no repetitive collisions)
echo 'Hash Value,Sequence 1,Sequence 2,K-mer 1,K-mer 2,Edit Distance' > blend_n3_kmer.tmp
awk -F',' '{seq=$2$3; if(dict[seq] != 1){print $0; dict[seq]=1;}}' blend_n3_kmer.csv >> blend_n3_kmer.tmp; rm blend_n3_kmer.csv; mv blend_n3_kmer.tmp blend_n3_kmer.csv

#BLEND (--neighbors = 5) (seed length = 16-mers)
rm blend_n5_kmer.csv
for i in `echo ./aligned_kmers/*.fasta`; do blend -k 12 --neighbors 5 -w 10 --dbg-blend_hash --dbg-sim-hash -d ind $i >> blend_n5_kmer.csv 2> tmp.err; rm tmp.err; done
# Making sure the sequence pairs are unique (i.e., no repetitive collisions)
echo 'Hash Value,Sequence 1,Sequence 2,K-mer 1,K-mer 2,Edit Distance' > blend_n5_kmer.tmp
awk -F',' '{seq=$2$3; if(dict[seq] != 1){print $0; dict[seq]=1;}}' blend_n5_kmer.csv >> blend_n5_kmer.tmp; rm blend_n5_kmer.csv; mv blend_n5_kmer.tmp blend_n5_kmer.csv

#BLEND (--neighbors = 7) (seed length = 16-mers)
rm blend_n7_kmer.csv
for i in `echo ./aligned_kmers/*.fasta`; do blend -k 10 --neighbors 7 -w 10 --dbg-blend_hash --dbg-sim-hash -d ind $i >> blend_n7_kmer.csv 2> tmp.err; rm tmp.err; done
# Making sure the sequence pairs are unique (i.e., no repetitive collisions)
echo 'Hash Value,Sequence 1,Sequence 2,K-mer 1,K-mer 2,Edit Distance' > blend_n7_kmer.tmp
awk -F',' '{seq=$2$3; if(dict[seq] != 1){print $0; dict[seq]=1;}}' blend_n7_kmer.csv >> blend_n7_kmer.tmp; rm blend_n7_kmer.csv; mv blend_n7_kmer.tmp blend_n7_kmer.csv

#BLEND (--neighbors = 9) (seed length = 16-mers)
rm blend_n9_kmer.csv
for i in `echo ./aligned_kmers/*.fasta`; do blend -k 8 --neighbors 9 -w 10 --dbg-blend_hash --dbg-sim-hash -d ind $i >> blend_n9_kmer.csv 2> tmp.err; rm tmp.err; done
# Making sure the sequence pairs are unique (i.e., no repetitive collisions)
echo 'Hash Value,Sequence 1,Sequence 2,K-mer 1,K-mer 2,Edit Distance' > blend_n9_kmer.tmp
awk -F',' '{seq=$2$3; if(dict[seq] != 1){print $0; dict[seq]=1;}}' blend_n9_kmer.csv >> blend_n9_kmer.tmp; rm blend_n9_kmer.csv; mv blend_n9_kmer.tmp blend_n9_kmer.csv

#BLEND (--neighbors = 11) (seed length = 16-mers)
rm blend_n11_kmer.csv
for i in `echo ./aligned_kmers/*.fasta`; do blend -k 6 --neighbors 11 -w 10 --dbg-blend_hash --dbg-sim-hash -d ind $i >> blend_n11_kmer.csv 2> tmp.err; rm tmp.err; done
# Making sure the sequence pairs are unique (i.e., no repetitive collisions)
echo 'Hash Value,Sequence 1,Sequence 2,K-mer 1,K-mer 2,Edit Distance' > blend_n11_kmer.tmp
awk -F',' '{seq=$2$3; if(dict[seq] != 1){print $0; dict[seq]=1;}}' blend_n11_kmer.csv >> blend_n11_kmer.tmp; rm blend_n11_kmer.csv; mv blend_n11_kmer.tmp blend_n11_kmer.csv

#BLEND (--neighbors = 13) (seed length = 16-mers)
rm blend_n13_kmer.csv
for i in `echo ./aligned_kmers/*.fasta`; do blend -k 4 --neighbors 13 -w 10 --dbg-blend_hash --dbg-sim-hash -d ind $i >> blend_n13_kmer.csv 2> tmp.err; rm tmp.err; done
# Making sure the sequence pairs are unique (i.e., no repetitive collisions)
echo 'Hash Value,Sequence 1,Sequence 2,K-mer 1,K-mer 2,Edit Distance' > blend_n13_kmer.tmp
awk -F',' '{seq=$2$3; if(dict[seq] != 1){print $0; dict[seq]=1;}}' blend_n13_kmer.csv >> blend_n13_kmer.tmp; rm blend_n13_kmer.csv; mv blend_n13_kmer.tmp blend_n13_kmer.csv

#Regular hash function that minimap2 uses (the dbg-hash flag disables the BLEND functionality) (seed length = 16+3-1 = 16-mers)
rm minimap2_kmer.csv
for i in `echo ./aligned_kmers/*.fasta`; do blend -k 14 --neighbors 3 -w 10 --dbg-hash --dbg-sim-hash -d ind $i >> minimap2_kmer.csv 2> tmp.err; rm tmp.err; done
# Making sure the sequence pairs are unique (i.e., no repetitive collisions)
echo 'Hash Value,Sequence 1,Sequence 2,K-mer 1,K-mer 2,Edit Distance' > minimap2_kmer.tmp
awk -F',' '{seq=$2$3; if(dict[seq] != 1){print $0; dict[seq]=1;}}' minimap2_kmer.csv >> minimap2_kmer.tmp; rm minimap2_kmer.csv; mv minimap2_kmer.tmp minimap2_kmer.csv

for i in `echo *_kmer.csv`; do echo $i; numseq=$(grep ">" ecoli_aligned_kmers.fasta | wc -l); numcollision=$(( $(cat $i | wc -l) - 1 )); echo 'Number of sequences:' $numseq; echo 'Number of k-mers with collision:' $numcollision; awk -F',' -v colm="$numcollision" -v seqn="$numseq" 'BEGIN{count=0;edit=0; print "Collision/Sequence Ratio: " colm/seqn;}{if(NR>1){count++; edit+=$6}}END{if(count>0)print "Average Edit Distance Between Sequences with Collision: " edit/count}' $i; echo; done

rm ./ind
