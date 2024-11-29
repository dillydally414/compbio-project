#!/bin/bash

# arg1 = qsub script
# arg2 = hold (if needed)
function qsub_id() {
  hold=""
  if [[ -n "$2" ]];
    then hold="-hold_jid $2"
  fi
  echo "$(qsub $hold $1 | cut -d ' ' -f 3)"
}

xfasta_hold="$(qsub_id process_xfasta.qsub)"
seq_hold="$(qsub_id '-o logs/its_msa_seq.log its_msa.qsub /projectnb/bi720/MMG/compbio/fungi_its_seq.fasta /projectnb/bi720/MMG/compbio/its_seq_msa.sto' $xfasta_hold)"
str_hold="$(qsub_id '-o logs/its_msa_str.log its_msa.qsub /projectnb/bi720/MMG/compbio/fungi_its_str.fasta /projectnb/bi720/MMG/compbio/its_str_msa.sto' $xfasta_hold)"
seq_hold="$(qsub_id '-o logs/its_hmmbuild_seq.log its_hmmbuild.qsub /projectnb/bi720/MMG/compbio/its_seq_msa.sto /projectnb/bi720/MMG/compbio/its_seq.hmm' $seq_hold)"
str_hold="$(qsub_id '-o logs/its_hmmbuild_str.log its_hmmbuild.qsub /projectnb/bi720/MMG/compbio/its_str_msa.sto /projectnb/bi720/MMG/compbio/its_str.hmm' $str_hold)"

qstat -u $(whoami)