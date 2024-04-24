// Predict the kingdom with DeepMicroClass and save tool log
process PREDICT_DEEPMICROCLASS {
  label 'heavy'
  publishDir "${outdir}", mode: 'copy'
  container = "file:///${projectDir}/bin/deepmicroclass.sif"

  input:
  val contigsPath
  val contigsFile
  val outdir
  val modelPath
  val encoding
  val mode
  val device
  val singleLen
  
  output:
  path "${contigsFile}_pred_${encoding}_${mode}.tsv", emit: predictionsPath
  path "dmc.log", emit: logPath

  script:
  if (modelPath == "default" && mode == "single") 
    """
    echo "Params : -i $contigsPath -o ./ -e $encoding -md $mode -d $device -sl $singleLen" > dmc.log
    DeepMicroClass predict -i $contigsPath -o ./ -e $encoding -md $mode -d $device -sl $singleLen >> dmc.log
    """
  else if (modelPath != "default" && mode == "single") 
    """
    echo "Params : -i $contigsPath -o ./ -m $modelPath -e $encoding -md $mode -d $device -sl $singleLen" > dmc.log
    DeepMicroClass predict -i $contigsPath -o ./ -m $modelPath -e $encoding -md $mode -d $device -sl $singleLen >> dmc.log
    """
  else if (modelPath == "default" && mode != "single") 
    """
    echo "Params : -i $contigsPath -o ./ -e $encoding -md $mode -d $device" > dmc.log
    DeepMicroClass predict -i $contigsPath -o ./ -e $encoding -md $mode -d $device >> dmc.log
    """
  else if (modelPath != "default" && mode != "single") 
    """
    echo "Params : -i $contigsPath -o ./ -m $modelPath -e $encoding -md $mode -d $device" > dmc.log
    DeepMicroClass predict -i $contigsPath -o ./ -m $modelPath -e $encoding -md $mode -d $device >> dmc.log
    """
}