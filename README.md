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

* [%GC content analysis](GCcontent): This script estimates the percentage of GC content for each individual in the dataset, using fasta files (obtained from stacks) imported in R. 

* [Isolation-by-distance analysis](IBD): It performs the *ad-hoc* species delimitation test of isolation-by-distance within *versus* between sister-taxa.

* [Morphological analyses](morphology): This folder includes several scripts for *Eliurus* morphological data analysis.
   * Discriminant Analysis of Principal Components (DAPC), used for maximising differences in morphology between *Eliurus* species and identifying the morphological variable that best discriminate the five *Eliurus* species included in the dataset.
   * Phylogenetic Generalized Least Squares (PGLS) analysis to measure correlations between morphological variables and 20 bioclimatic variables, while accounting for phylogenetic relatedness.

 
* [mitocondrial DNA analyses](mtDNA_analyses): This folder includes scripts for reconstructing the *Eliurus* phylogenetic tree using mitochondrial cytb sequences.
   * Bayesian phylogenetic inference carried out on MRBAYES ([MRBAYES_mtDNA](mtDNA_analsyses/MRBAYES_mtDNA));
   * Maximum-likelihhod phylogenetic inference carried out on RAXML ([RAXML_mtDNA](mtDNA_analsyses/RAXML_mtDNA));
   * Calculation of mitochondrial *cytb* genetic distances ([mtDNA_genetic_distances](mtDNA_analsyses/mtDNA_genetic_distances));

* [Comparison mtDNA and RAD-seq genetic data](mtDNAvsRAD): This folder includes scripts for:
   * calculating nuclear (RAD-seq) genomic distances between individuals;
   * comparing mitochondrial *cytb* and nuclear RAD-seq genetic distances;

* [RAD-seq phylogenomic analysis - RAXML](RAXML): This folder includes scripts for:
   * inferring *Eliurus* phylogenetic relationships from concatenated nuclear RAD-seq genomic data ([RAXML concatenated](RAXML/step1.1.raxml_HPC.sh));
   * inferring *Eliurus* phylogenetic relationships from partitioned nuclear RAD-seq genomic data ([RAXML partitioned](RAXML/step1.2.raxml_HPC_partitioned.sh));
   * plotting the inferred phylogenetic trees ([plotting RAXML trees](RAXML/Plot_raxml_RADseq_tree.R));

* [Genotype Likelihood analyses in ANGSD](ANGSD)
