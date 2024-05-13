process MAKE_FIRST_DECISION {
  label 'light'
  container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                'https://depot.galaxyproject.org/singularity/biopython:1.75':'quay.io/biocontainers/biopython:1.75' }"

  input:
  path firstResults

  output:
  path "output.make_first_decision",  emit: firstDecisions
  path "*.ids", emit: ids
  
  script:
  """
  python $projectDir/bin/make_first_decision.py $firstResults
  """
}