#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { IDENTIFY_KINGDOM } from './workflow/pipeline.nf'

workflow {
    IDENTIFY_KINGDOM()
}