# BLEND: A Fast, Memory-Efficient, and Accurate Mechanism to Find Fuzzy Seed Matches in Genome Analysis

BLEND is a mechanism that can generate the same hash value for highly similar seeds to find fuzzy (approximate) seed matches between sequences with a single lookup from their hash values. By replacing the hash functions with BLEND, any seeding technique can integrate BLEND to enable the fuzzy seed matching mechanism.

By efficiently finding fuzzy seed matches with a single lookup, BLEND can significantly improve the performance and accuracy while reducing the memory footprint of two important applications: 1) read overlapping and 2) read mapping. Apart from these two applications, we envision that any application that uses seeds can exploit BLEND. Latest version of BLEND is described in [bioRxiv](https://doi.org/10.1101/2022.11.23.517691).

**We strongly recommend using BLEND for overlapping and mapping long and highly accurate reads (e.g., PacBio HiFi). We demonstrate in our manuscript that BLEND can run significantly faster, generate more accurate results, and use less memory space than minimap2 when using these long and accurate reads.**

For proof of work, we integrate the BLEND mechanism into [minimap2](https://github.com/lh3/minimap2/tree/7358a1ead1adfa89a2d3d0e72ffddd05732f9850). We show the benefits of BLEND when used with the minimizer and strobemer seeding techniques. We make the following changes in the original minimap2 implementation:

- We modify the original minimap2 implementation so that minimap2 can assign the same hash values for highly similar seeds it finds. To this end, we change the [sketch.c](https://github.com/lh3/minimap2/blob/7358a1ead1adfa89a2d3d0e72ffddd05732f9850/sketch.c) implementation of minimap2 to 1) generate the hash values of k-mers and 2) decide the minimizer k-mer based on the hash values BLEND generates.
- We implement a simple version of the strobemer seeds in minimap2 in three steps. First, we find minimizer k-mers using the [original hash function](https://github.com/lh3/minimap2/blob/7358a1ead1adfa89a2d3d0e72ffddd05732f9850/sketch.c#L28-L38) that minimap2 uses. Second, we link each `n` consecutive minimizer k-mer in a strobemer seeds. Third, we use the BLEND mechanism for generating the hash value of the strobemer seed based on the hash values of linked k-mers.
- We enable the minimap2 implementation to use seeds longer than 256 characters so that it can store longer seeds when using BLEND. The current implementation of minimap2 allocates 8 bits to store seed lengths up to 256 characters. We change this requirement in various places of the implementation (e.g., [line 112 in sketch.c](https://github.com/lh3/minimap2/blob/7358a1ead1adfa89a2d3d0e72ffddd05732f9850/sketch.c#L112) and [line 239 in index.c](https://github.com/lh3/minimap2/blob/7358a1ead1adfa89a2d3d0e72ffddd05732f9850/index.c#L239)) so that BLEND can use 14 bits to store seed lengths up to 16384 characters. We do this because BLEND merges many k-mers into a single seed, which can be much larger than a 256 character-long seed.

Our code that we have used for generating the results in our manuscript is available at Zenodo:
[![DOI](https://zenodo.org/badge/437586354.svg)](https://zenodo.org/badge/latestdoi/437586354)

# Installation

BLEND can be installed from its source code, Docker, or conda.

## [Source Code](https://github.com/CMU-SAFARI/BLEND)

* Download the code from its GitHub repository:

```bash
git clone https://github.com/CMU-SAFARI/BLEND.git blend
```

Compilation process is similar to minimap2's compilation as also explained in more detail [here](https://github.com/lh3/minimap2/tree/7358a1ead1adfa89a2d3d0e72ffddd05732f9850#installation).

* Compile (Make sure you have a C compiler and GNU make):

```bash
cd blend && make
```

If the compilation is successful, the binary will be in `bin/blend`.

## [Conda](https://anaconda.org/bioconda/blend-bio)

* Install BLEND from the bioconda channel

```bash
conda install -c bioconda blend-bio
```

## [Docker](https://hub.docker.com/r/firtinac/blend)

**Important** Your docker version should be at least 20.10.12. For the older versions, unexpected behaviors may occur.

* Build and running from the local Dockerfile:

```bash
#Build
docker build --rm -f "Dockerfile" -t blend "."

#Note: If your network connection is behind a proxy, you can define the following variables to set the proxy and build
# docker build --build-arg http_proxy="YOUR_HTTP_PROXY" --build-arg https_proxy="YOUR_HTTPS_PROXY" --no-cache --rm -f "Dockerfile" -t blend "."

#Example run
docker run -v $PWD/e.coli-pb-sequelii/:/input -v $PWD/output/:/output blend -x ava-hifi -o /output/output.paf /input/Ecoli.PB.HiFi.100X.fasta /input/Ecoli.PB.HiFi.100X.fasta

#You can also work from the docker image after executing the following (interactive usage):
docker run --rm -it --entrypoint /bin/bash blend
```

* Build from DockerHub:

```bash
#Build
docker pull firtinac/blend

#Example run
docker run -v $PWD/e.coli-pb-sequelii/:/input -v $PWD/output/:/output firtinac/blend -x ava-hifi -o /output/output.paf /input/Ecoli.PB.HiFi.100X.fasta /input/Ecoli.PB.HiFi.100X.fasta

#You can also work from the docker image after executing the following (interactive usage):
docker run --rm -it --entrypoint /bin/bash firtinac/blend
```

# Usage

You can print the help message to learn how to use `blend`:

```bash
blend -h
```

Below we show how to use blend for 1) finding overlapping reads and 2) read mapping when using the default preset parameters for each use application and genome.

BLEND provides the preset parameters depending on:

* The application: 1) Finding overlapping reads and 2) read mapping.
* Sequencing Technology: 1) Accurate long reads (e.g., PacBio HiFi reads), 2) erroneous long reads (e.g., PacBio CLR reads), and 2) short reads (i.e., Illumina paired-end reads). 

## Finding Overlapping Reads

Assume that you would like to perform `all-vs-all` overlapping between all pairs of HiFi reads from a human genome located in file `reads.fastq`. To find overlapping reads and store them in the [PAF](https://github.com/lh3/miniasm/blob/master/PAF.md) file `output.paf`:

```bash
blend -x ava-hifi reads.fastq reads.fastq > output.paf
```

## Read Mapping

Assume that you would like to map PacBio CLR reads in file `reads.fastq` to a reference genome in file `ref.fasta`. To generate the read mapping with the CIGAR output in the [SAM](https://samtools.github.io/hts-specs/SAMv1.pdf) file `output.sam`:

```bash
blend -ax map-pb ref.fasta reads.fastq > output.sam
```

## Getting Help

Since we integrate the BLEND mechanism into minimap2, most portion of the parameters are the same as explained in the [man page of minimap2](https://github.com/lh3/minimap2/blob/7358a1ead1adfa89a2d3d0e72ffddd05732f9850/minimap2.1) or as explained in the public page of [minimap2.1](https://lh3.github.io/minimap2/minimap2.html), which is subject to change as the new versions of minimap2 role out. We explain the parameters unique to the BLEND implementation below. 

The following option (i.e., `neighbors`) defines the number of k-mers that BLEND uses to generate a seed.

```bash
--neighbors INT Combines INT amount of k-mers to generate a seed. [10]
```

The following option (i.e., `fixed-bits`) defines the number of bits that BLEND uses when generating the hash values of seeds. By default, it uses 2 bits per character of a k-mer and, thus, 2*k bits for a hash value of a seed. This value can be decreased to increase the collision rate for assigning the same hash values for similar seeds, but also may start assigning the same hash value for slightly dissimilar seeds.
 
```bash
--fixed-bits INT BLEND uses INT number of bits when generating hash values of seeds rather than using 2*k number of bits. Useful when collision rate needs to be decreased than 2*k bits. Setting this option to 0 uses 2*k bits for hash values. [0]
```

The following option (i.e., `--strobemers`) tells BLEND that it should link consecutive `neighbors` many minimizer k-mers to generate a strobemer sequence as seed and use the hash values of these minimizer k-mers to generate a hash value for the strobemer sequence using the SimHash hashing strategy as suggested in the BLEND paper.

```bash
----strobemers link minimizers rather than the preceding k-mers of a single minimizer. (Number of minimizers to link is defined by --neighbors.)
```

The following option (i.e., `immediate`) tells BLEND that it should link consecutive `neighbors` many overlapping k-mers to generate a seed sequence and use the hash values of these k-mers to generate a hash value for the seed sequence using the SimHash hashing strategy as suggested in the BLEND paper.

```bash
--immediate use the hash values of consecutive k-mers to generate the hash values of seeds (defualt behavior).
```

BLEND provides the following preset options:

```bash
-x map-ont (-k7 -w10 --fixed-bits=32 --neighbors=11)
-x ava-ont (-k15 -w10 --fixed-bits=30 --neighbors=5 -e0 -m100 -r2k)
-x map-pb (-Hk7 -w10 --fixed-bits=32 --neighbors=15)
-x ava-pb (-Hk19 -Xw10 --fixed-bits=38 --neighbors=5 -e0 -m100)
-x map-hifi (--strobemers -k19 -w50 --fixed-bits=38 --neighbors=5 -U50,500 -g10k -A1 -B4 -O6,26 -E2,1 -s200)
-x ava-hifi (--strobemers -k25 -Xw200 --fixed-bits=50 --neighbors=7 -e0 -m100)
```

## Reproducing the results in the paper

We explain how to reproduce the results we show in the BLEND paper in the [test directory](./test/).

# <a name="cite"></a>Citing BLEND

If you use BLEND in your work, please cite:

```bibtex
@article{firtina_blend_2023,
  title = {{BLEND}: a fast, memory-efficient and accurate mechanism to find fuzzy seed matches in genome analysis},
  volume = {5},
  issn = {2631-9268},
  doi = {10.1093/nargab/lqad004},
  number = {1},
  journal = {NAR Genomics and Bioinformatics},
  author = {Firtina, Can and Park, Jisung and Alser, Mohammed and Kim, Jeremie S and Cali, Damla Senol and Shahroodi, Taha and Ghiasi, Nika Mansouri and Singh, Gagandeep and Kanellopoulos, Konstantinos and Alkan, Can and Mutlu, Onur},
  month = {mar},
  year = {2023},
  pages = {lqad004},
}
```
