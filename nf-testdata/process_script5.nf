process templateExample {
    input:
    val STR

    script:
    template 'my_script.sh'
}

workflow {
    Channel.of('this', 'that') | templateExample
}