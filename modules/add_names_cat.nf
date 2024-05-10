process ADD_NAMES_CAT {
    label 'light'
    publishDir "${outdir}/CAT", mode: 'copy'
    container 'quay.io/microbiome-informatics/cat'

    input: 
    val contig2classification
    val taxonomyDB
    val outdir

    output:
    path {"cat.out.lineage"}

    script:
    if (contig2classification =~ /cat.out.contig2classification.txt/) {
    """
    CAT add_names -i $contig2classification -o "cat.out.lineage" -t $taxonomyDB
    """
    }
    else {
    """
    echo None > cat.out.lineage
    """
    }
}