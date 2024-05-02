# -*- coding: utf-8 -*-
import sys

if " " in sys.argv[1] :
  seqName = sys.argv[1].split(" ")[0]
else :
  seqName = sys.argv[1]

if float(sys.argv[2]) != 0 and float(sys.argv[3]) != 0 and float(sys.argv[4]) != 0 and float(sys.argv[5]) != 0 and float(sys.argv[6]) != 0 : 
  print(f'{seqName}\t{["Eukaryote", "EukaryoteVirus", "Plasmid", "Prokaryote", "ProkaryoteVirus"][[float(sys.argv[2]), float(sys.argv[3]), float(sys.argv[4]), float(sys.argv[5]), float(sys.argv[6])].index(max(float(sys.argv[2]), float(sys.argv[3]), float(sys.argv[4]), float(sys.argv[5]), float(sys.argv[6])))]}')
else :
  print(f'{seqName}\tUnknown')