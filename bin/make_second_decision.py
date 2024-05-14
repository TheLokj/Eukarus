# -*- coding: utf-8 -*-
import sys, os

ids = {"eukaryotes" : [], "other_kingdoms" : []}

with open(sys.argv[1], "r") as finalResults, open("output.make_second_decision", "w") as output :
  lines = finalResults.readlines()
  for line in lines :
    parts = line.split("\t")
    contigId, length, tiaraPrediction, dmcPrediction, firstStageDecision, catPrediction = parts[0], parts[1], parts[2], parts[3], parts[4], parts[5].replace("\n", "")
    
    if firstStageDecision == "requiringCATvalidation" and catPrediction == "Eukaryota (1.00)":
      finalDecision = "eukaryotes"
    elif firstStageDecision == "requiringCATvalidation" and catPrediction != "Eukaryota (1.00)":
     finalDecision = "other_kingdoms"
    elif firstStageDecision == "classifiedAsEukaryote" :
      finalDecision = "eukaryotes"
    else :
      finalDecision = "other_kingdoms"
      
    if catPrediction != "null" :
      output.write(f"{contigId}\t{length}\t{tiaraPrediction}\t{dmcPrediction}\t{firstStageDecision}\t{catPrediction}\t{finalDecision}")
    else :
      output.write(f"{contigId}\t{length}\t{tiaraPrediction}\t{dmcPrediction}\t{firstStageDecision}\t-\t{finalDecision}")

    ids[finalDecision].append(contigId)

    if line != lines[-1] :
      output.write("\n")

for decision in ids.keys():
  if ids[decision] != [] :
    with open(f"{decision}.ids", "w") as decisionids :
      decisionids.write("\n".join(ids[decision]))