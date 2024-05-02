process MAKE_FIRST_DECISION {
  label 'light'

  input:
  tuple val(id), val(length), val(dmcPrediction), val(tiaraPrediction)

  output:
  path "output.make_first_decision" 
  
  script:
  // Cases where DeepMicroClass and Tiara have the same prediction
    // Classified as eukaryote
  if (dmcPrediction == "Eukaryote" && tiaraPrediction == "eukarya") 
    "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\tClassifiedAsEukaryote' > output.make_first_decision"
    // Classified as prokaryote
  else if (dmcPrediction == "Prokaryote" && tiaraPrediction == "bacteria") 
    "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\tClassifiedAsProkaryote' > output.make_first_decision"
  else if (dmcPrediction == "Prokaryote" && tiaraPrediction == "prokarya")
    "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\tClassifiedAsProkaryote' > output.make_first_decision"
  else if (dmcPrediction == "Prokaryote" && tiaraPrediction == "archea") 
    "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\tClassifiedAsProkaryote' > output.make_first_decision"
  else if (dmcPrediction == "Plasmid" && tiaraPrediction == "bacteria") 
    "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\tClassifiedAsProkaryote' > output.make_first_decision"
  else if (dmcPrediction == "Plasmid" && tiaraPrediction == "prokarya")
    "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\tClassifiedAsProkaryote' > output.make_first_decision"
  else if (dmcPrediction == "Plasmid" && tiaraPrediction == "archea") 
    "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\tClassifiedAsProkaryote' > output.make_first_decision"
  
  // Cases where Tiara classify as an eukaryote but DeepMicroClass don't
  else if (dmcPrediction != "Eukaryote" && tiaraPrediction == "eukarya") 
    "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\tClassifiedAsEukaryote' > output.make_first_decision"

  // Cases where DeepMicroClass classify as a prokaryote but Tiara don't
  else if (dmcPrediction == "Eukaryote" && tiaraPrediction == "archea") 
    "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\tRequiringCATvalidation' > output.make_first_decision"
  else if (dmcPrediction == "Eukaryote" && tiaraPrediction == "bacteria") 
    "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\tRequiringCATvalidation' > output.make_first_decision"
  else if (dmcPrediction == "Eukaryote" && tiaraPrediction == "prokarya")
    "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\tRequiringCATvalidation' > output.make_first_decision"

  // Other cases
  else if (tiaraPrediction == "unknown") 
    "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\tRequiringCATvalidation' > output.make_first_decision"
  else
    "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\tRequiringCATvalidation' > output.make_first_decision"
}