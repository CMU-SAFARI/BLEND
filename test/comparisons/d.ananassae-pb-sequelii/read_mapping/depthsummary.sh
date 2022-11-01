#!/bin/bash

multiBamSummary bins --bamfiles blend.bam minimap2.bam --labels BLEND minimap2 -out readCounts.npz --outRawCounts readCounts.tab

