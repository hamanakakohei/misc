#!/home/hamanaka/miniconda3/envs/misc/bin/Rscript


#library(tidyverse)
#library(argparser)


get_variant_carriers = function( DF ){
  df_long = select( DF, c( variant_id, Gene.refGene, starts_with("Sample_") ) ) %>% 
    pivot_longer( cols = starts_with("Sample_"), names_to = "sample", values_to = "genotype" ) %>%
    mutate( alt_count = case_when(
       str_detect( genotype, "^0/1" ) ~ 1,
       str_detect( genotype, "^1/0" ) ~ 1,
       str_detect( genotype, "^1/1" ) ~ 2,
      !str_detect( genotype, "^0/0" ) &  str_detect( genotype, "^0/"  ) ~ 1,
      !str_detect( genotype, "^0/0" ) &  str_detect( genotype, "^./0" ) ~ 1,
      !str_detect( genotype, "^0/0" ) & !str_detect( genotype, "^0/"  ) & !str_detect( genotype, "^./0" ) ~ 2,
      TRUE ~ 0)
    ) 
  
  variant_carriers = group_by( df_long, variant_id, sample ) %>% 
    summarise( total_alt_count = sum(alt_count), .groups = "drop" ) %>% 
    filter( total_alt_count >= 1 ) %>% 
    nest( data = everything(), .by = variant_id ) %>%
    mutate( carriers = map(data, connect_samples) ) %>% 
    unnest( carriers ) %>%
    select( variant_id, carriers )

  gene_carriers_2hit = group_by( df_long, Gene.refGene, sample ) %>% 
    summarise( total_alt_count = sum(alt_count), .groups = "drop" ) %>% 
    filter( total_alt_count >= 2 ) %>% 
    nest( data = everything(), .by = Gene.refGene ) %>% 
    mutate( carriers_2hit_on_the_gene = map(data, connect_samples) ) %>% 
    unnest( carriers_2hit_on_the_gene) %>%
    select( Gene.refGene, carriers_2hit_on_the_gene )

  return( list(
    variant_carriers = variant_carriers, 
    gene_carriers_2hit = gene_carriers_2hit
  ) )
}


connect_samples = function(DF){
  DF %>%
    pull(sample) %>% 
    str_c(collapse=";") %>% 
    return
}


filter_af_threshold = function(DF, af_col, af_threshold) {
  if (!is.na(af_threshold)) {
    DF = filter(DF, !!sym(af_col) < af_threshold)
  }
  return(DF)
}


filter_chr_by_inheritance = function(DF, INHERITANCE){
  if( INHERITANCE %in% c("AD", "AR") ){
    filter(DF, !Chr %in% c("X","Y")) %>% return
  } else if ( INHERITANCE == "XL" ){
    filter(DF, Chr %in% c("X")) %>% return
  } else {
    stop("エラー in filter_chr_by_inheritance")
  }
}


filter_by_gene_mode_of_inheritance = function(DF, INHERITANCE){
  # G2PのG2P_allelic_requirement列の値は：
  # - biallelic_autosomal
  # - mitochondrial
  # - monoallelic_X_hemizygous
  # - monoallelic_X_heterozygous
  # - monoallelic_Y_hemizygous
  # - monoallelic_autosomal
  # 
  # GenCCのGenCC_moi_title列の値は：
  # - Autosomal dominant
  # - Autosomal recessive
  # - Mitochondrial
  # - Semidominant
  # - Unknown
  # - X-linked
  # - X-linked recessive
  # - Y-linked inheritance

  if ( INHERITANCE == "AD" ){
    filter( DF, 
        G2P_allelic_requirement %in% c( "monoallelic_autosomal" ) |
        GenCC_moi_title         %in% c( "Autosomal dominant", "Semidominant")
      ) %>%
      return
  } else if ( INHERITANCE == "AR" ){
    filter( DF,
        G2P_allelic_requirement %in% c( "biallelic_autosomal" ) |
        GenCC_moi_title         %in% c( "Autosomal recessive", "Semidominant")
      ) %>%
      return
  } else if ( INHERITANCE == "XL" ){
    filter( DF,
        G2P_allelic_requirement %in% c( "monoallelic_X_hemizygous", "monoallelic_X_heterozygous" ) |
        GenCC_moi_title         %in% c( "X-linked", "X-linked recessive")
      ) %>%
      return
  } else {
    stop("エラー in filter_by_gene_mode_of_inheritance")
  }
}


get_hgvd_maf = function( HGVD_col ){
  # 前提：
  # - フォーマットは：
  # -- AF=0.337873,AP=0.667964;RR=256,RA=509,AA=6;NR=1021,NA=521
  # -- .
  if( HGVD_col == "." ){
    return( 0 )
  }

  HGVD_AF = strsplit( HGVD_col, "," )[[1]][1]

  if ( startsWith( HGVD_AF, "AF=" ) ) {
    return( as.numeric( sub("AF=", "", HGVD_AF) ) )
  } else {
    stop("エラー: HGVD_AF は 'AF=' で始まっていません。")
  }
}


get_JpnMutation_from_INFO = function( INFO ){
  # 前提：
  # - 「JpnMutation」はINFOの最後にある
  # - フォーマットは：
  # -- 常染色体：JpnMutation=+:575:572
  # -- 性染色体：JpnMutation=+:281,294:8,19
  INFO_v = strsplit( INFO, ";" )[[1]]
  JPN = tail( INFO_v, 1 )

  if ( startsWith( JPN, "JpnMutation=" ) ) {
    JPN_v = strsplit( sub( "JpnMutation=", "", JPN ), ":" )[[1]]
    return(JPN_v)
  } else {
    stop("エラー: JPN は 'JpnMutation=' で始まっていません。")
  }
}


get_JpnMutation_symbol = function( INFO ) {
  return( get_JpnMutation_from_INFO(INFO)[1] )
}


get_JpnMutation_count = function( INFO ) {
  COUNT = get_JpnMutation_from_INFO( INFO )[3]

  if( str_detect( COUNT, "," ) ){
    strsplit( COUNT, "," )[[1]] %>% 
      as.numeric %>% 
      sum %>%
      return
  }else{
    return( as.numeric( COUNT ) )
  }
}	


get_JpnMutation_count_sex_chr = function( INFO, SEX = "male" ) {
  COUNT = get_JpnMutation_from_INFO( INFO )[3]
  
  if( str_detect( COUNT, "," )){
    COUNT_male_female = strsplit( COUNT, "," )[[1]] %>% as.numeric
    if( SEX == "male" ){
      return( COUNT_male_female[1] )
    }else if( SEX == "female" ){
      return( COUNT_male_female[2] )
    }else{
      stop("エラー in get_JpnMutation_count_sex_chr")
    }
  }

  return( NA )
}	


get_tommo_maf = function( TOMMO_col ){
  # 前提：
  # - フォーマットは：
  # -- tommo_chr1_892524:A:0.0013:9:6840
  # -- rs201573495:A:0.0009:6:6972
  # -- .
  if( TOMMO_col == "." ){
    return( 0 )
  }
  
  TOMMO_col_v = strsplit( TOMMO_col, ":" )[[1]]

  if( length( TOMMO_col_v ) != 5 ){ 
    stop("エラー in get_tommo_maf")
  }

  return( as.numeric( TOMMO_col_v[3] ) )
}


cat_another_caller_variants = function( DF_ANNOVAR, DF_ANOTHER ){
  # DF_ANNOVAR にCaller列が無ければ追加する
  # DF_ANOTHER の列は以下をしっかり埋めておくと他の所のフィルターで事故が起きにくい：
  # - Caller
  # - Chr
  # - Start
  # - End
  # - Func.refGene
  # - Gene.refGene
  # - GeneDetail.refGene
  # - ExonicFunc.refGene
  # - AAChange.refGene
  # - Sample_XX (genotype情報が大切)
  require(dplyr)

  if( !"Caller" %in% colnames( DF_ANNOVAR ) ){
    DF_ANNOVAR$Caller = "Annovar"
  }
  
  DF_CATTED = bind_rows( DF_ANNOVAR, DF_ANOTHER)
  # DF_CATTED[ is.na(DF_CATTED) ] = "."
  return( DF_CATTED )
}


get_SpliceAI_max_score = function( SPLICEAI ){
  if ( SPLICEAI == "." ) {
     return( 0 )
  } 
  parts = str_split( SPLICEAI, "\\|" )[[1]][3:6]
  return( max( as.numeric(parts) ) )
}



#filter_by_maf = function( DF, HGVD, TOMMO, JPNCOUNT, EXACALL, EXACEAS ){
#  filter( DF,
#      hgvd_maf    <= HGVD    &
#      tommo_maf   <= TOMMO   &
#      ExAC_ALL    <= EXACALL &
#      ExAC_EAS    <= EXACEAS &
#      ( (jpn.symbol!="p" & jpn.count<=JPNCOUNT) | jpn.symbol=="p") 
#    ) %>% 
#    return
#}
