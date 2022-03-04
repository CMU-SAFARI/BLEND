# BLEND: A Fast, Memory-Efficient, and Accurate Mechanism to Find Fuzzy Seed Matches

BLEND is a mechanism that can efficiently find fuzzy seed matches between sequences to significantly improve the performance and accuracy while reducing the memory space usage of two important applications: 1) finding overlapping reads and 2) read mapping. Finding fuzzy seed matches enable BLEND to find both 1) exact-matching seeds and 2) highly similar seeds. We integrate the BLEND mechanism into [Minimap2](https://github.com/lh3/minimap2/tree/7358a1ead1adfa89a2d3d0e72ffddd05732f9850). We make the following changes in the original Minimap2 implementation:

- We enable the Minimap2 implementation so that it can find fuzzy seed matches using the BLEND mechanism as the original implementation can only find the exact-matching seeds between sequences. To this end, we change the [sketch.c](https://github.com/lh3/minimap2/blob/7358a1ead1adfa89a2d3d0e72ffddd05732f9850/sketch.c) implementation of Minimap2 so that 1) we can generate the seeds by concatanating each minimizer k-mer with its immediately preceding k-mers and 2) generate the hash values for seeds such that a pair of highly similar seeds can have the same hash value to find fuzzy seed matches with a single look-up.
- We enable the Minimap2 implementation to use seeds longer than 256 bases so that it can store longer seeds when using BLEND by combining the minimizer k-mer with *many* neighbor k-mers (e.g., hundreds), if necessary. The current implementation of Minimap2 allocates 8-bits to store seed lengths up to 256 characters. We change this requirement in various places of the implementation (e.g., [line 112 in sketch.c](https://github.com/lh3/minimap2/blob/7358a1ead1adfa89a2d3d0e72ffddd05732f9850/sketch.c#L112) and [line 239 in index.c](https://github.com/lh3/minimap2/blob/7358a1ead1adfa89a2d3d0e72ffddd05732f9850/index.c#L239)) so that BLEND can use 14 bits to store seed lengths up to 16384 characters. We do this because BLEND merges many k-mers into a single seed, which may be much larger than a 256 character-long sequence.

## Cloning the source code

* Download the code from its GitHub repository:

```bash
git clone https://github.com/CMU-SAFARI/BLEND.git blend
```

* Alternatively, if you would like to compile the SIMD-compatible version of BLEND, you can clone BLEND with its [simde](https://github.com/simd-everywhere/simde) submodule:

```bash
git clone --recurse-submodules https://github.com/CMU-SAFARI/BLEND.git blend
```

## Compiling from the source code

Compilation process is similar to Minimap2's compilation as also explained in more detail [here](https://github.com/lh3/minimap2/tree/7358a1ead1adfa89a2d3d0e72ffddd05732f9850#installation).

Before compiling BLEND:

* Make sure you have a C compiler and GNU make, 

To compile:

```bash
cd blend && make
```

If the compilation is successful, the binary called `blend` will be located under `bin`.

## Usage

You can print the help message to learn how to use `blend`:

```bash
blend -h
```

Below we show how to use blend for 1) finding overlapping reads and 2) read mapping when using the default preset parameters for each use application and genome.

BLEND provides the preset parameters depending on:

* The application: 1) Finding overlapping reads and 2) read mapping.
* Sequencing Technology: 1) Accurate long reads (e.g., PacBio HiFi reads), 2) erroneous long reads (e.g., PacBio CLR reads), and 2) short reads (i.e., Illumina paired-end reads).
* Genome: 1) Human, 2) eukaryotic, and 3) bacterial genomes. 

### Finding Overlapping Reads

Assume that you would like to perform `all-vs-all` overlapping between all pairs of HiFi reads from a human genome located in file `reads.fastq`. To find overlapping reads and store them in the [PAF](https://github.com/lh3/miniasm/blob/master/PAF.md) file `output.paf`:

```bash
blend -x ava-hifi --genome human reads.fastq reads.fastq > output.paf
```

### Read Mapping

Assume that you would like to map PacBio CLR reads in file `reads.fastq` to a reference genome in file `ref.fasta`. To generate the read mapping with the CIGAR output in the [SAM](https://samtools.github.io/hts-specs/SAMv1.pdf) file `output.sam`:

```bash
blend -ax map-pb ref.fasta reads.fastq > output.sam
```

## Getting Help

Since we integrate the BLEND mechanism into Minimap2, most portion of the parameters are the same as explained in the [man page of Minimap2](https://github.com/lh3/minimap2/blob/7358a1ead1adfa89a2d3d0e72ffddd05732f9850/minimap2.1) or as explained in the public page of [minimap2.1](https://lh3.github.io/minimap2/minimap2.html), which is subject to change as the new versions of Minamp2 role out. We explain the parameters unique to the BLEND implementation below. 

The following option (i.e., `neighbors`) defines the number of consecutive k-mers that BLEND uses to generate a seed. Thus, if the k-mer length is `k`, the seed length is `neighbors + k - 1`. Default value is 10.
```bash
--neighbors INT Combines INT amount of k-mers to generate a seed. [10]
```

The following option (i.e., `fixed-bits`) defines the number of bits that BLEND uses for a hash value of a seed. By default, it uses 2 bits per character of a k-mer and, thus, 2*k bits for a hash value of a seed. This value can be decreased to increase the collision rate for assigning the same hash values for similar seeds, but also may start assigning the same hash value for slightly dissimilar seeds. 
```bash
--fixed-bits INT BLEND uses INT number of bits when generating hash values of seeds rather than using 2*k number of bits. Useful when collision rate needs to be decreased than 2*k bits. Setting this option to 0 uses 2*k bits for hash values. [0].
```

BLEND also provides preset options. Some of these preset options also depend on the genome type as shown below:

```bash
-x map-ont (-k15 -w10 --fixed-bits=30 --neighbors=3)
-x ava-ont (-k15 -w20 --fixed-bits=30 --neighbors=3 -e0 -m100 -r2k)
-x map-pb (-Hk15 -w20 --fixed-bits=30 --neighbors=3)
-x ava-pb (-Hk19 -Xw20 --fixed-bits=32 --neighbors=3 -e0 -m100)
-x map-hifi --genome human (-k15 -w500 --fixed-bits=38 --neighbors=100 -U50,500 -g10k -A1 -B4 -O6,26 -E2,1 -s200)
-x map-hifi --genome eukaryote (-k15 -w500 --fixed-bits=30 --neighbors=5 -U50,500 -g10k -A1 -B4 -O6,26 -E2,1 -s200)
-x map-hifi --genome bacteria (-k15 -w500 --fixed-bits=30 --neighbors=3 -U50,500 -g10k -A1 -B4 -O6,26 -E2,1 -s200)
-x ava-hifi --genome human (-k15 -Xw500 --fixed-bits=38 --neighbors=10 -e0 -m100)
-x ava-hifi --genome eukaryote (-k15 -Xw500 --fixed-bits=30 --neighbors=10 -e0 -m100)
-x ava-hifi --genome bacteria (-k15 -Xw500 --fixed-bits=30 --neighbors=5 -e0 -m100)
```

## Reproducing the results in the paper

We explain how to reproduce the results we show in the BLEND paper in the [test directory](./test/).

## <a name="cite"></a>Citing BLEND

If you use BLEND in your work, please cite:

> Can Firtina, Jisung Park, Jeremie S. Kim, Mohammed Alser, Damla Senol Cali, Taha Shahroodi, 
> Nika Mansouri Ghiasi, Gagandeep Singh, Konstantinos Kanellopoulos, Can Alkan, and Onur Mutlu
> "BLEND: A Fast, Memory-Efficient, and Accurate Mechanism to Find Fuzzy Seed Matches"
> arXiv preprint **arXiv**:2112.08687 (2021). [DOI](https://doi.org/10.48550/arXiv.2112.08687)

