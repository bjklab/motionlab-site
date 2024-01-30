#' load libraries and set seed
library(tidyverse)

set.seed(16)


#' read and rewrite index.html file to correct {postcards} 'onofre' template defaults
read_lines("docs/index.html") |>
  enframe() |> 
  #' remove title div from standard distill page format
  mutate(flag_bad_div = replace(flag_bad_div, (value == '<div class="d-title">' & lead(value,1) == '<h1>index.knit</h1>') | (value == '<h1>index.knit</h1>' & lag(value,1) == '<div class="d-title">') | , TRUE)) |> 
  filter(flag_bad_div == FALSE) |>
  pull(value) |> 
  write_lines("docs/index.html")

distill::distill_website()