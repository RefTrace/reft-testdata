process sayHello {
    output:
    eval('bash --version')
    eval('echo "foo"', emit: hello, optional: true, topic: 'report')

    """
    echo Hello world!
    """
}

workflow {
    sayHello | view
}