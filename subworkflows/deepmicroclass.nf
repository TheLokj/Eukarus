include { PREDICT_DEEPMICROCLASS } from '../modules/predict_deepmicroclass.nf'
include { PARSE_DMC_CLASSIFICATION } from '../modules/parse_dmc_classification.nf'

workflow DEEPMICROCLASS {

    take:
        path
        file
        outdir
        modelPath
        encoding
        mode
        device
        singleLen

    main:

        PREDICT_DEEPMICROCLASS(
            path, 
            file,
            outdir,
            modelPath,
            encoding,
            mode,
            device,
            singleLen)
    
        scores = PREDICT_DEEPMICROCLASS.out.predictionsPath
        .splitCsv(sep: "\t", header:true)
        
        PARSE_DMC_CLASSIFICATION(scores, outdir)
        
        predictions = PARSE_DMC_CLASSIFICATION.out
                        .collectFile(storeDir:outdir) {it -> ["dmc.tsv", it]}
                        .splitText() {it.replaceFirst(/\n/, "").split()} 

    emit: 
        scores = scores
        dmcHitPredictions = predictions.flatten().collate(2)
}