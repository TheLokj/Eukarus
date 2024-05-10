# -*- coding: utf-8 -*-
import sys

seqName = sys.argv[1].split(" ", 1)[0]

dmcValues = [float(arg) for arg in sys.argv[2:7]]

if 0 not in dmcValues:
  maxIndex = dmcValues.index(max(dmcValues))
  labels = ["Eukaryote", "EukaryoteVirus", "Plasmid", "Prokaryote", "ProkaryoteVirus"]
  print(f'{seqName}\t{labels[maxIndex]}'
else :
  print(f'{seqName}\tUnknown')