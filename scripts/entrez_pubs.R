#' ###############################
#' load libraries and set seed
#' ###############################
library(tidyverse)
library(gt)
library(rentrez)

set.seed(16)


#' ###############################
#' get data
#' ###############################

motion_search <- entrez_search(db="pubmed", term="brendan j kelly[Author]", retmax=250)

motion_pubs <- tibble(pub_ids = motion_search$ids) |> 
  mutate(entrez = map(.x = pub_ids, .f = ~ entrez_summary(db="pubmed", id = .x)))

entrez_categories <- c('uid','pubdate','epubdate','source','authors','lastauthor','title','sorttitle','volume','issue','pages','lang','nlmuniqueid','issn','essn','pubtype','recordstatus','pubstatus','articleids','history','references','attributes','pmcrefcount','fulljournalname','elocationid','doctype','srccontriblist','booktitle','medium','edition','publisherlocation','publishername','srcdate','reportnumber','availablefromurl','locationlabel','doccontriblist','docdate','bookname','chapter','sortpubdate','sortfirstauthor','vernaculartitle')

motion_pubs$entrez[[1]] |> extract_from_esummary(esummaries = _, elements = entrez_categories) |> bind_cols()

tibble(entrez_names = entrez_categories) |> 
  mutate(entrez_dat  = map(.x = motion_pubs$entrez, .f = ~ list(rentrez::extract_from_esummary(.x, entrez_names))))


motion_pubs |> 
  mutate(entrez_tib = map_df(.x = entrez_categories, .f = ~ pluck(entrez, .x)))
  mutate(entrez_tib = map(.x = entrez, .f = ~ as_tibble(.x))) |> 
  unnest(cols = c(entrez_tib))


