# -*- coding: utf-8 -*-
import sys

<<<<<<< HEAD
seqName = sys.argv[1].split(" ", 1)[0]

dmcValues = [float(arg) for arg in sys.argv[2:7]]
=======
seq_name = sys.argv[1].split(" ", 1)[0]
>>>>>>> 35d0596f439eed6614ccba736ec8d771c593c40b

if 0 not in dmcValues:
  maxIndex = dmcValues.index(max(dmcValues))
  labels = ["Eukaryote", "EukaryoteVirus", "Plasmid", "Prokaryote", "ProkaryoteVirus"]
  print(f'{seqName}\t{labels[maxIndex]}'
else :
  print(f'{seqName}\tUnknown')