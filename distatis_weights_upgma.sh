#!/bin/bash
#
# Run this file using 'qsub distatis_weights_upgma.sh path/to/input.fasta path/to/output_alignment.txt path/to/output_matrix_test.txt path/to/output_matrix.csv'

# All lines starting with "#$" are SGE qsub commands

# Specify a project to run under
#$ -P bi720

# Give this job a name
#$ -N distatis_weights_upgma

# Join standard output and error to a single file
#$ -j y

# Name the file where to redirect standard output and error
#$ -o /projectnb/bi720/MMG/2fungi2furious/hpenn13/compbio-project/logs/distatis_weights_upgma.log

# Send an email when the job finishes
#$ -m eas

# Request a large memory node, this will affect your queue time, but it's better to overestimate
# -l mem_per_core=8G

# Request more cores, this will affect your queue time, make sure your program supports multithreading, or it's a waste
# -pe omp 1

# Now we write the script that the compute node will work on.

source ./common.sh
prerun

# load modules
module load R/4.4.0

# do some work
datafolder="/projectnb/bi720/MMG/compbio"

sequence="$(default $1 ${datafolder}/sample_20_seq_dist.csv)"
structure="$(default $2 ${datafolder}/sample_20_str_dist.csv)"
sample="$(default $3 "sample_20_")"

run "Rscript --vanilla distatis_weights_upgma.R $sequence $structure $sample"

postrun