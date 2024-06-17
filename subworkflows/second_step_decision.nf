include { MAKE_SECOND_DECISION } from "../modules/make_second_decision.nf"
include { SAVE_CONTIGS_PER_KINGDOM } from "../modules/save_contigs_per_kingdom.nf"

workflow SECOND_STEP_DECISION {
    
    take: 
        path
        firstDecisions
        catPredictions
        outdir

    main:
    
        secondJoin_ch = firstDecisions
                        .flatten()
                        .collate(5)
                        .join(catPredictions, remainder:true)

        MAKE_SECOND_DECISION(secondJoin_ch)
        
        MAKE_SECOND_DECISION.out
        .map{it -> "ID\tLength\tTiara\tDeepMicroClass\tFirstStageDecision\tCAT\tSecondStageDecision\n$it"}
        .collectFile(storeDir:outdir, keepHeader:true) {it -> ["summary.tsv", it]}

        secondDecisions =  MAKE_SECOND_DECISION.out
                            .splitText() {it.replaceFirst(/\n/, "").split("\t")}

        SAVE_CONTIGS_PER_KINGDOM(
            path,
            6, 
            secondDecisions
        )
        
        SAVE_CONTIGS_PER_KINGDOM.out
        .collectFile(storeDir:"${outdir}/fasta") {it -> ["secondStep_contigs${it[0]}.fa", it[1]]}
        .collect()

    emit:
        secondDecisions = secondDecisions
        finishedSave = SAVE_CONTIGS_PER_KINGDOM.out

}