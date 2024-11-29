# Comp Bio Project Aim 3 (Secondary Structure)

Todos:
- [X] Generate HMM using HMMER
- [ ] Determine how to use HMMER to build trees.
  - Brief search suggests that we may not need HMMER since HMMER is mainly used to generate a multiple sequence alignment but we are using something else (ClustalOmega) to generate the multiple sequence alignment
- [ ] Determine how to combine sequence and structure information
  - Existing literature performs a joining operation over the distance matrices calculated during multiple sequence alignment

## Scripts

### `common.sh`
Utils script containing functionality reused by multiple scripts.
### `run_all.sh`
Runs the following qsub commands in sequential order, for both sequence and structure data.
### `process_xfasta.qsub`
Takes the input xfasta file from ITS2 database and splits it into 2 fasta files, one with sequence data and one with structure data. Also removes duplicate sequences within the same genus.
### `its_msa.qsub`
Performs multiple sequence alignment on a fasta file using Clustal Omega.
### `its_hmmbuild.qsub`
Builds an HMMER profile from a multiple sequence alignment.