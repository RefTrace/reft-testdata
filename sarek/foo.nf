

// Initialize fasta file with meta map:
//fasta = params.fasta ? Channel.fromPath(params.fasta).map{ it -> [ [id:it.baseName], it ] }.collect() : Channel.empty()
Channel.fromPath(params.fasta)

