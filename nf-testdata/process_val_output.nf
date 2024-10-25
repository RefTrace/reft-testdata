process foo {
  input:
  path infile

  output:
  val x, emit: hello, optional: true, topic: 'report'
  val 'BB11'
  val "${infile.baseName}.out"

  script:
  x = infile.name
  """
  cat $x > file
  """
}