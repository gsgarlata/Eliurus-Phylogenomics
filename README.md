# Eliurus-Phylogenomics

This repository provides the scripts and data used to perform the analysis of the [Sgarlata et al., 2023](https://www.biorxiv.org/content/10.1101/2022.10.21.513246v1) study entitled: "The Genomic Diversity of the Eliurus genus in northern Madagascar with a Putative New Species".
If you use these scripts or workflow, please cite [Sgarlata et al., 2023](https://www.biorxiv.org/content/10.1101/2022.10.21.513246v1).

* [ADMIXTURE analysis](ADMIXTURE)


* [de novo RAD-seq data assembly in stacks](stacks): de-novo assembly of raw reads from RAD-sequencing using the stacks software. The scripts include:
   * parameters' exploration for catalog building, following [Paris et al., 2017](https://besjournals.onlinelibrary.wiley.com/doi/10.1111/2041-210X.12775) ([parameter_tuning](stacks/parameter_tuning));
   * catalog building ([catalog_final](stacks/catalog_final));
   * data assembly and genotype calling ([final](stacks/final));

* [Principal Component Analysis](pca): principal component analysis on RAD-seq genomic data for distinguishing the different *Eliurus* species included in the dataset.

* [Species delimitation analyses](BPP_and_gdi): This forlder contains scripts for species delimitation validation:
   * species delimitation analysis with guided tree (A01 method) performed in BPP;
   * calculation of the genealogical divergence index (gdi) based on parameters estimated in BPP (A00 method);

* [%GC content analysis](GCcontent)

* [Isolation-by-distance analysis](IBD)

* [Morphological analyses](morphology)

* [mitocondrial DNA analyses](mtDNA_analyses)

* [Comparison mtDNA and RAD-seq genetic data](mtDNAvsRAD)

* [RAD-seq phylogenomic analysis - RAXML](RAXML)

* [Genotype Likelihood analyses in ANGSD](ANGSD)
