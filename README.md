This repository contains the first alpha Nextflow pipeline allowing to split contigs according to their predicted kingdom. 

## Requirements

The current prerequisites are Singularity and the `deepmicroclass.sif` & `tiara.sif` associated tool images, which are located in :

`/hps/nobackup/rdf/metagenomics/service-team/users/louison/nextflow/project/bin/`

## Usage

You can run the current version of the pipeline like this:

    nextflow run main.nf --contigsFile {fastaContainedInData.fa}

Note that you can specify the [DeepMicroClass](https://github.com/chengsly/DeepMicroClass/tree/master) parameters by adding these when running the nextflow script :

    nextflow run main.nf --contigsFile {path} --model {path} --encoding {onehot,embedding} --mode {hybrid,single} --singleLen {n} --device {cpu,cuda}

By default, the model contained in the Singularity image `deepmicroclass.sif` is used.

In addition, although it is possible to specify the use of CUDA, please first check that the image used corresponds to the GPU version of DeepMicroClass. 