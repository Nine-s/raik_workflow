
nextflow.enable.dsl = 2

include { FASTQC } from './modules/fastqc.nf'
include { FASTP } from './modules/fastp'
include { SALMON_INDEX_REFERENCE ; SALMON_QUANTIFY } from './modules/salmon.nf'

params.outdir = 'results'


workflow {
    //https://www.ncbi.nlm.nih.gov/genome/guide/human/
    read_pairs_ch = channel.fromFilePairs( params.reads, checkIfExists: true ) 
    FASTQC( read_pairs_ch )
    FASTP( read_pairs_ch )
    SALMON_QUANTIFY(FASTP.out.sample_trimmed, params.reference_transcriptome)//, SALMON_INDEX_REFERENCE.out)
}

