# Comp Bio Project Aim 3 (Secondary Structure)

## Scripts

### `common.sh`
Utils script containing functionality reused by multiple scripts.
### `run_all.sh`
Submits the following qsub commands in topological order, with respective job id holds.
### `process_xfasta.qsub`
Takes the input xfasta file from ITS2 database and splits it into 2 fasta files, one with sequence data and one with structure data. Also removes duplicate sequences within the same genus. Repeats on per-family level
### `its_clustalo.qsub`
Performs multiple sequence alignment on a fasta file using Clustal Omega.
### `its_rnadistance.qsub`
Uses the RNAdistance metric to generate a pairwise distance matrix for each secondary structure
### `distatis_weights_upgma`
Uses distatis to combine structure and sequence distance matrices, uses varying weights to combine matrices manually, then uses UPGMA to form Newick files and plots.
### `compare_tree_scores`
Graphs line plot to compare tree scores from different weights/methods for combining sequence and structure matrices.
