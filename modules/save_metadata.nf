process SAVE_METADATA {
    label 'light'
    publishDir "${outdir}", mode: 'copy'
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                'https://depot.galaxyproject.org/singularity/biopython:1.75':'quay.io/biocontainers/biopython:1.75' }"

    input:
    val outdir
    val tiaraVersion
    val logTiara
    val dmcVersion
    val logDmc
    val logCat
    val catDB
    val diamondDB
    val taxonomyDB

    output:
    path "metadata.json"

    script:
    """
    python $projectDir/bin/save_metadata.py -tv $tiaraVersion -dmcv $dmcVersion -lt $logTiara -ldmc $logDmc -lc $logCat -cdb $catDB -ddb $diamondDB -tdb $taxonomyDB
    """
}