include { MAKE_SECOND_DECISION } from "../modules/make_second_decision.nf"
include { SAVE_CONTIGS_PER_KINGDOM } from "../modules/save_contigs_per_kingdom.nf"

workflow SECOND_STAGE_DECISION {
    
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
                        .map(it -> "${it[0]}\t${it[1]}\t${it[2]}\t${it[3]}\t${it[4]}\t${it[5]}")
                        .collectFile(newLine:true)

        MAKE_SECOND_DECISION(secondJoin_ch)
        
        MAKE_SECOND_DECISION.out.finalDecisions
        .splitText()
        .map{it -> "ID\tLength\tTiara\tDeepMicroClass\tFirstStageDecision\tCAT\tSecondStageDecision\n$it"}
        .collectFile(storeDir:outdir, keepHeader:true) {it -> ["summary.tsv", it]}

        finalDecisions =  MAKE_SECOND_DECISION.out.finalDecisions
                            .splitText() {it.split()}

        ids = MAKE_SECOND_DECISION.out.ids
            .flatten()

        SAVE_CONTIGS_PER_KINGDOM(
            path,
            ids
        )
        
        SAVE_CONTIGS_PER_KINGDOM.out
        .collectFile(storeDir:"${outdir}/fasta/") {it -> ["${it[0].replaceFirst(/.ids/, "")}.fa", it[1]]}
        .collect()

    emit:
        finishedSave = SAVE_CONTIGS_PER_KINGDOM.out

}