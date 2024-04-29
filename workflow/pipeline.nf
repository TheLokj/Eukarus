include { GET_CONTIGS_INFO } from "../modules/get_contigs_info.nf"
include { PREDICT_TIARA } from '../modules/predict_tiara.nf'
include { DEEPMICROCLASS } from '../subworkflows/deepmicroclass.nf'
include { DECISION } from '../subworkflows/decision.nf'

// Declaration of input variables
params.contigsPath = null
params.minLength = 1

// Declaration of path variables
params.outdir = "$projectDir/out/${params.contigsPath.split("/")[-1]}"
outdir = params.outdir

// DeepMicroClass parameters
// The default modelPath will lead to the use of the one contained in the Singularity image
params.modelPath = "default"
params.encoding = "onehot"
params.mode = "hybrid"
params.device = "cpu" 
params.singleLen = 1

path = Channel.of(params.contigsPath)
modelPath = Channel.of(params.modelPath)
encoding = Channel.of(params.encoding)
mode = Channel.of(params.mode)
device = Channel.of(params.device)
singleLen = Channel.of(params.singleLen)
minLength = Channel.of(params.minLength)

workflow IDENTIFY_KINGDOM {

    GET_CONTIGS_INFO(path)

    infos = GET_CONTIGS_INFO.out
        .collectFile(storeDir:outdir) {it -> ["length.tsv", it]} 
        .splitText() {it.replaceFirst(/\n/, "").split()}  
        .flatten().collate(2)

    DEEPMICROCLASS(path, outdir, modelPath, encoding, mode, device, singleLen)

    PREDICT_TIARA(path, 
                outdir,
                minLength)

    tiaraPredictions = PREDICT_TIARA.out.predictionsPath
                .splitCsv(sep: "\t", header:true) 
                .map() {it -> [it.sequence_id.split()[0], it.class_fst_stage]}
                .flatten()
                .collate(2)

    DECISION(path, infos, DEEPMICROCLASS.out.dmcHitPredictions, tiaraPredictions, outdir)
    
    }