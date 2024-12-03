#!/bin/bash

# If any command-line argument is provided, such as "test", this will run only the 20-sample analysis. 

source ./common.sh

sample="fungi_"
if [[ -n "$1" ]];
  then sample="sample_20_"
fi

prefix="$datafolder/$sample"

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
combined_hold="$(qsub_id "process_xfasta.qsub ${prefix}its.xfasta ${prefix}its_seq.fasta ${prefix}its_str.fasta")"

# run clustal omega on sequence
seq_hold="$(qsub_id "its_clustalo.qsub ${prefix}its_seq.fasta ${prefix}seq_dist_matrix.mat ${prefix}its_msa.sto" $combined_hold)"

# run vienna rna on structure
# str_hold="$(qsub_id "????.qsub ${prefix}its_str.fasta ${prefix}str_dist_matrix.mat ????" $combined_hold)"

# run distatis on distance matrices
# combined_hold="$(qsub_id "????.qsub ${prefix}seq_dist_matrix.mat ${prefix}str_dist_matrix.mat ????" $seq_hold,$str_hold)"

# run upgma on combined matrix
# combined_hold="$(qsub_id "????.qsub ????" $combined_hold)"

# run evaluation on output tree
# combined_hold="$(qsub_id "????.qsub ????" $combined_hold)"

# print submitted jobs
qstat -u $(whoami)