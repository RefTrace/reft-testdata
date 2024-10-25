process sayHello {

    output:
    stdout emit: hello, optional: true, topic: 'report'

    """
    echo Hello world!
    """
}