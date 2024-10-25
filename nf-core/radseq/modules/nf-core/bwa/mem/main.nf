process BWA_MEM {
    tag "$meta.id"
    label 'process_medium'

    conda "bioconda::bwa=0.7.17 bioconda::samtools=1.15.1"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/mulled-v2-fe8faa35dbf6dc65a0f7f5d4ea12e31a79f73e40:8110a70be2bfe7f75a2ea7f2a89cda4cc7732095-0' :
        'quay.io/biocontainers/mulled-v2-fe8faa35dbf6dc65a0f7f5d4ea12e31a79f73e40:8110a70be2bfe7f75a2ea7f2a89cda4cc7732095-0' }"

    input:
    tuple val(meta), path(reads)
    tuple val(meta2), path(index)
    val   sort_bam
    val   sequence_type
    val   lengths

    output:
    tuple val(meta), path("*.bam"), emit: bam
    path  "versions.yml"          , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args =   task.ext.args      ?: ''
    def args2 =  task.ext.args2     ?: ''
    def args3 =  task.ext.args3     ?: ''
    def prefix = task.ext.prefix    ?: "${meta.id}"
    if (sequence_type == 'PE' && params.method == 'denovo') {
        """
        INDEX=`find -L ./ -name "*.amb" | sed 's/.amb//'`
        
        echo "${lengths.join("\n")}" > lengths.txt
        MLEN=\$(awk '{ print length() | "sort -rn" }' lengths.txt | head -1)
        INSERT=\$(( \$MLEN * 2 ))
        INSERTH=\$(( \$INSERT + 100 ))
        INSERTL=\$(( \$INSERT - 100 ))
        SD=\$(( \$INSERT / 5 ))

        bwa mem \\
            $args \\
            -I \$INSERT,\$SD,\$INSERTH,\$INSERTL \\
            -R "@RG\\tID:${prefix}\\tSM:${prefix}\\tPL:Illumina" \\
            -t $task.cpus \\
            \$INDEX \\
            $reads \\
            | samtools view $args2 \\
            | samtools sort $args3 --threads $task.cpus -o ${prefix}.bam -

cat <<-END_VERSIONS > versions.yml
"${task.process}":
    bwa: \$(echo \$(bwa 2>&1) | sed 's/^.*Version: //; s/Contact:.*\$//')
    samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')
END_VERSIONS
        """
    } else {
        """
        INDEX=`find -L ./ -name "*.amb" | sed 's/.amb//'`

        bwa mem \\
            $args \\
            -R "@RG\\tID:${prefix}\\tSM:${prefix}\\tPL:Illumina" \\
            -t $task.cpus \\
            \$INDEX \\
            $reads \\
            | samtools view $args2 \\
            | samtools sort $args3 --threads $task.cpus -o ${prefix}.bam -

cat <<-END_VERSIONS > versions.yml
"${task.process}":
    bwa: \$(echo \$(bwa 2>&1) | sed 's/^.*Version: //; s/Contact:.*\$//')
    samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')
END_VERSIONS
        """
    }
}
