#!/bin/bash

prefix=$1

awk 'BEGIN{totov=0; totlen=0; totshared=0}{totov+=1; totlen += $11-$10; totshared += $4}END{print "Total number of overlaps: "totov; print "Avg Length of Overlaps: "totlen/totov; print "Avg Number of Shared Min-Mers (only for MHAP): " totshared/totov}' ${prefix}.out > ${prefix}_overlap.stats

