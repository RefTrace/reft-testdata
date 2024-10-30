process GOOD {
    publishDir params.publishDir
    container '123456789012.dkr.ecr.us-west-2.amazonaws.com/foo/bar'
    cpus 1
}

process BAD {
    publishDir params.publishDir
    container 'python:latest'
}