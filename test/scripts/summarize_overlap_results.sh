
echo 'Dnadiff results:';
for i in `echo ./dnadiff/*.report`; do echo $i; awk '{if(NR == 24){print "Avg. Identity: "$3}else if(NR == 12){print "Genome Fraction: "$2}}' $i; done

echo;
echo 'QUAST results:';
awk -F '\t' '{
    if(NR == 1){
        for(i = 2; i <= NF; i++){
            tool[i-2] = $i
        }
    }
    if($1 == "K-mer-based compl. (%)"){
        print ""
        print "K-mer Completeness (%):"
        for(i = 2; i <= NF; i++){
            print tool[i-2]": "$i
        }
    }else if($1 == "Total aligned length"){
        print ""
        print "Aligned Length (Mbp): "
        for(i = 2; i <= NF; i++){
            print tool[i-2]": "$i/1000000
        }
    } else if($1 == "# mismatches per 100 kbp"){
        print ""
        print "Mismatch per 100Kbp:"
        for(i = 2; i <= NF; i++){
            print tool[i-2]": "$i
        }
    } else if($1 == "NGA50"){
        print ""
        print "NGA50 (Kbp):"
        for(i = 2; i <= NF; i++){
            print tool[i-2]": "$i/1000
        }
    } else if($1 == "GC (%)"){
        print ""
        print "Average GC (%):"
        for(i = 2; i <= NF; i++){
            print tool[i-2]": "$i
        }
    } else if($1 == "Total length"){
        print ""
        print "Assembly Length (Mbp):"
        for(i = 2; i <= NF; i++){
            print tool[i-2]": "$i/1000000
        }
    }else if($1 == "Largest contig"){
        print ""
        print "Largest contig (Mbp):"
        for(i = 2; i <= NF; i++){
            print tool[i-2]": "$i/1000000
        }
    }else if($1 == "NG50"){
        print ""
        print "NG50 (Kbp):"
        for(i = 2; i <= NF; i++){
            print tool[i-2]": "$i/1000
        }
    }
}' ./quast/report.tsv

echo;
echo 'Overlap Statistics';
for i in `echo ./*_overlap.stats`; do echo $i; cat $i | awk '{
    if(NR == 1){
        print "Total Overlap (M):"
        print $NF/1000000
    } else if(NR == 2){
        print "Average overlap length (Kbp):"
        print $NF/1000
    } else if(NR == 3){
        print "Average seeds per overlap:"
        print $NF
		print ""
    }
}'; done

echo;
echo 'Timing and memory usage results:'
for i in `echo *.time`; do echo $i; 
	awk '{
		if(NR == 2){
			time = $NF
		}else if(NR == 3){
			time += $NF
			printf("CPU Time: %.2f\n", time)
		} else if(NR == 10){
			printf("Memory (GB): %.2f\n", $NF/1000000)
			print ""
		}
	}' $i; done

