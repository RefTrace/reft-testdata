process MAGECK_TEST {
    tag "${meta.treatment}_${meta.reference}"
    label 'process_medium'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/mageck:0.5.9--py37h6bb024c_0':
        'biocontainers/mageck:0.5.9--py37h6bb024c_0' }"

    input:
    tuple val(meta), path(count_table)

    output:
    tuple val(meta), path("*.gene_summary.txt")  , emit: gene_summary
    tuple val(meta), path("*.sgrna_summary.txt") , emit: sgrna_summary
    tuple val(meta), path("*.R")                 , emit: r_script
    tuple val(meta), path("*.Rnw")               , emit: r_summary
    tuple val(meta), path("*.log")               , emit: logs
    path "versions.yml"                          , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def args2 = task.ext.args2 ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"

    """
    mageck  \\
        test \\
        $args \\
        $args2 $meta.treatment \\
        -c $meta.reference \\
        -k $count_table \\
        -n ${meta.treatment}_${meta.reference}


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        mageck: \$(mageck -v)
    END_VERSIONS
    """
}
