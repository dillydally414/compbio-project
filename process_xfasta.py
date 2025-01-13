from argparse import ArgumentParser
from pathlib import Path
import pandas as pd


def process_xfasta(infile: Path, seqfile: Path, strfile: Path, taxfile: Path):
  seen_seq = set()
  curr_genus = ''
  genus_to_family = {row['Genus'][3:]: row['Family'][3:] for _, row in pd.read_csv(taxfile).iterrows()}
  all_families = set(genus_to_family.values())
  family_seqs = {family: [] for family in genus_to_family.values()}
  family_strs = {family: [] for family in genus_to_family.values()}
  family_seqs['Unknown'] = []
  family_strs['Unknown'] = []
  family_data = seqfile.parent.joinpath("family_fastas")
  with open(seqfile, "w") as seqfasta, open(strfile, "w") as strfasta, open(infile, "r") as xfasta:
    while True:
      idpos = xfasta.tell()
      id = xfasta.readline()
      if id == '':
        break
      split = id.split()
      i = 1
      genus = split[i]
      while i < len(split) - 1 and genus not in genus_to_family and genus not in all_families:
        i += 1
        genus = split[i]
      family = genus_to_family[genus] if genus in genus_to_family else genus if genus in all_families else 'Unknown'
      if curr_genus != genus:
        curr_genus = genus
        seen_seq.clear()
      seqpos = xfasta.tell()
      seq = xfasta.readline()
      strpos = xfasta.tell()
      str = xfasta.readline()
      endpos = xfasta.tell()
      if seq not in seen_seq:
        seen_seq.add(seq)
        seqfasta.write(id)
        strfasta.write(id)
        seqfasta.write(seq)
        strfasta.write(str)
        family_seqs[family].append((idpos, strpos))
        family_strs[family].extend([(idpos, seqpos), (strpos, endpos)])
    for family in family_seqs.keys():
      seq_pos = family_seqs[family]
      if len(seq_pos) == 0:
        continue
      str_pos = family_strs[family]
      family_file_seq = family_data.joinpath(seqfile.name.replace('_seq', f'_family_{family}_seq'))
      family_file_str = family_data.joinpath(strfile.name.replace('_str', f'_family_{family}_str'))
      with open(family_file_seq, "w") as fam_seq, open(family_file_str, "w") as fam_str:
        for start, end in seq_pos:
          xfasta.seek(start)
          fam_seq.write(xfasta.read(end - start))
        for start, end in str_pos:
          xfasta.seek(start)
          fam_str.write(xfasta.read(end - start))



if __name__ == '__main__':
  argparser = ArgumentParser()
  argparser.add_argument("-i", dest="infile", type=Path)
  argparser.add_argument("--taxonomy", dest="taxfile", type=Path)
  argparser.add_argument("--seq", dest="seqfile", type=Path)
  argparser.add_argument("--str", dest="strfile", type=Path)
  args = argparser.parse_args()

  process_xfasta(args.infile, args.seqfile, args.strfile, args.taxfile)