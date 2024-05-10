process MAKE_FIRST_DECISION {
  label 'light'

  input:
  tuple val(id), val(length), val(dmcPrediction), val(tiaraPrediction)

  output:
  path "output.make_first_decision" 
  
  script:
  dmc_prok = ["Prokaryote", "Plasmid"]
  dmc_virus = ["EukaryoteVirus", "ProkaryoteVirus"]
  tiara_prok = ["prokarya", "archaea", "bacteria"]
  // Cases where DeepMicroClass and Tiara have the same prediction
    // Classified as eukaryote
  if (dmcPrediction == "Eukaryote" && tiaraPrediction == "eukarya") 
    "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\tClassifiedAsEukaryote' > output.make_first_decision"
    // Classified as prokaryote
  else if (dmcPrediction in dmc_prok && tiaraPrediction in tiara_prok)
    "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\tClassifiedAsProkaryote' > output.make_first_decision"

  // Cases where DeepMicroClass and Tiara have a different  prediction
    // Cases where Tiara classify as an eukaryote but DeepMicroClass don't (prok or virus)
  else if (dmcPrediction in dmc_prok && tiaraPrediction == "eukarya") 
    "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\tClassifiedAsEukaryote' > output.make_first_decision"
    // Cases where DeepMicroClass classify as a eukaryote but Tiara don't (prok, organella or unknown)
  else if (dmcPrediction == "Eukaryote" && tiaraPrediction != "eukarya") 
    "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\trequiringCATvalidation' > output.make_first_decision"
  
  // Virus special cases - Tiara is not able to detect viruses
  else if (dmcPrediction == "EukaryoteVirus" && tiaraPrediction == "eukarya") 
    "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\trequiringCATvalidation' > output.make_first_decision"
  else if (dmcPrediction == "ProkaryoteVirus" && tiaraPrediction == "eukarya") 
    "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\trequiringCATvalidation' > output.make_first_decision"

  // Other cases
  else 
    "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\tClassifiedAsUnknown' > output.make_first_decision"
}