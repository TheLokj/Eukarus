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
                    .splitCsv(by:1)
                    .flatten()
                    .filter(~/.*superkingdom.*/)
                    .map {it -> ["${it.split('\t')[0]}", "${(it.split('\s\\(superkingdom\\):\s')[0]).split('\t')[-1]} (${(it.split('\s\\(superkingdom\\):\s')[1]).split('[\t\n]')[0]})"]}
                    .flatten()
                    .collate(2)
                    
    emit: 
        catPredictions = predictions
        logPath = PREDICT_CAT.out.logPath
}