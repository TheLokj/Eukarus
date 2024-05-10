process MAKE_SECOND_DECISION {
    label 'light'

    input:
    tuple val(id), val(length), val(dmcPrediction), val(tiaraPrediction), val(firstStageDecision), val(catPrediction)

    output:
    stdout

    script:
    if (firstStageDecision == "requiringCATvalidation" && catPrediction == "Eukaryota (1.00)") 
        """
        echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\t$firstStageDecision\t$catPrediction\teukaryotes'
        """
    else if (firstStageDecision == "requiringCATvalidation" && catPrediction != "Eukaryota (1.00)")  
        """
        echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\t$firstStageDecision\t$catPrediction\tother_kingdoms'
        """
    else if (firstStageDecision == "ClassifiedAsEukaryote") 
        """
        echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\t$firstStageDecision\t-\teukaryotes'
        """
    else
        """
        echo -e '$id\t$length\t$tiaraPrediction\t$dmcPrediction\t$firstStageDecision\t-\tother_kingdoms'
        """
}