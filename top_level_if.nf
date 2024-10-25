if (params.dbnsfp && params.dbnsfp_tbi) {
    vep_extra_files.add(file(params.dbnsfp, checkIfExists: true))
    vep_extra_files.add(file(params.dbnsfp_tbi, checkIfExists: true))
}