#!/bin/bash

# Run this script with bash run_all.sh [test]
# If any command-line argument is provided, such as "test", this will run only the 20-sample analysis. 

source ./common.sh

# sets the default sample to “fungi_” if you run bash run_all.sh 
# if you provide any argument (ie bash run_all.sh test) it runs with “sample_20_”
sample="fungi_"
if [[ -n "$1" ]];
  then sample="sample_20_"
fi

prefix="$datafolder/$sample"

# This function submits a qsub script and extracts the job id from the resulting message. If passed a second argument,
# the second argument is used as a hold on this script (in other words, this script will not run until the job with the given id has finished).
# This allows us to submit all of our qsubs in one run without worrying about race conditions. 
# arg1 = qsub script
# arg2 = hold (if needed)
function qsub_id() {
  hold=""
  if [[ -n "$2" ]];
    then hold="-hold_jid $2"
  fi
  echo "$(qsub $hold $1 | cut -d ' ' -f 3)"
}

# split xfasta into sequence and structure
combined_hold="$(qsub_id "process_xfasta.qsub ${prefix}its.xfasta ${prefix}its_seq.fasta ${prefix}its_str.fasta $datafolder/taxonomy_db.csv")"

# run clustal omega on sequence
seq_hold="$(qsub_id "its_clustalo.qsub ${prefix}its_seq.fasta ${prefix}its_msa.sto ${prefix}seq_dist_matrix.mat ${prefix}seq_dist.csv" $combined_hold)"

# run vienna rna on structure
str_hold="$(qsub_id "its_rnadistance.qsub ${prefix}its_str.fasta ${prefix}str_alignment.txt ${prefix}str_dist_matrix.txt ${prefix}str_dist.csv" $combined_hold)"

# run distatis on distance matrices
# combined_hold="$(qsub_id "????.qsub ${prefix}seq_dist_matrix.mat ${prefix}str_dist_matrix.mat ????" $seq_hold,$str_hold)"

# run upgma on combined matrix
# combined_hold="$(qsub_id "????.qsub ????" $combined_hold)"

# run evaluation on output tree
# combined_hold="$(qsub_id "????.qsub ????" $combined_hold)"

# print submitted jobs
qstat -u $(whoami)