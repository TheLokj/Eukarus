include { PREDICT_CAT } from '../modules/predict_cat.nf'
include { ADD_NAMES_CAT } from '../modules/add_names_cat.nf'

workflow CAT {

    take:
        contigsRequiringCATvalidatiion
        outdir
        catDB
        diamondDB
        taxonomyDB

    main:

        PREDICT_CAT(
            contigsRequiringCATvalidatiion, 
            catDB,
            diamondDB,
            taxonomyDB,
            outdir
        )

        ADD_NAMES_CAT(
            PREDICT_CAT.out.classification, 
            taxonomyDB, 
            outdir
        )

        predictions = ADD_NAMES_CAT.out
                    .splitCsv(skip:1, sep:"\t")
                    .map {it -> ["${it[0]}", "${it[7].split(' ')[0]} (${it[7].split(": ")[1]})"]}
                    .flatten()
                    .collate(2)
        
    emit: 
        catPredictions = predictions
        logPath = PREDICT_CAT.out.logPath
}