process BWAMEM2_MEM {
    tag "$meta.id"
    label 'process_high'

    def extension_pattern = /(--output-fmt|-O)+\s+(\S+)/
}
