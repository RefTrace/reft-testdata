process FOO {
    container 'foo:latest'
}

process BAR {
    label 'bar'
}

process CONDA {
    conda 'foo'
}

process MODULE {
    module 'foo'
}

process SPACK {
    spack 'foo'
}

process BAD {
    cpus 100
}