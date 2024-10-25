process BWAMEM2_MEM {

    queue { entries > 100 ? 'long' : 'short' }

    foo bar
    
    input:
    val x

    def extension_pattern = /(--output-fmt|-O)+\s+(\S+)/
    "echo process job $x"
}
