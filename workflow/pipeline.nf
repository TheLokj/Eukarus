include { INFOS } from '../subworkflows/infos.nf'
include { DEEPMICROCLASS } from '../subworkflows/deepmicroclass.nf'
include { TIARA } from '../subworkflows/tiara.nf'
include { DECISION } from '../subworkflows/decision.nf'

// Declaration of input variables
params.contigsFile = null
params.minLength = 1

// Declaration of path variables
params.dataPath = "$projectDir/data/"
params.outdir = "$projectDir/out/"
outdir = params.outdir
params.contigsPath = params.dataPath + params.contigsFile

// DeepMicroClass parameters
// The default modelPath will lead to the use of the one contained in the Singularity image
params.modelPath = "default"
params.encoding = "onehot"
params.mode = "hybrid"
params.device = "cpu" 
params.singleLen = 1

path = Channel.of(params.contigsPath)
file = Channel.of(params.contigsFile)
modelPath = Channel.of(params.modelPath)
encoding = Channel.of(params.encoding)
mode = Channel.of(params.mode)
device = Channel.of(params.device)
singleLen = Channel.of(params.singleLen)
minLength = Channel.of(params.minLength)

workflow IDENTIFY_KINGDOM {

    INFOS(path, outdir)

    DEEPMICROCLASS(path, file, outdir, modelPath, encoding, mode, device, singleLen)

    TIARA(path, file, outdir, minLength)

    DECISION(path, INFOS.out, DEEPMICROCLASS.out.dmcHitPredictions, TIARA.out, outdir)
    
    }