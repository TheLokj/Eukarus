include { GET_CONTIGS_INFO } from "../modules/get_contigs_info.nf"
include { PREDICT_TIARA } from '../modules/predict_tiara.nf'
include { DEEPMICROCLASS } from '../subworkflows/deepmicroclass.nf'
include { CAT } from '../subworkflows/cat.nf'
include { FIRST_STAGE_DECISION } from '../subworkflows/first_stage_decision.nf'
include { SECOND_STAGE_DECISION } from '../subworkflows/second_stage_decision.nf'
include { SAVE_METADATA } from '../modules/save_metadata.nf'

// Declaration of input variables
params.outdir = "$projectDir/out/"
outdir = params.outdir + "${params.contigsPath.split("/")[-1]}"

// Tiara parameters
params.minLength = 1

// DeepMicroClass parameters
// The default modelPath will lead to the use of the one contained in the Singularity image
params.dmcModelPath = "default"
params.encoding = "onehot"
params.mode = "hybrid"
params.device = "cpu" 
params.singleLen = 1

// Declaration of Channels
path = Channel.of(params.contigsPath)
catDB = Channel.fromPath(params.catDB, checkIfExists:true)
diamondDB = Channel.fromPath(params.diamondDB, checkIfExists:true)
taxonomyDB = Channel.fromPath(params.taxonomyDB, checkIfExists:true)
tiaraVersion = Channel.of(params.tiaraVersion)
dmcVersion = Channel.of(params.dmcVersion)
dmcModelPath = Channel.of(params.dmcModelPath)
encoding = Channel.of(params.encoding)
mode = Channel.of(params.mode)
device = Channel.of(params.device)
singleLen = Channel.of(params.singleLen)
minLength = Channel.of(params.minLength)

workflow EUKARUS {

    GET_CONTIGS_INFO(path)

    infos = GET_CONTIGS_INFO.out
        .splitText() {it.replaceFirst(/\n/, "").split()}  
        .flatten()
        .collate(2)

    DEEPMICROCLASS(
        path, 
        outdir, 
        dmcModelPath, 
        encoding, 
        mode, 
        device, 
        singleLen
    )

    PREDICT_TIARA(
        path, 
        outdir,
        minLength
    )

    tiaraPredictions = PREDICT_TIARA.out.predictionsPath
                .splitCsv(sep: "\t", header:true) 
                .map() {it -> [it.sequence_id.split()[0], it.class_fst_stage]}
                .flatten()
                .collate(2)

    FIRST_STAGE_DECISION(
        path, 
        infos, 
        DEEPMICROCLASS.out.dmcHitPredictions, 
        tiaraPredictions, 
        outdir
    )
 
    CAT(
        FIRST_STAGE_DECISION.out.contigsRequiringCATvalidatiion,
        outdir, 
        catDB, 
        diamondDB, 
        taxonomyDB
    )
    
    SECOND_STAGE_DECISION(
        path, 
        FIRST_STAGE_DECISION.out.firstDecisions, 
        CAT.out.catPredictions, 
        outdir
    ) 

    SAVE_METADATA(
        outdir, 
        tiaraVersion, 
        PREDICT_TIARA.out.logPath, 
        dmcVersion, 
        DEEPMICROCLASS.out.logPath, 
        CAT.out.logPath, 
        catDB, 
        diamondDB, 
        taxonomyDB
    )

}