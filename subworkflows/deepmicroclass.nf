include { PREDICT_DEEPMICROCLASS } from '../modules/predict_deepmicroclass.nf'
include { PARSE_DMC_CLASSIFICATION } from '../modules/parse_dmc_classification.nf'

workflow DEEPMICROCLASS {

    take:
        path
        outdir
        modelPath
        encoding
        mode
        device
        singleLen

    main:

        PREDICT_DEEPMICROCLASS(
            path,
            outdir,
            modelPath,
            encoding,
            mode,
            device,
            singleLen
        )
    
        scores = PREDICT_DEEPMICROCLASS.out.predictionsPath
                .splitCsv(sep: "\t", header:true)
        
        PARSE_DMC_CLASSIFICATION(
            scores, 
            outdir
        )
        
        predictions = PARSE_DMC_CLASSIFICATION.out
                        .collectFile(storeDir:"${outdir}/DeepMicroClass") {it -> ["dmc.hit.tsv", it]}
                        .splitText() {it.replaceFirst(/\n/, "").split()} 
                        .flatten()
                        .collate(2)

    emit: 
        scores = scores
        dmcHitPredictions = predictions
        logPath = PREDICT_DEEPMICROCLASS.out.logPath
}