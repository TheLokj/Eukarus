process ADD_NAMES_CAT {
    label 'light'
    publishDir "${outdir}/CAT", mode: 'copy'
    container = "/hps/nobackup/rdf/metagenomics/service-team/singularity-cache/quay.io_microbiome-informatics_cat:5.2.3.sif"

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