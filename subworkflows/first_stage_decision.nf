include { MAKE_FIRST_DECISION } from "../modules/make_first_decision.nf"
include { SAVE_CONTIGS_PER_KINGDOM } from "../modules/save_contigs_per_kingdom.nf"

workflow FIRST_STAGE_DECISION {

    take: 
        path
        infos
        dmcPredictions
        tiaraPredictions
        outdir
        
    main:
    
        join_ch = infos
                    .join(dmcPredictions, remainder:true)
                    .join(tiaraPredictions, remainder:true)
                    .map(it -> "${it[0]}\t${it[1]}\t${it[2]}\t${it[3]}")
                    .collectFile(newLine:true)

        MAKE_FIRST_DECISION(join_ch)

        firstDecisions =  MAKE_FIRST_DECISION.out.firstDecisions
                            .splitText() {it.split()}

        ids = MAKE_FIRST_DECISION.out.ids
            .flatten()

        SAVE_CONTIGS_PER_KINGDOM(
            path, 
            ids
        )
        
        contigsRequiringCATvalidatiion = SAVE_CONTIGS_PER_KINGDOM.out
                                        .collectFile(storeDir:"${outdir}/fasta/firstStage") {it -> ["${it[0].replaceFirst(/.ids/, "")}.fa", it[1]]}
                                        .filter(~/.*requiringCATvalidation.fa/)
                                        .ifEmpty("None")
                                        .collect()

    emit:
        firstDecisions = firstDecisions
        contigsRequiringCATvalidatiion = contigsRequiringCATvalidatiion
}