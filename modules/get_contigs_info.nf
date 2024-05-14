// Get the contigs ID and length
process GET_CONTIGS_INFO {
  label 'process_single'

  input:
  val contigsPath

  output:
  path "output.get_contigs_info"

  script:
  """
  seqkit fx2tab --name --length -i $contigsPath > output.get_contigs_info
  """
}
