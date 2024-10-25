process CIGAR_PARSER {
    tag "$meta.id"
    label 'process_medium'

    conda 'pandoc=2.19.2 r-seqinr=4.2_16 r-optparse=1.7.3 bioconductor-rsamtools=2.10.0 r-dplyr=1.0.10 r-plyr=1.8.7 r-stringr=1.4.1 bioconductor-shortread=1.52.0 bioconductor-genomicalignments=1.30.0 r-data.table=1.14.4 bioconductor-biomart=2.50.0 r-plotly=4.10.0 bioconductor-decipher=2.22.0 bioconductor-biostrings=2.62.0 r-parallelly=1.32.1 r-jsonlite=1.8.2'
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/mulled-v2-61c59287265e27f2c4589cfc90013ef6c2c6acf1:fb3e48060a8c0e5108b1b60a2ad7e090cfb9eee5-0' :
        'biocontainers/mulled-v2-61c59287265e27f2c4589cfc90013ef6c2c6acf1:fb3e48060a8c0e5108b1b60a2ad7e090cfb9eee5-0' }"

    input:
    tuple val(meta), path(reads), path(index), path(reference), val(protospacer), path(template), path(template_bam), path(reference_template), path(summary)

    output:
    tuple val(meta), path("*[!QC-]indels.csv"), path("*_subs-perc.csv"), emit: indels
    tuple val(meta), path("*.html"), path("*edits.csv")          , emit: edition
    tuple val(meta), path("*cutSite.json")                       , emit: cutsite
    tuple val(meta), path("*_QC-indels.csv")                     , emit: qcindels
    tuple val(meta), path("*_reads-summary.csv")                 , emit: processing
    path "versions.yml"                                          , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def template_bool = "${meta.template}" == "true" ? "--template_bool" : ""
    """
    cigar_parser.R \\
        $args \\
        --input=$reads \\
        --output=$prefix \\
        --reference=$reference \\
        --gRNA_sequence=$protospacer \\
        --sample_name=$prefix \\
        --reference_template=$reference_template\\
        --template_bam=$template_bam\\
        --template=$template \\
        --summary_file=$summary \\
        $template_bool

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        seqinr: \$(Rscript -e "cat(paste(packageVersion('seqinr'), collapse='.'))")
        Rsamtools: \$(Rscript -e "cat(paste(packageVersion('Rsamtools'), collapse='.'))")
        dplyr: \$(Rscript -e "cat(paste(packageVersion('dplyr'), collapse='.'))")
        ShortRead: \$(Rscript -e "cat(paste(packageVersion('ShortRead'), collapse='.'))")
        jsonlite: \$(Rscript -e "cat(paste(packageVersion('jsonlite'), collapse='.'))")
        stringr: \$(Rscript -e "cat(paste(packageVersion('stringr'), collapse='.'))")
        plotly: \$(Rscript -e "cat(paste(packageVersion('plotly'), collapse='.'))")
    END_VERSIONS
    """
}
