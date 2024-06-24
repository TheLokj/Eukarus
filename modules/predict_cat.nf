process PREDICT_CAT {
    label 'process_high'
    publishDir "${outdir}/CAT", mode: 'copy', pattern: "cat.out.log"
    container 'quay.io/microbiome-informatics/cat'

    input: 
    val contigsPath
    val catDB
    val diamondDB
    val taxonomyDB
    val outdir

    output:
    path "cat.out.*classification.txt", glob:true, emit:classification
    path "cat.out.log", emit:logPath

    script:
    if (contigsPath =~ /requiringCATvalidation.fa/) {
    """
    CAT contigs -c ${contigsPath[0]} -d $catDB --path_to_diamond $diamondDB -t $taxonomyDB --out_prefix cat.out -n \$(nproc) --index_chunks 1 --block_size 18
    """
    }
    else {
    """
    echo "" > cat.out.no_classification.txt
    echo "No contig requiring CAT validation" > cat.out.log
    """
    }
}