#' #####################################
#' load libraries and set seed
#' #####################################
library(tidyverse)
library(gt)
library(gtExtras)

set.seed(16)


#' #####################################
#' curl DOIs to bibtex
#' #####################################
read_lines("pubs/doi.txt") |> 
  enframe(value = "doi") |> 
  select(doi) |> 
  mutate(url = paste0("https://doi.org/", doi)) |> 
  mutate(curl_query = paste0("curl -LH 'Accept: application/x-bibtex' ", url)) |> 
  mutate(bib = map(.x = curl_query, .f = ~ system(.x, intern = TRUE))) |> 
  identity() -> doi_tib
doi_tib

doi_tib$bib[[2]]

doi_tib |> 
  filter(grepl("not found", tolower(bib)) == FALSE) |>   
  pull(bib) |> 
  paste0(collapse = "\n \n") |> 
  write_lines(file = "pubs/doi.bib")

doi_tib |> 
  write_rds("pubs/doi.rds")


#' #####################################
#' put bibtex in tabular form & join with links
#' #####################################

doi_tib$bib[[2]]

doi_tib |> 
  # filter out missing bibtex
  filter(grepl("not found", tolower(bib)) == FALSE) |>   
  # format data for presentation
  mutate(year = stringr::str_match(string = bib, pattern = "year\\=\\{\\s*(.*?)\\s*\\}")[,2]) |> 
  mutate(authors = stringr::str_match(string = bib, pattern = "author\\=\\{\\s*(.*?)\\s*\\}")[,2]) |> 
  mutate(title = stringr::str_match(string = bib, pattern = "title\\=\\{\\s*(.*?)\\s*\\}")[,2]) |> 
  mutate(journal = stringr::str_match(string = bib, pattern = "journal\\=\\{\\s*(.*?)\\s*\\}")[,2]) |> 
  mutate(journal = replace(journal, is.na(journal), "preprint")) |> 
  mutate(publisher = stringr::str_match(string = bib, pattern = "publisher\\=\\{\\s*(.*?)\\s*\\}")[,2]) |> 
  mutate(url = stringr::str_match(string = bib, pattern = "year\\=\\{\\s*(.*?)\\s*\\}")[,2]) |> 
  mutate(journal = gsub("&amp;", "&", journal)) |> 
  mutate(authors = gsub(" and", ";", authors)) |> 
  arrange(desc(year), title) |> 
  rename_all(.funs = ~ stringr::str_to_title(.x)) |> 
  rename("DOI" = "Doi") |> 
  # add html links
  mutate(DOI = map(.x = DOI, .f = ~ htmltools::a(href = paste0("https://doi.org/", .x), .x)),
        DOI = map(.x = DOI, .f = ~ gt::html(as.character(.x)))) |> 
  identity() -> bib_tib
bib_tib

# bib_tib |> 
#   select(Year, Authors, Title, Journal, DOI) |> 
#   gt()
