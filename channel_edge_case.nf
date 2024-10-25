Channel.fromSamplesheet("input")
    .multiMap { meta, fastq_1, fastq_2, reference, protospacer, template ->
        // meta.condition is part of the screening workflow and we need to remove it
        reads:   [ meta.id, meta - meta.subMap('condition') + [ single_end:fastq_2?false:true, self_reference:reference?false:true, template:template?true:false ], fastq_2?[ fastq_1, fastq_2 ]:[ fastq_1 ] ]
        reference:   [meta - meta.subMap('condition') + [ single_end:fastq_2?false:true, self_reference:reference?false:true, template:template?true:false ], reference]
        protospacer: [meta - meta.subMap('condition') + [ single_end:fastq_2?false:true, self_reference:reference?false:true, template:template?true:false ], protospacer]
        template:    [meta - meta.subMap('condition') + [ single_end:fastq_2?false:true, self_reference:reference?false:true, template:template?true:false ], template]
    }