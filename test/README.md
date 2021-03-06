# Reproducing the results in the paper

## Prerequisites

We compare BLEND with Minimap2 (for finding overlapping reads and read mapping), MHAP (for finding overlapping reads), LRA (for read mapping), Winnowmap (for read mapping), and S-conLSH (for read mapping). We specify the versions we use for each tool in our submission in Supplementary Table S3.

We list the links to download and compile each tool for comparison below:

* [Minimap2 (v2.24)](https://github.com/lh3/minimap2/releases/tag/v2.24)
* [MHAP (v2.1.3 -- via conda)](https://anaconda.org/bioconda/mhap/2.1.3/download/noarch/mhap-2.1.3-hdfd78af_1.tar.bz2)
* [LRA (v1.3.2 -- via conda)](https://anaconda.org/bioconda/lra/1.3.2/download/linux-64/lra-1.3.2-ha140323_0.tar.bz2)
* [Winnowmap (v2.03 -- via conda)](https://anaconda.org/bioconda/winnowmap/2.03/download/linux-64/winnowmap-2.03-h2e03b76_0.tar.bz2)
* [S-conLSH (v2.0)](https://github.com/anganachakraborty/S-conLSH-2.0/tree/292fbe0405f10b3ab63fc3a86cba2807597b582e)

We use various tools to process and analyze the data we generate using each tool. The following tools must also be installed in your machine:

* [SAMtools](https://github.com/samtools/samtools/releases/download/1.14/samtools-1.14.tar.bz2)
* [miniasm](https://github.com/lh3/miniasm/tree/ce615d1d6b8678d38f2f9d27c9dccd944436ae75)
* [MUMmer v4.0.0rc1](https://github.com/mummer4/mummer/releases/tag/v4.0.0rc1)
* [Seqtk](https://github.com/lh3/seqtk)
* [BamUtil v1.0.15](https://github.com/statgen/bamUtil/releases/tag/v1.0.15)
* [bedtools v2.30.0](https://github.com/arq5x/bedtools2/releases/tag/v2.30.0)
* [mosdepth v0.3.2](https://github.com/brentp/mosdepth/releases/tag/v0.3.2)
* [QUAST v5.0.2](https://github.com/ablab/quast/releases/tag/quast_5.0.2)
* [PBSIM2 v2.0.1 -- via conda](https://anaconda.org/bioconda/pbsim2/2.0.1/download/linux-64/pbsim2-2.0.1-h9f5acd7_1.tar.bz2)

We suggest using conda to install these tools with their specified versions as almost all of them are included in the conda repository.

Please make sure that all of these tools are in your `PATH`

## Datasets

All the datasets (except the human genome dataset) can be downloaded via Zenodo. For the human genome dataset, we use its already available repositories to download. We provide the scripts to download all these files under [data directory](./data/). In order to download:

```bash
cd data

bash download-e.coli-pb-sequelii.sh #E. coli PacBio HiFi Dataset (100X)
bash download-d.ananassae-pb-sequelii.sh #D. ananassae PacBio HiFi Dataset (50X)
bash download-chm13-pb-sequelii-16X.sh #Human CHM13 PacBio HiFi Dataset (16X)
bash download-yeast-pb-pbsim2.sh #Yeast PacBio CLR Simulated Dataset (200X)
bash download-yeast-ont-pbsim2.sh #Yeast ONT Simulated Dataset (100X)
bash download-yeast-illumina.sh #Yeast Illumina Dataset (80X)

cd .. #going back to the test directory
```

Now that you have downloaded all the datasets, we can start running all the tools to collect the results.

## Finding Overlapping Reads

We run each tool for finding overlapping reads for each dataset. We use 32 threads for each tool but you can easily change this number in the scripts we use below.

### BLEND

Here we run BLEND to find overlapping reads for each dataset.

```bash
cd blend
bash overlap.sh
cd ..
```

### Minimap2

Here we run Minimap2 to find overlapping reads for each dataset.

```bash
cd minimap2
bash overlap.sh
cd ..
```

### MHAP

Here we run MHAP to find overlapping reads for each dataset.

```bash
cd mhap
bash overlap.sh
cd ..
```

## Read Mapping

We run each tool to perform read mapping for each dataset. We use 32 threads for each tool and 8 threads for sorting the BAM files but you can easily change this number in the scripts we use below.

### BLEND

Here we run BLEND to perform read mapping for each dataset.

```bash
cd blend
bash read_mapping.sh
cd ..
```

### Minimap2

Here we run Minimap2 to perform read mapping for each dataset.

```bash
cd minimap2
bash read_mapping.sh
cd ..
```

### Winnowmap

Here we run Winnowmap to perform read mapping for each dataset.

```bash
cd winnowmap
bash read_mapping.sh
cd ..
```

### LRA

Here we run LRA to perform read mapping for each dataset.

```bash
cd lra
bash read_mapping.sh
cd ..
```

### S-conLSH

Here we run S-conLSH to perform read mapping for each dataset.

```bash
cd conlsh
bash read_mapping.sh
cd ..
```

## Comparing the Results

We have already created symbolic links for all the files that each tool would generate under the [comparisons](./comparisons/) directory. The subdirectories under `comparisons` are created for each dataset.

We provide the scripts we use for evaluating the results under the [scripts](./scripts/) directory. Each script is also already linked in the relevant directories so that one could easily run the correct scripts to evaluate the results easily.

We also provide the python code, raw files, and scripts we use for generating the figures we show in the paper. You can change the raw files (i.e., csv files) based on the results newly generated (e.g., performance results). These files are all included in the [figures](./figures/) directory. We explain the subdirectories in more detail below.

Below we explain how to evaluate the results we generate for 1) finding overlapping reads and 2) read mapping.

### Finding Overlapping Reads

Each of the subdirectories under [comparisons](./comparisons/) include a directory called `overlap` where we include all the files to compare for a certain dataset. We explain how to evaluate the finding overlapping results for each dataset below.

* E. coli PacBio HiFi Dataset (100X)

```bash
cd comparisons/e.coli-pb-sequelii/overlap

#Runs dnadiff and quast to generate all the results regarding the assembly and overlap statistics. It outputs the result at the end to the standard output.
bash evaluate-overlaps.sh .

#Time results (User time+System Time for time and Maximum resident set size (kbytes) for the peak memory):
for i in `echo *.time`; do echo $i; grep "User" $i; grep "System" $i; grep "Maximum" $i; done

cd ../../../
```

* D. ananassae PacBio HiFi Dataset (50X)

```bash
cd comparisons/d.ananassae-pb-sequelii/overlap

#Runs dnadiff and quast to generate all the results regarding the assembly and overlap statistics. It outputs the result at the end to the standard output.
bash evaluate-overlaps-large_genome.sh  .

#Time results (User time+System Time for time and Maximum resident set size (kbytes) for the peak memory):
for i in `echo *.time`; do echo $i; grep "User" $i; grep "System" $i; grep "Maximum" $i; done

cd ../../../
```

* Human CHM13 PacBio HiFi Dataset (16X)

```bash
cd comparisons/chm13-pb-sequelii-16X/overlap

#Runs dnadiff and quast to generate all the results regarding the assembly and overlap statistics. It outputs the result at the end to the standard output.
bash evaluate-overlaps-large_genome.sh  .

#Time results (User time+System Time for time and Maximum resident set size (kbytes) for the peak memory):
for i in `echo *.time`; do echo $i; grep "User" $i; grep "System" $i; grep "Maximum" $i; done

cd ../../../
```

* Yeast PacBio CLR Simulated Dataset (200X)

```bash
cd comparisons/yeast-pb-pbsim-200x/overlap

#Runs dnadiff and quast to generate all the results regarding the assembly and overlap statistics. It outputs the result at the end to the standard output.
bash evaluate-overlaps-clr.sh .

#Time results (User time+System Time for time and Maximum resident set size (kbytes) for the peak memory):
for i in `echo *.time`; do echo $i; grep "User" $i; grep "System" $i; grep "Maximum" $i; done

cd ../../../
```

* Yeast ONT Simulated Dataset (100X)

```bash
cd comparisons/yeast-ont-pbsim-100x/overlap

#Runs dnadiff and quast to generate all the results regarding the assembly and overlap statistics. It outputs the result at the end to the standard output.
bash evaluate-overlaps-clr.sh .

#Time results (User time+System Time for time and Maximum resident set size (kbytes) for the peak memory):
for i in `echo *.time`; do echo $i; grep "User" $i; grep "System" $i; grep "Maximum" $i; done

cd ../../../
```

### Read Mapping

Each of the subdirectories under [comparisons](./comparisons/) include a directory called `read_mapping` where we include all the files to compare for a certain dataset. We explain how to evaluate the read mapping results for each dataset below.

* E. coli PacBio HiFi Dataset (100X)

```bash
cd comparisons/e.coli-pb-sequelii/read_mapping

#Runs BamUtil, bedtools, samtools, and mosdepth to generate the statistics based on the bam files
bash evaluate-read_mapping.sh
bash summarize-evaluate-read_mapping.sh

#Time results (User time+System Time for time and Maximum resident set size (kbytes) for the peak memory):
for i in `echo *.time`; do echo $i; grep "User" $i; grep "System" $i; grep "Maximum" $i; done

cd ../../../
```

* D. ananassae PacBio HiFi Dataset (50X)

```bash
cd comparisons/d.ananassae-pb-sequelii/read_mapping

#Runs BamUtil, bedtools, samtools, and mosdepth to generate the statistics based on the bam files
bash evaluate-read_mapping.sh
bash summarize-evaluate-read_mapping.sh

#Time results (User time+System Time for time and Maximum resident set size (kbytes) for the peak memory):
for i in `echo *.time`; do echo $i; grep "User" $i; grep "System" $i; grep "Maximum" $i; done

cd ../../../
```

* Human CHM13 PacBio HiFi Dataset (16X)

```bash
cd comparisons/chm13-pb-sequelii-16X/read_mapping

#Runs BamUtil, bedtools, samtools, and mosdepth to generate the statistics based on the bam files
bash evaluate-read_mapping.sh
bash summarize-evaluate-read_mapping.sh

#Time results (User time+System Time for time and Maximum resident set size (kbytes) for the peak memory):
for i in `echo *.time`; do echo $i; grep "User" $i; grep "System" $i; grep "Maximum" $i; done

cd ../../../
```

* Yeast PacBio CLR Simulated Dataset (200X)

```bash
cd comparisons/yeast-pb-pbsim-200x/read_mapping

#This script has multiple phases:
#1) #Runs BamUtil, bedtools, samtools, and mosdepth to generate the statistics based on the bam files
#2) Generates the data used for evaluating the read mapping accuracy. Precision results are calculated based on the
#number of reads that map to the chromosome in the 1) resulting BAM/SAM files and 2) in the ground truth
bash generate_results.sh

#Time results (User time+System Time for time and Maximum resident set size (kbytes) for the peak memory):
for i in `echo *.time`; do echo $i; grep "User" $i; grep "System" $i; grep "Maximum" $i; done

cd ../../../
```

* Yeast ONT Simulated Dataset (100X)

```bash
cd comparisons/yeast-ont-pbsim-100x/read_mapping

#This script has multiple phases:
#1) #Runs BamUtil, bedtools, samtools, and mosdepth to generate the statistics based on the bam files
#2) Generates the data used for evaluating the read mapping accuracy. Precision results are calculated based on the
#number of reads that map to the chromosome in the 1) resulting BAM/SAM files and 2) in the ground truth
bash generate_results.sh

#Time results (User time+System Time for time and Maximum resident set size (kbytes) for the peak memory):
for i in `echo *.time`; do echo $i; grep "User" $i; grep "System" $i; grep "Maximum" $i; done

cd ../../../
```

* Yeast Illumina Dataset (80X)

```bash
cd comparisons/yeast-illumina/read_mapping

#Runs BamUtil, bedtools, samtools, and mosdepth to generate the statistics based on the bam files
bash evaluate-read_mapping.sh
bash summarize-evaluate-read_mapping.sh

#Time results (User time+System Time for time and Maximum resident set size (kbytes) for the peak memory):
for i in `echo *.time`; do echo $i; grep "User" $i; grep "System" $i; grep "Maximum" $i; done

cd ../../../
```

## Figures

The [figures](./figures/) directory includes two subdirectories for the applications that BLEND is evaluated: 1) [finding overlapping reads](./figures/overlap/) and 2) [read mapping](./figures/read_mapping/). All last-level subdirectories include a script called `run.sh` to generate the figure in PDF format given that all the results are generated previously and the corresponding CSV files are filled accordingly. The CSV files we provide include the results we generate.

`Python 3` and the `numpy`, `pandas`, and `seaborn` packages are suggested to generate these figures.

### Generating the Performance and Peak Memory Usage Figures (Fig. 2 and Fig. 4)

```bash
#Finding overlapping reads (Figure 2)
cd figures/overlap/perf/
bash run.sh


cd ../../../

#Read mapping (Figure 4)
cd figures/read_mapping/perf/
bash run.sh

cd ../../../
```

### Generating the Overlap Statistics Figure (Figure 3)

```bash
#Overlap statistics (Figure 3)
cd figures/overlap/overlap_stats/
bash run.sh

cd ../../../
```

### Generating the GC Content Distribution Figure (Supp. Figure S1)

```bash
#GC content distribution of assemblies (Supplementary Figure S1)
cd figures/overlap/gc_dist/
bash run.sh

cd ../../../
```

### Generating the Read Mapping Accuracy Figure (Supp. Figure S2)

```bash
#Read mapping accuracy (Supplementary Figure S2)
cd figures/read_mapping/accuracy/
bash run.sh

cd ../../../
```

### Source of Figures
We also provide the source we use to generate the figures we report in our submission as well as the original PDFs we use in our paper. The source and the PDFs can be downloaded using the Zenodo link:

```bash
wget https://zenodo.org/record/5782892/files/blend_figures.tar.gz

