process SAVE_CONTIGS_PER_KINGDOM {
  label 'light'

  input:
  path contigsPath
  each ids

  output: 
  tuple val("${ids[-1]}"), path("output.save_contigs_per_kingdom")

  script:
  """
  seqkit grep -f $ids $contigsPath > output.save_contigs_per_kingdom
  """
  
}