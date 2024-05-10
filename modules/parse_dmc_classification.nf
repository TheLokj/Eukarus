process PARSE_DMC_CLASSIFICATION {
  label 'light'
  container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                'https://depot.galaxyproject.org/singularity/biopython:1.75':'quay.io/biocontainers/biopython:1.75' }"


  input:
  tuple (val(seqName), val(eukScore), val(eukVirScore), val(plaScore), val(proScore), val(proVirScore))
  val outdir

  output:
  path "output.parse_dmc_classification"
  
  script:
  """
  python $projectDir/bin/parse_dmc_classification.py $seqName $eukScore $eukVirScore $plaScore $proScore $proVirScore > output.parse_dmc_classification
  """
}
