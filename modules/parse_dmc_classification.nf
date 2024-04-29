process PARSE_DMC_CLASSIFICATION {
  label 'light'
  publishDir "${outdir}", mode: 'copy'

  input:
  tuple (val(seqName), val(eukScore), val(eukVirScore), val(plaScore), val(proScore), val(proVirScore))
  val outdir

  output:
  path "output.parse_dmc_classification"
  
  script:
  """
  python3 $projectDir/bin/parse_dmc_classification.py $seqName $eukScore $eukVirScore $plaScore $proScore $proVirScore > output.parse_dmc_classification
  """
}
