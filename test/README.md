# Replicating the results in the paper

## Prerequisites

We compare BLEND with Minimap2 (for finding overlapping reads and read mapping), MHAP (for finding overlapping reads), BLASR (for finding overlapping reads and read mapping), Winnowmap (for read mapping), and S-conLSH (for read mapping). We specify the versions we use for each tool in our submission in Supplementary Table S3.

We list the links to download and compile each tool for comparison below:

* [Minimap2 (v2.24)](https://github.com/lh3/minimap2/releases/tag/v2.24)
* [MHAP (v2.1.3 -- via conda)](https://anaconda.org/bioconda/mhap/2.1.3/download/noarch/mhap-2.1.3-hdfd78af_1.tar.bz2)
* [BLASR (v5.3.5 -- via conda)](https://anaconda.org/bioconda/blasr/5.3.5/download/linux-64/blasr-5.3.5-0.tar.bz2)
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

We suggest using conda to install these tools with their specified versions as almost all of them are included in the conda repository.

Please make sure that all of these tools are in your `PATH`

## Datasets

All the datasets (except the human genome dataset) can be downloaded via Zenodo. For the human genome dataset, we use its already available repositories to download. We provide the scripts to download all these files under [data directory](./data/). In order to download:

```bash
cd data

bash download-e.coli-pb-sequelii.sh #E. coli PacBio HiFi Dataset (100X)
bash download-d.ananassae-pb-sequelii.sh #D. ananassae PacBio HiFi Dataset (50X)
bash download-chm13-pb-sequelii-16X.sh #Human CHM13 PacBio HiFi Dataset (16X)
bash download-yeast-pb-pbsim.sh #Yeast PacBio CLR Simulated Dataset (200X)
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

### BLASR

Here we run BLASR to find overlapping reads for each dataset.

```bash
cd blasr
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

### BLASR

Here we run BLASR to perform read mapping for each dataset.

```bash
cd blasr
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

We also provide the scripts we use for evaluating the results under the [scripts](./scripts/) directory. Each script is also already linked in the relevant directories so that one could easily run the correct scripts to evaluate the results easily.

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

#Runs dnadiff and quast to generate all the results regarding the assembly and overlap statistics. It outputs the result at the end to the standard output.
bash evaluate-read_mapping.sh
bash summarize-evaluate-read_mapping.sh

#Time results (User time+System Time for time and Maximum resident set size (kbytes) for the peak memory):
for i in `echo *.time`; do echo $i; grep "User" $i; grep "System" $i; grep "Maximum" $i; done

cd ../../../
```

* Human CHM13 PacBio HiFi Dataset (16X)

```bash
cd comparisons/chm13-pb-sequelii-16X/read_mapping

#Runs dnadiff and quast to generate all the results regarding the assembly and overlap statistics. It outputs the result at the end to the standard output.
bash evaluate-read_mapping.sh
bash summarize-evaluate-read_mapping.sh

#Time results (User time+System Time for time and Maximum resident set size (kbytes) for the peak memory):
for i in `echo *.time`; do echo $i; grep "User" $i; grep "System" $i; grep "Maximum" $i; done

cd ../../../
```

* Yeast PacBio CLR Simulated Dataset (200X)

```bash
cd comparisons/yeast-pb-pbsim-200x/read_mapping

#Runs dnadiff and quast to generate all the results regarding the assembly and overlap statistics. It outputs the result at the end to the standard output.
bash evaluate-read_mapping.sh
bash summarize-evaluate-read_mapping.sh

#Time results (User time+System Time for time and Maximum resident set size (kbytes) for the peak memory):
for i in `echo *.time`; do echo $i; grep "User" $i; grep "System" $i; grep "Maximum" $i; done

cd ../../../
```

* Yeast Illumina Dataset (80X)

```bash
cd comparisons/yeast-illumina/read_mapping

#Runs dnadiff and quast to generate all the results regarding the assembly and overlap statistics. It outputs the result at the end to the standard output.
bash evaluate-read_mapping.sh
bash summarize-evaluate-read_mapping.sh

#Time results (User time+System Time for time and Maximum resident set size (kbytes) for the peak memory):
for i in `echo *.time`; do echo $i; grep "User" $i; grep "System" $i; grep "Maximum" $i; done

cd ../../../
```

## Figures

We also provide the source we use to generate the figures we report in our submission as well as the original PDFs we use in our paper. The source and the PDFs can be downloaded using the Zenodo link:

```bash
wget https://zenodo.org/record/5782892/files/blend_figures.tar.gz
```
