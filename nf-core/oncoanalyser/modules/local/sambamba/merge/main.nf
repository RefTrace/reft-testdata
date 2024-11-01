process SAMBAMBA_MERGE {
    tag "${meta.id}"

    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/sambamba:1.0--h98b6b92_0' :
        'quay.io/biocontainers/sambamba:1.0--h98b6b92_0' }"

    input:
    tuple val(meta), path(bams)

    output:
    tuple val(meta), path('*bam'), emit: bam
    path 'versions.yml'          , emit: versions

    script:
    """
    sambamba merge \\
        --nthreads ${task.cpus} \\
        ${meta.sample_id}.bam \\
        ${bams}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        sambamba: \$(sambamba --version 2>&1 | grep -m1 sambamba | sed 's/^sambamba //')
    END_VERSIONS
    """

    stub:
    """
    touch ${meta.sample_id}.bam
    echo -e '${task.process}:\\n  stub: noversions\\n' > versions.yml
    """
}
