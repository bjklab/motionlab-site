#' load libraries and set seed
library(tidyverse)

set.seed(16)


#' read and rewrite index.html file to correct {postcards} 'onofre' template defaults
read_lines("docs/index.html") |>
  enframe() |> 
  mutate(value = stringr::str_replace(string = value, pattern = ' class="rounded-circle">', replacement = ">"),
         value = stringr::str_replace(string = value, pattern = 'style="height:12rem"', replacement = 'style="height:18rem"'),
         value = stringr::str_replace(string = value, pattern = "'Open Sans'", replacement = 'Roboto'),
         value = stringr::str_replace(string = value, pattern = 'color:white; border-color: white;', replacement = 'color:black; border-color:black;')) |> 
  #stringr::str_replace(string = _, pattern = "#0F2E3D", replacement = "#932667") |> 
  #' remove unused onofre template title div
  mutate(flag_bad_div = (value == '          <div class="pl-5 py-1">' & lead(value,1) == '            <h1></h1>') | (value == '            <h1></h1>' & lag(value,1) == '          <div class="pl-5 py-1">') | (value == '          </div>' & lag(value,1) == '            <h1></h1>' & lag(value,2) == '          <div class="pl-5 py-1">')) |> 
  #' remove unused onofre template horizontal line div
  mutate(flag_bad_div = replace(flag_bad_div, (value == '          <div class="pl-5 py-3">' & lead(value,1) == '            <div style="border: thin solid lightgray; width: 100px;"></div>') | (value == '            <div style="border: thin solid lightgray; width: 100px;"></div>' & lag(value,1) == '          <div class="pl-5 py-3">') | (value == '          </div>' & lag(value,1) == '            <div style="border: thin solid lightgray; width: 100px;"></div>' & lag(value,2) == '          <div class="pl-5 py-3">'), TRUE)) |> 
  filter(flag_bad_div == FALSE) |>
  #' change forced onofre font color
  mutate(onofre_font_color = grepl("color", value) & grepl("linear-gradient", lag(value,1))) |> 
  mutate(value = replace(value, onofre_font_color == TRUE, '        color: black;')) |> 
  pull(value) |> 
  write_lines("docs/index.html")

