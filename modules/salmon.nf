process SALMON_INDEX_REFERENCE {
    label 'salmon'
    publishDir params.outdir
    
    input:
    path(reference)

    output:
    path 'index'

    script:
    """
    salmon index -t ${reference} -i index
    """
}

process SALMON_QUANTIFY {
    label 'salmon'
    publishDir params.outdir
    
    input:
    tuple val(sample_name), path(reads)
    path index

    output:
    file ("transcripts_quant_${sample_name}/quant.sf")

    script:
    """
    salmon quant  -l A -i $index -1 ${reads[0]} -2 ${reads[1]} --validateMappings -o transcripts_quant_${sample_name} --useVBOpt --gcBias --posBias
    """
}

process SALMON_LOL {
    label 'salmon'
    publishDir params.outdir
    
    input:
    tuple val(sample_name), path(reads)
    path(reference)

    output:
    file ("transcripts_quant_${sample_name}/quant.sf")

    script:
    """
    salmon index -t ${reference} -i ${reference.baseName}
    salmon quant  -l A -i ${reference.baseName} -1 ${reads[0]} -2 ${reads[1]} --validateMappings -o transcripts_quant_${sample_name} --useVBOpt --gcBias --posBias
    """
}