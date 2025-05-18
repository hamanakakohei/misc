#! /usr/bin/Rscript


library(tidyverse)
library(argparser)


extract_qualifed_gene.or.variant = function( DF, type = "1hit" ){
  select(DF, c(variant.id,Gene.refGene,starts_with("Sample_"))) %>% 
    gather(key=sample,value=genotype,starts_with("Sample_")) %>%
    mutate(allele.count=case_when(
      str_detect(.$genotype, "^0/1") ~ 1,
      str_detect(.$genotype, "^1/0") ~ 1,
      str_detect(.$genotype, "^1/1") ~ 2,
      !str_detect(.$genotype, "^0/0") & str_detect(.$genotype, "^0/") ~ 1,
      !str_detect(.$genotype, "^0/0") & str_detect(.$genotype, "^./0") ~ 1,
      !str_detect(.$genotype, "^0/0") & !str_detect(.$genotype, "^0/") & !str_detect(.$genotype, "^./0") ~ 2,
      TRUE ~ 0)
    ) %>% {
      if(type=="1hit"){
        group_by(.,variant.id,sample) %>% 
	  summarise(total.ac=sum(allele.count)) %>% 
          filter(total.ac>=1) %>% 
	  nest(-variant.id) %>%
          mutate(carriers=map(data,connect_samples)) %>% 
	  unnest(carriers) %>%
          select(variant.id,carriers) %>% 
	  return
      }else if(type=="2hit"){
        group_by(.,Gene.refGene,sample) %>% 
	  summarise(total.ac=sum(allele.count)) %>% 
          filter(total.ac>=2) %>% 
	  nest(-Gene.refGene) %>% 
          mutate(carriers.2hit=map(data,connect_samples)) %>% 
	  unnest(carriers.2hit) %>%
          select(Gene.refGene,carriers.2hit) %>% 
	  return
      }
    }
}


connect_samples = function(DT.SAMPLES){
  DT.SAMPLES %>%
    pull(sample) %>% 
    str_c(collapse=";") %>% 
    return
}


#extract_dist = function(DIST){
#  # このdistの意味って何だっけ？
#    strsplit(DIST,"\\(") -> tmp
#    tmp[[1]][2] %>% strsplit(")") -> tmp2
#    tmp2[[1]] %>% str_replace("dist=","") -> tmp3; tmp3[1] %>% return
#}


filter_by_maf = function( DF, HGVD, TOMMO, JPNCOUNT, EXACALL, EXACEAS ){
  filter( DF,
      hgvd_maf    <= HGVD    &
      tommo_maf   <= TOMMO   &
      ExAC_ALL    <= EXACALL &
      ExAC_EAS    <= EXACEAS &
      ( (jpn.symbol!="p" & jpn.count<=JPNCOUNT) | jpn.symbol=="p") 
    ) %>% 
    return
}


filter_by_inheritance = function(DF, INHERITANCE){
  if( INHERITANCE =="AD" ){
    filter(DF, !Chr %in% c("X","Y")) %>% return
  }else if( INHERITANCE == "AR" ){
    filter(DF, !Chr %in% c("X","Y")) %>% {
      return(.)
      #group_by(.,Gene.refGene) %>% 
      #  summarise(n=sum(allele.count)) %>% 
      #  filter(n>1) %>% 
      #  pull(Gene.refGene) ->> ar.gene
      #filter( ., Gene.refGene %in% ar.gene ) %>% 
      #  return
    }
  }else if( INHERITANCE == "XL" ){
    filter(DF, Chr %in% c("X")) %>% return
  }
}


get_hgvd_maf = function( HGVD_col ){
  # 前提：
  # - フォーマットは：
  # -- AF=0.337873,AP=0.667964;RR=256,RA=509,AA=6;NR=1021,NA=521
  # -- .
  if( HGVD_col == "." ){
    return( 0 )
  }else{
    HGVD_AF = strsplit( HGVD_col, "," )[[1]][1]
    if ( startsWith( HGVD_AF, "AF=" ) ) {
      HGVD_AF = as.numeric( str_replace(HGVD_AF, "AF=", "") )
      return( HGVD_AF )
    } else {
      stop("エラー: HGVD_AF は 'AF=' で始まっていません。")
    }
  }
}


get_JpnMutation_from_INFO = function( INFO ){
  # 前提：
  # - 「JpnMutation」はINFOの最後にある
  # - フォーマットは：
  # -- 常染色体：JpnMutation=+:575:572
  # -- 性染色体：JpnMutation=+:281,294:8,19
  INFO_v = strsplit( INFO, ";" )[[1]]
  JPN = INFO_v[ length( INFO_v ) ]
  if ( startsWith( JPN, "JpnMutation=" ) ) {
    JPN_l = str_replace("JpnMutation=", "") %>% 
      strsplit(":") %>% 
      .[[1]]

    return( JPN_l )
  } else {
    stop("エラー: JPN は 'JpnMutation=' で始まっていません。")
  }
}


get_JpnMutation_symbol = function( INFO ) {
  # このシンボルの意味って何だっけ？
  return( get_JpnMutation_from_INFO(INFO) %>% .[1] )
}


get_JpnMutation_count = function( INFO ) {
  COUNT = get_JpnMutation_from_INFO( INFO ) %>% .[3]
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
  COUNT = get_JpnMutation_from_INFO( INFO ) %>% .[3]
  if( str_detect( COUNT, "," )){
    COUNT_male_female = strsplit( COUNT, "," )[[1]] %>% as.numeric
    if( SEX == "male" ){
      return( COUNT_male_female[1] )
    }else if( SEX == "female" ){
      return( COUNT_male_female[2] )
    }else{
      print("ERROR")
    }
  }else{
    return( NA )
  }
}	


get_tommo_maf = function( TOMMO_col ){
  # 前提：
  # - フォーマットは：
  # -- tommo_chr1_892524:A:0.0013:9:6840
  # -- rs201573495:A:0.0009:6:6972
  # -- .
  if( TOMMO_col == "." ){
    return( 0 )
  }else{
    strsplit( TOMMO_col, ":" )[[1]][3] %>% 
      as.numeric %>%
      return
  }
}

