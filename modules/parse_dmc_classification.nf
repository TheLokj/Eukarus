process PARSE_DMC_CLASSIFICATION {
  label 'process_single'
  publishDir "${outdir}/DeepMicroClass", mode: 'copy', saveAs:{'dmc.hit.tsv'}
  container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                'https://depot.galaxyproject.org/singularity/biopython:1.75':'quay.io/biocontainers/biopython:1.75' }"
                
  input:
  path predictionsPath
  val outdir

  output:
  path "output.parse_dmc_classification"
  
  script:
  """
  python $projectDir/bin/parse_dmc_classification.py $predictionsPath
  """
}
