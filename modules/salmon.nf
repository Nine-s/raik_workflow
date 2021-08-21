process SALMON_INDEX_REFERENCE {
    label 'salmon'
    publishDir params.outdir
    
    input:
    path(reference)

    output:
    tuple path(reference), path("${reference.baseName}*")

    script:
    """
    salmon index -t ${reference} -i ${reference.baseName}.index
    """
}

process SALMON_QUANTIFY {
    label 'salmon'
    publishDir params.outdir
    
    input:
    tuple val(sample_name), path(reads)
    path(reference)

    output:
    file ("transcripts_quant/quant.sf")

    script:
    """
    salmon index -t ${reference} -i ${reference.baseName}
    salmon quant  -l A -i ${reference.baseName} -1 ${reads[0]} -2 ${reads[1]} --validateMappings -o transcripts_quant --useVBOpt --gcBias --posBias
    """
}