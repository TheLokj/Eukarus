include { MAKE_FIRST_DECISION } from "../modules/make_first_decision.nf"
include { SAVE_CONTIGS_PER_KINGDOM } from "../modules/save_contigs_per_kingdom.nf"

workflow FIRST_STEP_DECISION {

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

        MAKE_FIRST_DECISION(join_ch)

        firstDecisions =  MAKE_FIRST_DECISION.out
                            .splitText() {it.replaceFirst(/\n/, "").split()}

        SAVE_CONTIGS_PER_KINGDOM(
            path, 
            4, 
            firstDecisions
        )
        
        contigsRequiringCATvalidatiion = SAVE_CONTIGS_PER_KINGDOM.out
                                        .collectFile(storeDir:"${outdir}/fasta") {it -> ["firstStep_contigs${it[0]}.fa", it[1]]}
                                        .filter(~/.*firstStep_contigsRequiringCATvalidation.fa/)
                                        .ifEmpty("None")
                                        .collect()

    emit:
        firstDecisions = firstDecisions
        contigsRequiringCATvalidatiion = contigsRequiringCATvalidatiion

}