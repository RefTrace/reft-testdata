process foo {
output:
  path 'foo.txt'
  path('one.txt', arity: '1')         // exactly one file is expected
  path('pair_*.txt', arity: '2')      // exactly two files are expected
  path('many_*.txt', arity: '1..*')   // one or more files are expected
  path "${species}.aln"
  path 'blah.txt', followLinks: false, glob: false, hidden: true
  path '*.txt', includeInputs: true, maxDepth: 1, type: 'dir'
  path 'foo.txt', emit: hello, optional: true, topic: 'report'

  "echo process job $x"
}