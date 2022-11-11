#!/bin/bash

#minimap2 without generating the hash values using BLEND (seed length = 21 + 5 -1 = 25-mers)
samtools faidx ../../data/e.coli-pb-sequelii/ref.fa "ecoli.genome" | blend -k 5 --neighbors 21 -w 10 --fixed-bits=32 --dbg-hash -d ind - > minimap2.out 2> minimap2.err

#BLEND (--neighbors = 5) (seed length = 25-mers)
samtools faidx ../../data/e.coli-pb-sequelii/ref.fa "ecoli.genome" | blend -k 23 --neighbors 3 -w 10 --fixed-bits=32 --dbg-blend_hash -d ind - > blend_n3.out 2> blend_n3.err

# #BLEND (--neighbors = 5) (seed length = 25-mers)
# samtools faidx ../../data/e.coli-pb-sequelii/ref.fa "ecoli.genome" | blend -k 21 --neighbors 5 -w 10 --fixed-bits=32 --dbg-blend_hash -d ind - > blend_n5.out 2> blend_n5.err

# #BLEND (--neighbors = 7) (seed length = 25-mers)
# samtools faidx ../../data/e.coli-pb-sequelii/ref.fa "ecoli.genome" | blend -k 19 --neighbors 7 -w 10 --fixed-bits=32 --dbg-blend_hash -d ind - > blend_n7.out 2> blend_n7.err

#BLEND (--neighbors = 9) (seed length = 25-mers)
samtools faidx ../../data/e.coli-pb-sequelii/ref.fa "ecoli.genome" | blend -k 17 --neighbors 9 -w 10 --fixed-bits=32 --dbg-blend_hash -d ind - > blend_n9.out 2> blend_n9.err

# #BLEND (--neighbors = 11) (seed length = 25-mers)
# samtools faidx ../../data/e.coli-pb-sequelii/ref.fa "ecoli.genome" | blend -k 15 --neighbors 11 -w 10 --fixed-bits=32 --dbg-blend_hash -d ind - > blend_n11.out 2> blend_n11.err

# #BLEND (--neighbors = 13) (seed length = 25-mers)
# samtools faidx ../../data/e.coli-pb-sequelii/ref.fa "ecoli.genome" | blend -k 13 --neighbors 13 -w 10 --fixed-bits=32 --dbg-blend_hash -d ind - > blend_n13.out 2> blend_n13.err

#BLEND (--neighbors = 15) (seed length = 25-mers)
samtools faidx ../../data/e.coli-pb-sequelii/ref.fa "ecoli.genome" | blend -k 11 --neighbors 15 -w 10 --fixed-bits=32 --dbg-blend_hash -d ind - > blend_n15.out 2> blend_n15.err

# #BLEND (--neighbors = 17) (seed length = 25-mers)
# samtools faidx ../../data/e.coli-pb-sequelii/ref.fa "ecoli.genome" | blend -k 9 --neighbors 17 -w 10 --fixed-bits=32 --dbg-blend_hash -d ind - > blend_n17.out 2> blend_n17.err

# #BLEND (--neighbors = 19) (seed length = 25-mers)
# samtools faidx ../../data/e.coli-pb-sequelii/ref.fa "ecoli.genome" | blend -k 7 --neighbors 19 -w 10 --fixed-bits=32 --dbg-blend_hash -d ind - > blend_n19.out 2> blend_n19.err

#BLEND (--neighbors = 21) (seed length = 25-mers)
samtools faidx ../../data/e.coli-pb-sequelii/ref.fa "ecoli.genome" | blend -k 5 --neighbors 21 -w 10 --fixed-bits=32 --dbg-blend_hash -d ind - > blend_n21.out 2> blend_n21.err
