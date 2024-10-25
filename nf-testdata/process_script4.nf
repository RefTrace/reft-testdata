mode = 'tcoffee'

process align {
    input:
    path sequences

    script:
    if( mode == 'tcoffee' )
        """
        t_coffee -in $sequences > out_file
        """

    else if( mode == 'mafft' )
        """
        mafft --anysymbol --parttree --quiet $sequences > out_file
        """

    else if( mode == 'clustalo' )
        """
        clustalo -i $sequences -o out_file
        """

    else
        error "Invalid alignment mode: ${mode}"
}