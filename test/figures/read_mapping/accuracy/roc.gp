set t po eps enh co so "Helvetica,26"

set style line 1 lt 1 pt 1 lc rgb "#e41a1c" lw 2;
set style line 2 lt 1 pt 2 lc rgb "#377eb8" lw 2;
set style line 3 lt 1 pt 3 lc rgb "#4daf4a" lw 2;
set style line 4 lt 1 pt 4 lc rgb "#984ea3" lw 2;
set style line 5 lt 1 pt 6 lc rgb "#ff7f00" lw 2;
set style line 6 lt 1 pt 8 lc rgb "#f781bf" lw 2;

set out "roc-color.eps"

set pointsize 2.0
set size 2.3,1.04
set multiplot layout 1,3

set label "(a)" at graph -0.245,1.06 font "Helvetica-bold,40"
set xlab "Error rate of mapped PacBio reads (CHM13)"
set ylab "Fraction of mapped reads" off +2
set ytics 0.02
set yran [0.86:1]

set size 0.95,1
set origin -0.15,0
set log x
set format x "10^{%L}"
set key top left
plot "<./eval2roc.pl -n10380693 ./chm13-ont-pbsim2/blend.bam.mapeval" u 2:3 t "BLEND" w lp ls 6, \
     "<./eval2roc.pl -n10380693 ./chm13-ont-pbsim2/minimap2.bam.mapeval" u 2:3 t "minimap2" w lp ls 2, \
     "<./eval2roc.pl -n10380693 ./chm13-ont-pbsim2/winnowmap.bam.mapeval" u 2:3 t "Winnowmap2" w lp ls 3

unset label

set origin 0.75,0
set size 0.8,1
set label "(b)" at graph -0.245,1.06 font "Helvetica-bold,40"
set xlab "Error rate of mapped PacBio reads (Yeast)"
set yran [0.91:1]
set ytics 0.01

set key bot right
plot "<./eval2roc.pl -n270849 ./yeast-pb-pbsim-200x/blend.bam.mapeval" u 2:3 t "BLEND" w lp ls 6, \
     "<./eval2roc.pl -n270849 ./yeast-pb-pbsim-200x/minimap2.bam.mapeval" u 2:3 t "minimap2" w lp ls 2, \
     "<./eval2roc.pl -n270849 ./yeast-pb-pbsim-200x/winnowmap.bam.mapeval" u 2:3 t "Winnowmap2" w lp ls 3

unset label

set origin 1.5,0
set size 0.8,1
set label "(c)" at graph -0.245,1.06 font "Helvetica-bold,40"
set xlab "Error rate of mapped ONT reads (Yeast)"
set yran [0.93:1]
set ytics 0.01

set key bot right
plot "<./eval2roc.pl -n135296 ./yeast-ont-pbsim-100x/blend.bam.mapeval" u 2:3 t "BLEND" w lp ls 6, \
     "<./eval2roc.pl -n135296 ./yeast-ont-pbsim-100x/minimap2.bam.mapeval" u 2:3 t "minimap2" w lp ls 2, \
     "<./eval2roc.pl -n135296 ./yeast-ont-pbsim-100x/winnowmap.bam.mapeval" u 2:3 t "Winnowmap2" w lp ls 3
