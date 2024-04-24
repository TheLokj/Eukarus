process PARSE_DMC_CLASSIFICATION {
  label 'light'
  publishDir "${outdir}", mode: 'copy'

  input:
  tuple (val(seqName), val(eukScore), val(eukVirScore), val(plaScore), val(proScore), val(proVirScore))
  val outdir

  output:
  stdout 
  
  script:
  """
  #!/usr/bin/python3.6
  if " " in "$seqName" :
    seqName = "$seqName".split(" ")[0]
  else :
    seqName = "$seqName"

  if float($eukScore) != 0 and float($eukVirScore) != 0 and float($plaScore) != 0 and float($proScore) != 0 and float($proVirScore) != 0 : 
    print(f'{seqName}\t{["Eukaryote", "EukaryoteVirus", "Plasmid", "Prokaryote", "ProkaryoteVirus"][[float($eukScore), float($eukVirScore), float($plaScore), float($proScore), float($proVirScore)].index(max(float($eukScore), float($eukVirScore), float($plaScore), float($proScore), float($proVirScore)))]}')
  else :
    print(f'{seqName}\tUnknown')
  """
}
