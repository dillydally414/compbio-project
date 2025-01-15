#!/bin/bash -l

# Specify a project to run under
#$ -P bi720

# Give this job a name
#$ -N UPGMA_from_FASTA

# Join standard output and error to a single file
#$ -j y

module load clustalomega/1.2.1
module load python3/3.12.4
module load R/4.4.0
module load fasttree

#generate input files (comment out after first run
#Rscript JGI_vs_ITS2DB.R

#run clustal omega to create a distance matrix.
clustalo --force -i ../ITS2DB_species_in_JGI_NoDups_Longest.fasta --full \
	--distmat-out=matrix_test.mat -o MSA_test.fasta

#convert to file format usable in r
python mat_to_csv.py -m matrix_test.mat \
	-a ../ITS2DB_species_in_JGI_NoDups_Longest.fasta -o reformat_test.csv

#generate tree using UPGMA in R
Rscript Run_UPGMA_On_Matrix.R

#generate tree using FastTree
FastTree -nt MSA_test.fasta > ITSDB_noDups_Longest_FastTree.nwk
