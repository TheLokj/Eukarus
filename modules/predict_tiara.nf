process PREDICT_TIARA {
  label 'medium'
  publishDir "${outdir}", mode: 'copy'
  container = "/hps/nobackup/rdf/metagenomics/service-team/users/louison/nextflow/project/bin/tiara.sif"

  input:
  val contigsPath
  val contigsFile
  val outdir
  val minLength
  
  output:
  path "tiara_predictions.txt", emit: predictionsPath
  path "log_tiara_predictions.txt", emit: logPath

  script:
  """
  tiara -i $contigsPath -o tiara_predictions.txt -m $minLength
  """
  
}