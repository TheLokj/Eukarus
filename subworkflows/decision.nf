include { MAKE_DECISION } from "../modules/make_decision.nf"
include { SAVE_CONTIGS_PER_KINGDOM } from "../modules/save_contigs_per_kingdom.nf"

workflow DECISION {
    take: 
        path
        infos
        dmcPredictions
        tiaraPredictions
        outdir

    main:
    
        join_ch = infos.join(dmcPredictions, remainder:true).join(tiaraPredictions, remainder:true)

        MAKE_DECISION(join_ch)
        
        infosAndSelection = MAKE_DECISION.out
        .collectFile(storeDir:outdir) {it -> ["summary.tsv", it]}
        .splitText() {it.replaceFirst(/\n/, "").split()}

        SAVE_CONTIGS_PER_KINGDOM(path, infosAndSelection)
        
        SAVE_CONTIGS_PER_KINGDOM.out
        .collectFile(storeDir:outdir) {it -> ["only${it[0]}.fa", it[1]]}

    emit:
        infosAndSelection = infosAndSelection
}