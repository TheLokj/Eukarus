process MAKE_DECISION {
  label 'light'

  input:
  tuple val(id), val(length), val(dmcPrediction), val(tiaraPrediction)

  output:
  stdout
  
  script:
  if (length.toInteger() <= 3000) 
    "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\t$dmcPrediction'"
  else 
    if (dmcPrediction == "Eukaryote" && tiaraPrediction == "eukarya") 
      "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\t$dmcPrediction'"
    else if (dmcPrediction == "Eukaryote" && tiaraPrediction == "unknown") 
      "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\t$dmcPrediction'"
    else if (dmcPrediction == "Prokaryote" && tiaraPrediction == "bacteria") 
      "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\t$dmcPrediction'"
    else if (dmcPrediction == "Prokaryote" && tiaraPrediction == "prokarya")
      "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\t$dmcPrediction'"
    else if (dmcPrediction == "Prokaryote" && tiaraPrediction == "archea") 
      "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\t$dmcPrediction'"
    else if (dmcPrediction == "Plasmid" && tiaraPrediction == "bacteria") 
      "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\tProkaryote'"
    else if (dmcPrediction == "Plasmid" && tiaraPrediction == "prokarya")
      "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\tProkaryote'"
    else if (dmcPrediction == "Plasmid" && tiaraPrediction == "archea") 
      "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\tProkaryote'"
    else 
      "echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\tUnknown'"
}