# Comp Bio Project Aim 3 (Secondary Structure)

Todos:
- [ ] Use ViennaRNA to calculate RNA structure distance and output matrix
- [X] Use ClustalOmega to calculate RNA sequence distance and output matrix (not MSA)
- [ ] Combine matrices with weights (Distatis package)
- [ ] Build a tree from UPGMA
- [ ] Compare output tree to JGI tree (confer with group 1)

## Scripts

### `common.sh`
Utils script containing functionality reused by multiple scripts.
### `run_all.sh`
Submits the following qsub commands in topological order, with respective job id holds.
### `process_xfasta.qsub`
Takes the input xfasta file from ITS2 database and splits it into 2 fasta files, one with sequence data and one with structure data. Also removes duplicate sequences within the same genus.
### `its_clustalo.qsub`
Performs multiple sequence alignment on a fasta file using Clustal Omega.
