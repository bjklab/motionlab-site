#' ############################
#' load libraries and set seed
#' ############################
library(tidyverse)

set.seed(16)


#' ############################
#' read data from NCBI bibliography and compare to items included on site
#' ############################

read_lines("pubs/medline.txt") |> 
  enframe(value = "medline") |> 
  filter(grepl("\\[doi\\]", medline)) |> 
  mutate(doi = stringr::str_match(string = medline, pattern = "\\- \\s*(.*?)\\s* \\[doi\\]")[,2]) |> 
  select(doi) |> 
  distinct() |> 
  identity() -> ncbi_bib_doi
ncbi_bib_doi

read_rds("pubs/doi.rds") |> 
  select(doi) |> 
  identity() -> site_list_doi
site_list_doi

ncbi_bib_doi |> 
  anti_join(site_list_doi)

site_list_doi |> 
  anti_join(ncbi_bib_doi)


#' ############################
#' combine all unique DOIs
#' ############################

bind_rows(ncbi_bib_doi, site_list_doi) |> 
  distinct() |> 
  identity() -> combined_doi
combined_doi

combined_doi |> 
  pull(doi) |> 
  write_lines("pubs/doi.txt", sep = "\n")


