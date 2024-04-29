process SAVE_CONTIGS_PER_KINGDOM {
  label 'light'

  input:
  val contigsPath
  each result

  output: 
  tuple val("${result[4]}"), path("output.save_contigs_per_kingdom")

  script:

  """
  grep -Pzo '>${result[0]}\\s[^\\>]*' $contigsPath | sed '\$ s/.\$//' > output.save_contigs_per_kingdom
  """

}