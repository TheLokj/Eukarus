# kingdom-investigator

This repository contains a Nextflow pipeline allowing to isolate eukaryotic contigs from assemblies. 

## Requirements

The current prerequisites are Singularity and the tool images of [Tiara](https://github.com/ibe-uw/tiara), [DeepMicroClass](https://github.com/chengsly/DeepMicroClass/tree/master) and [CAT](https://github.com/MGXlab/CAT_pack). 

## Usage

You can run the current version of the pipeline like this :

    nextflow run main.nf --contigsFile {fasta.fa}

For non-EBI users, note that you'll need to create your own profile and associated config file in order to precise the container paths and versions. 

## Settings

Note that you can specify the [DeepMicroClass](https://github.com/chengsly/DeepMicroClass/tree/master) parameters by adding these when running the nextflow script :

    nextflow run main.nf --contigsFile {path} --model {path} --encoding {onehot,embedding} --mode {hybrid,single} --singleLen {n} --device {cpu,cuda}

By default, the model contained in the Singularity image `deepmicroclass.sif` is used.

In addition, although it is possible to specify the use of CUDA, please first check that the used image corresponds to the GPU version of DeepMicroClass.
