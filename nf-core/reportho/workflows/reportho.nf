/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { FASTQC                 } from '../modules/nf-core/fastqc/main'
include { MULTIQC                } from '../modules/nf-core/multiqc/main'
include { paramsSummaryMap       } from 'plugin/nf-validation'
include { paramsSummaryMultiqc   } from '../subworkflows/nf-core/utils_nfcore_pipeline'
include { softwareVersionsToYAML } from '../subworkflows/nf-core/utils_nfcore_pipeline'
include { methodsDescriptionText } from '../subworkflows/local/utils_nfcore_reportho_pipeline'

include { GET_ORTHOLOGS          } from '../subworkflows/local/get_orthologs'
include { FETCH_SEQUENCES        } from '../subworkflows/local/fetch_sequences'
include { FETCH_STRUCTURES       } from '../subworkflows/local/fetch_structures'
include { ALIGN                  } from '../subworkflows/local/align'
include { MAKE_TREES             } from '../subworkflows/local/make_trees'
include { REPORT                 } from '../subworkflows/local/report'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow REPORTHO {

    take:
    ch_samplesheet // channel: samplesheet read in from --input

    main:

    ch_versions = Channel.empty()
    ch_multiqc_files = Channel.empty()

    ch_query_fasta = params.uniprot_query ? ch_samplesheet.map { [it[0], []] } : ch_samplesheet.map { [it[0], file(it[1])] }

    GET_ORTHOLOGS (
        ch_samplesheet
    )

    ch_versions
        .mix(GET_ORTHOLOGS.out.versions)
        .set { ch_versions }

    ch_seqhits = ch_samplesheet.map { [it[0], []] }
    ch_seqmisses = ch_samplesheet.map { [it[0], []] }
    ch_strhits = ch_samplesheet.map { [it[0], []] }
    ch_strmisses = ch_samplesheet.map { [it[0], []] }
    ch_alignment = ch_samplesheet.map { [it[0], []] }
    ch_iqtree = ch_samplesheet.map { [it[0], []] }
    ch_fastme = ch_samplesheet.map { [it[0], []] }

    if (!params.skip_downstream) {
        FETCH_SEQUENCES (
            GET_ORTHOLOGS.out.orthologs,
            ch_query_fasta
        )

        ch_seqhits = FETCH_SEQUENCES.out.hits

        ch_seqmisses = FETCH_SEQUENCES.out.misses

        ch_versions
            .mix(FETCH_SEQUENCES.out.versions)
            .set { ch_versions }

        if (params.use_structures) {
            FETCH_STRUCTURES (
                GET_ORTHOLOGS.out.orthologs
            )

            ch_strhits = FETCH_STRUCTURES.out.hits

            ch_strmisses = FETCH_STRUCTURES.out.misses

            ch_versions
                .mix(FETCH_STRUCTURES.out.versions)
                .set { ch_versions }
        }

        ch_structures = params.use_structures ? FETCH_STRUCTURES.out.structures : Channel.empty()

        ALIGN (
            FETCH_SEQUENCES.out.sequences,
            ch_structures
        )

        ch_alignment = ALIGN.out.alignment

        ch_versions
            .mix(ALIGN.out.versions)
            .set { ch_versions }

        MAKE_TREES (
            ALIGN.out.alignment
        )

        ch_iqtree = MAKE_TREES.out.mlplot
        ch_fastme = MAKE_TREES.out.meplot

        ch_versions
            .mix(MAKE_TREES.out.versions)
            .set { ch_versions }
    }

    if(!params.skip_report) {
        REPORT (
            GET_ORTHOLOGS.out.seqinfo,
            GET_ORTHOLOGS.out.score_table,
            GET_ORTHOLOGS.out.orthologs,
            GET_ORTHOLOGS.out.supports_plot,
            GET_ORTHOLOGS.out.venn_plot,
            GET_ORTHOLOGS.out.jaccard_plot,
            GET_ORTHOLOGS.out.stats,
            ch_seqhits,
            ch_seqmisses,
            ch_strhits,
            ch_strmisses,
            ch_alignment,
            ch_iqtree,
            ch_fastme
        )

        ch_versions
            .mix(REPORT.out.versions)
            .set { ch_versions }
    }

    //
    // Collate and save software versions
    //
    ch_versions
        .collectFile(storeDir: "${params.outdir}/pipeline_info", name: 'versions.yml', sort: true, newLine: true)
        .set { ch_collated_versions }

    emit:
    versions = ch_collated_versions // channel: [ path(versions.yml) ]
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
