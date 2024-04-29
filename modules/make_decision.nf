process MAKE_DECISION {
  label 'light'

  input:
  tuple val(id), val(length), val(dmcPrediction), val(tiaraPrediction)

  output:
  path "output.make_decision"
  
  script:
  if (length.toInteger() <= 3000) 
    "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\t$dmcPrediction' > output.make_decision"
  else 
    if (dmcPrediction == "Eukaryote" && tiaraPrediction == "eukarya") 
      "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\t$dmcPrediction' > output.make_decision"
    else if (dmcPrediction == "Eukaryote" && tiaraPrediction == "unknown") 
      "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\t$dmcPrediction' > output.make_decision"
    else if (dmcPrediction == "Prokaryote" && tiaraPrediction == "bacteria") 
      "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\t$dmcPrediction' > output.make_decision"
    else if (dmcPrediction == "Prokaryote" && tiaraPrediction == "prokarya")
      "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\t$dmcPrediction' > output.make_decision"
    else if (dmcPrediction == "Prokaryote" && tiaraPrediction == "archea") 
      "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\t$dmcPrediction' > output.make_decision"
    else if (dmcPrediction == "Plasmid" && tiaraPrediction == "bacteria") 
      "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\tProkaryote' > output.make_decision"
    else if (dmcPrediction == "Plasmid" && tiaraPrediction == "prokarya")
      "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\tProkaryote' > output.make_decision"
    else if (dmcPrediction == "Plasmid" && tiaraPrediction == "archea") 
      "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\tProkaryote' > output.make_decision"
    else 
      "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\tUnknown' > output.make_decision"
}