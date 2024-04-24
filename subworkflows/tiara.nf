include { PREDICT_TIARA } from '../modules/predict_tiara.nf'

workflow TIARA {
    take:
        path
        file
        outdir
        minLength

    main:

    PREDICT_TIARA(path, 
                file,
                outdir,
                minLength)
                
    predictions = PREDICT_TIARA.out.predictionsPath
                .splitCsv(sep: "\t", header:true) 
                .map() {it -> [it.sequence_id.split()[0], it.class_fst_stage]}

    emit:
        tiaraPredictions = predictions.flatten().collate(2)

}