process PREDICT_TIARA {
  label 'heavy'
  publishDir "${outdir}/Tiara", mode: 'copy'

  input:
  val contigsPath
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