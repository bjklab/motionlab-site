## Week 5 Lecture Code 

## Basic Syntax of the READR library

library(tidyverse)
library(tidyr)
getwd()

## Importing .csv data from a local folder
setwd("C:/Users/Owner/Dropbox/DATA101/DATA/RAW")
grads<-read_csv(file="C:/Users/Owner/Dropbox/DATA101/DATA/RAW/recent-grads.csv")

View(grads)

select(grads,Median,everything())%>%
  arrange(desc(Median))

## Importing .csv data from a URL
grads2<-read_csv("http://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2018/2018-10-16/recent-grads.csv")

## Syntax of the READXL library

library(readxl)
excel_example<-readxl_example("datasets.xls")
read_excel(excel_example)

## this function will by default only read the first worksheet if there are several
## to find if there are multiple sheets, use:
excel_sheets(excel_example)
## this dataset has 4 sheets, "iris" "mtcars" "chickwts" "quakes"
## you can open a specific sheet by referring to its number/name
## load the QUAKES data spreadsheet:

read_excel(excel_example,sheet="quakes")
## or 
read_excel(excel_example,sheet=4)


####################################
## TIDYING DATA

## G A T H E R 

gdp<-read_csv(file="C:/Users/Owner/Dropbox/DATA101/DATA/RAW/wb_gdp.csv")

gdp%>%
  gather(key=year,value=GDP,c('1990':'2017'))

pew<-read_csv(file="C:/Users/Owner/Dropbox/DATA101/DATA/RAW/pew.csv")

pew%>%
  gather(key=education,value=fraction,c(HSLess,SomeCollege,College,PostGrad))

## S P R E A D 

install.packages("DSR")
library(DSR)

## S E P A R A T E

tb<-read_csv(file="C:/Users/Owner/Dropbox/DATA101/DATA/RAW/tb.csv")
tb2<-tb%>%
  gather(demo,n,c(-iso2,-year))

tb3<-tb2%>%
  separate(col=demo,into=c("sex","age"),sep=1)

## U N I T E 





