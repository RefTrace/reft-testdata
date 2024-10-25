process foo {
  input:
  file query_file from proteins
  file query_file name 'query.fa' from proteins
  file proteins
  file 'foo.txt'
  file 'query.fa' from proteins

  "echo process job $x"
}