from argparse import ArgumentParser
from pathlib import Path
import subprocess
import numpy as np

def mat_to_csv(matfile: Path, alnfile: Path, csvfile: Path):

  with open(matfile, "r") as mat, open(alnfile, "r") as aln, open(csvfile, "w") as csv:
    # read alignment and matrix files
    mat_text = mat.readlines()
    aln_text=aln.readlines()

    # separate out text from numeric matrix values
    vals_start = ["> f" in ln for ln in mat_text].index(True)+1
    fasta_headers = mat_text[:vals_start-1]
    colnames = [header.split(" ", 1)[1].replace("\n", "")  for header in fasta_headers]
    mat_strs = [val.replace("\n", "")[:-1].split(" ") for val in mat_text[vals_start:len(mat_text)-1]]
    mat_ints = [[int(val) for val in row] for row in mat_strs]
    matrix = np.full((len(mat_ints)+1, len(mat_ints)+1), np.nan)

    # set diagonal to 0
    for n in range(len(matrix)):
      matrix[n][n]=0

    # populate matrix with values
    for i in range(len(mat_ints)):
      for j in range(len(mat_ints[i])):
        matrix[i+1][j]=mat_ints[i][j]
    
    # convert lower triangle to symmetric matrix
    matrix = np.tril(matrix) + np.tril(matrix, -1).T

    # get length of each alignment and which pair was aligned
    pairs_aligned_txt = [pair.replace("\n", "").split(" ") for pair in aln_text[0::3]]
    pairs_aligned_int = [[int(val) for val in pair] for pair in pairs_aligned_txt]
    alignment_lengths = [len(alignment.replace("\n", "")) for alignment in aln_text[1::3]]

    # scale numbers in matrix by length of alignment
    for alignment_number in range(len(pairs_aligned_int)):
      pair = pairs_aligned_int[alignment_number]
      length = alignment_lengths[alignment_number]

      matrix[pair[0]-1,pair[1]-1]/=length
      matrix[pair[1]-1,pair[0]-1]/=length

    # export to csv
    matrix_out = [[str(element) for element in row] for row in matrix]
    csv.write("," + ",".join(colnames) + "\n")
    for i in range(len(matrix_out)):
      csv.write(f"{colnames[i]},{','.join(matrix_out[i])}\n")


if __name__ == "__main__":
  argparser = ArgumentParser()
  argparser.add_argument("-m", dest="matfile", type=Path)
  argparser.add_argument("-a", dest="alnfile", type=Path)
  argparser.add_argument("-o", dest="csvfile", type=Path)
  args = argparser.parse_args()

  mat_to_csv(args.matfile, args.alnfile, args.csvfile)