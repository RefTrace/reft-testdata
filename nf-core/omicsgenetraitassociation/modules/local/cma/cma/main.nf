process CMA {

    label 'process_low'

    container 'jungwooseok/cma:1.2.7' // TODO: replace when released on bioconductor

    input:
    path input_files // list of input files to CMA (to accomodate arbitrary number of files)
    val trait
    val category

    output:
    // TODO: output files should be standalone -- use publishdir directive instead
    val(trait), emit: trait
    val(category), emit: category
    path("CMA_meta.csv"), emit: pval
    path("tetrachor_sigma.txt"), emit: tetrachor
    path("versions.yml"), emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def output_dir = category ? "${trait}/${category}/" : "${trait}/"

    """
    mkdir -p cma_input_dir
    mv ${input_files} cma_input_dir

    mkdir -p $output_dir
    Rscript /app/cma.R cma_input_dir $output_dir $trait

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        R: \$(R --version | head -n1)
        CMA: \$(Rscript -e "print(packageVersion('corrmeta'))")
        dplyr: \$(Rscript -e "print(packageVersion('dplyr'))")
    END_VERSIONS
    """
}
