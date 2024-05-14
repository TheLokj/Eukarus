process MAKE_SECOND_DECISION {
    label 'process_single'
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                'https://depot.galaxyproject.org/singularity/biopython:1.75':'quay.io/biocontainers/biopython:1.75' }"


    input:
    path finalResults

    output:
    path "output.make_second_decision", emit: finalDecisions
    path "*.ids", emit:ids

    script:
    """
    python $projectDir/bin/make_second_decision.py $finalResults                     
    """
}