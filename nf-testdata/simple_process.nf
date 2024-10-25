process BWAMEM2_MEM {
    accelerator 4, type: 'nvidia-tesla-k80'
    tag "$meta.id"
    label 'process_high'

    beforeScript "set_dotfiles.sh; startup_POST.sh $params.projectId $params.pipelineId 2"      
    afterScript "final_POST.sh $params.projectId $params.pipelineId 2 $params.platformHTTP;"
    afterScript "foo"

    arch 'linux/x86_64', target: 'cascadelake'

    executor 'slurm'
    array 100

    cache false
    cache true
    cache 'deep'
    cache 'lenient'

    clusterOptions '-x 1 -y 2'
    clusterOptions '-x 1', '-y 2', '--flag'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/gatk4:4.5.0.0--py36hdfd78af_0':
        'biocontainers/gatk4:4.5.0.0--py36hdfd78af_0' }"
    containerOptions '--volume /data/db:/db'

    cpus 8

    debug true
    debug false

    disk '2 GB'

    echo true
    echo false

    errorStrategy 'ignore'

    executor 'slurm'

    ext version: '2.5.3', args: '--foo --bar'

    fair true

    label 'big_mem'

    machineType 'n1-highmem-8'

    maxSubmitAwait '10 mins'

    maxErrors 5

    maxForks 10

    maxRetries 3

    memory '10 GB'

    module 'ncbi-blast/2.2.27'

    penv 'smp'

    pod env: 'FOO', value: 'bar'

    publishDir '/data/chunks', mode: 'copy', overwrite: false

    queue 'long'

    resourceLabels region: 'some-region', user: 'some-username'

    resourceLimits cpus: 24, memory: 768.GB, time: 72.h

    scratch true

    scratch 'ram-disk'

    shell '/bin/bash', '-euo', 'pipefail'

    spack 'bwa@0.7.15 fastqc@0.11.5'

    stageInMode 'copy'
    stageOutMode 'move'

    storeDir '/db/genomes'

    time '1h'

    queue { entries > 100 ? 'long' : 'short' }
    
    input:
    val x

    def extension_pattern = /(--output-fmt|-O)+\s+(\S+)/
    "echo process job $x"
}
