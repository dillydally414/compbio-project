from argparse import ArgumentParser
from pathlib import Path


def process_xfasta(infile: Path, seqfile: Path, strfile: Path):
  seen_seq = set()
  curr_genus = ''
  with open(seqfile, "w") as seqfasta, open(strfile, "w") as strfasta, open(infile, "r") as xfasta:
    while True:
      id = xfasta.readline()
      if id == '':
        break
      genus = id.split()[1]
      if curr_genus != genus:
        curr_genus = genus
        seen_seq.clear()
      seq = xfasta.readline()
      str = xfasta.readline()
      if seq not in seen_seq:
        seen_seq.add(seq)
        seqfasta.write(id)
        strfasta.write(id)
        seqfasta.write(seq)
        strfasta.write(str)



if __name__ == '__main__':
  argparser = ArgumentParser()
  argparser.add_argument("-i", dest="infile", type=Path)
  argparser.add_argument("--seq", dest="seqfile", type=Path)
  argparser.add_argument("--str", dest="strfile", type=Path)
  args = argparser.parse_args()

  process_xfasta(args.infile, args.seqfile, args.strfile)