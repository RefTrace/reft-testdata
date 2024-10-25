process genotyping_pileupcaller {

  input:
  path(bed) from ch_bed_for_pileupcaller.collect()
  path(snp) from ch_snp_for_pileupcaller.collect()
}