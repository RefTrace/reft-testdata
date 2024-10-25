process foo {

  input:
  val x

  output:
  file proteins
  file 'foo.txt', emit: hello, optional: true, topic: 'report'

  "echo process job $x"
}