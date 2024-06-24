# -*- coding: utf-8 -*-
import sys, os

def main():
  ids = {
    "classifiedAsEukaryote" : [],
    "classifiedAsProkaryote" : [],
    "classifiedAsUnknown" : [],
    "requiringCATvalidation" : []
  }

  dmc_prok = ["Prokaryote", "Plasmid"]
  dmc_virus = ["EukaryoteVirus", "ProkaryoteVirus"]
  tiara_prok = ["prokarya", "archaea", "bacteria"]

  with open(sys.argv[1], "r") as firstResults, open("output.make_first_decision", "w") as output :
    lines = firstResults.readlines()
    for line in lines :
      parts = line.split("\t")
      contigId, length, dmcPrediction, tiaraPrediction = parts[0], parts[1], parts[2], parts[3].replace("\n", "")
    
      # Cases where DeepMicroClass and Tiara have the same prediction
      # Classified as eukaryote
      if dmcPrediction == "Eukaryote" and tiaraPrediction == "eukarya" :
        firstDecision = "classifiedAsEukaryote"

      #Classified as prokaryote
      elif dmcPrediction in dmc_prok and tiaraPrediction in tiara_prok:
        firstDecision = "classifiedAsProkaryote"

      # Cases where DeepMicroClass and Tiara have a different  prediction
      # Cases where Tiara classify as an eukaryote but DeepMicroClass doesn't (prok or virus)
      elif dmcPrediction in dmc_prok and tiaraPrediction == "eukarya" and int(length) >= 3000 :
        firstDecision = "classifiedAsEukaryote"
      elif dmcPrediction in dmc_prok and tiaraPrediction == "eukarya" and int(length) < 3000 :
        firstDecision = "requiringCATvalidation"

      # Cases where DeepMicroClass classify as a eukaryote but Tiara doesn't (prok, organella or unknown)
      elif dmcPrediction == "Eukaryote" and tiaraPrediction != "eukarya" :
        firstDecision = "requiringCATvalidation"
      
      # Virus special cases - Tiara is not able to detect viruses
      elif dmcPrediction == "EukaryoteVirus" and tiaraPrediction == "eukarya" : 
        firstDecision = "requiringCATvalidation"
      elif dmcPrediction == "ProkaryoteVirus" and tiaraPrediction == "eukarya" : 
        firstDecision = "requiringCATvalidation"

      # Other cases
      else :
        firstDecision = "classifiedAsUnknown"
    
      output.write(f"{contigId}\t{length}\t{tiaraPrediction}\t{dmcPrediction}\t{firstDecision}")
      ids[firstDecision].append(contigId)

      if line != lines[-1] :
        output.write("\n")

  for decision in ids.keys():
    if ids[decision] != [] :
      with open(f"{decision}.ids", "w") as decisionids :
        decisionids.write("\n".join(ids[decision]))

if __name__ == "__main__":
    main()