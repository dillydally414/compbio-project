from argparse import ArgumentParser
from pathlib import Path
import subprocess

def mat_to_csv(matfile: Path, csvfile: Path, fastafile: Path = None):
  with open(matfile, "r") as mat, open(csvfile, "w") as csv:
    cols = int(mat.readline().strip())
    start = mat.tell()
    colnames = [mat.readline().split()[0] for _ in range(cols)]
    if fastafile is not None:
      colnames = [subprocess.run(f"cat {fastafile} | grep {accession} | cut -d ' ' -f 2-", capture_output=True, shell=True, text=True).stdout.strip() for accession in colnames]
    csv.write("," + ",".join(colnames) + "\n")
    mat.seek(start)
    for i in range(cols):
      csv.write(f"{colnames[i]},{",".join(mat.readline().split()[1:])}\n")


if __name__ == "__main__":
  argparser = ArgumentParser()
  argparser.add_argument("-i", dest="matfile", type=Path)
  argparser.add_argument("-o", dest="csvfile", type=Path)
  argparser.add_argument("--name-replacement", dest="fastafile", type=Path)
  args = argparser.parse_args()

  mat_to_csv(args.matfile, args.csvfile, args.fastafile)