process perlTask {
    """
    #!/usr/bin/perl

    print 'Hi there!' . '\n';
    """
}

process pythonTask {
    """
    #!/usr/bin/python

    x = 'Hello'
    y = 'world!'
    print "%s - %s" % (x,y)
    """
}