process foo {
    output:
    tuple val(meta), path("${prefix}.tsv")          , emit: report, topic: 'report'
    tuple val(meta), path("${prefix}-mutations.tsv"), emit: mutation_report, optional: true
}