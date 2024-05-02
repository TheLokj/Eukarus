process SAVE_METADATA {
    label 'light'
    publishDir "${outdir}", mode: 'copy'

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
    python3 $projectDir/bin/save_metadata.py $tiaraVersion $dmcVersion \$(grep "# CAT" $logCat | cut -d"v" -f2 | sed 's/.\$//') \$(grep "Prodigal V" $logCat | cut -d"V" -f2 | cut -d":" -f1) \$(grep "diamond version" $logCat | cut -d" " -f7 | sed 's/.\$//') $catDB $diamondDB $taxonomyDB \$(grep "\\/" $logTiara | cut -f3 | sed -n 1p) \$(grep "\\/" $logTiara | cut -f3 | sed -n 3p) \$(grep "1/3" $logDmc | cut -f6 -d" ")
    """
}