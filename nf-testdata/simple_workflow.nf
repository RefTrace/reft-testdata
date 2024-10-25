workflow my_pipeline {
    take:
    data1
    data2

    main:
    foo(data1, data2)
    bar(foo.out)

    emit:
    bar.out
    multiqc_report = SAREK.out.multiqc_report
}

workflow {
    my_pipeline()
}