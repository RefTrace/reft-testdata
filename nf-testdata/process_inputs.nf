process foo {
  input:
  each mode
  each path(lib)
  path "${x}.fa"
  path x, stageAs: 'data.txt'
  path 'query.fa'
  tuple val(x), path('input.txt')
  tuple val(x), path('many_*.txt', arity: '1..*')
  val x
  file query_file from proteins
  file query_file name 'query.fa' from proteins
  file proteins
  file 'query.fa' from proteins
  path query_file
  path('one.txt', arity: '1')         // exactly one file is expected
  path('pair_*.txt', arity: '2')      // exactly two files are expected
  path('many_*.txt', arity: '1..*')   // one or more files are expected
  path x, stageAs: 'data.txt'
  path 'seq?.fa'
  path "${x}.fa"
  env HELLO
  tuple val(x), env(BLAH)
  stdin str
  tuple val(x), stdin(BAR)
  tuple val(x), path('input.txt')

  "echo process job $x"
}