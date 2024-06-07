#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { EUKARUS } from './workflow/pipeline.nf'

workflow {
    EUKARUS()
}