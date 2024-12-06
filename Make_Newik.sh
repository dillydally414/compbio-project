#!/bin/bash -l

module load muscle
module load fasttree
module load hmmer
module load R

hmmbuild --dna hmmer_build_test.hmmfile  ../sample_20_its_seq.fasta
hmmalign --dna -o hmmer_align.phylip --outformat phylip hmmer_build_test.hmmfile ../sample_20_its_seq.fasta
FastTree -nt hmmer_align.fasta > hmmer_tree.nwk
Rscript View_Tree_from_Nwk.R

