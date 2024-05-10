process SAVE_CONTIGS_PER_KINGDOM {
  label 'light'

  input:
  val contigsPath
  val index
  each result

  output: 
  tuple val("${result[index]}"), path("output.save_contigs_per_kingdom")

  script:

  """
  seqkit grep -p ${result[0]} $contigsPath > output.save_contigs_per_kingdom
  """
  
}