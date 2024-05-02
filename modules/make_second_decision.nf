process MAKE_SECOND_DECISION {
    label 'light'

    input:
    tuple val(id), val(length), val(dmcPrediction), val(tiaraPrediction), val(firstStageDecision), val(catPrediction)

    output:
    stdout

    script:
    if (firstStageDecision == "RequiringCATvalidation" && catPrediction == "Eukaryota (1.00)") 
        """
        echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\t$firstStageDecision\t$catPrediction\tEukaryote'
        """
    else if (firstStageDecision == "ClassifiedAsEukaryote") 
        """
        echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\t$firstStageDecision\t-\tEukaryote'
        """
    else
        """
        echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\t$firstStageDecision\t-\tNotEukaryote'
        """
}