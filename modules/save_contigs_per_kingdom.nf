process SAVE_CONTIGS_PER_KINGDOM {
  label 'light'

  input:
  val contigsPath
  each result

  output: 
  tuple val("${result[4]}"), stdout

  script:

  """
  grep -Pzo '>${result[0]}\\s[^\\>]*' $contigsPath | sed '\$ s/.\$//'
  """

}