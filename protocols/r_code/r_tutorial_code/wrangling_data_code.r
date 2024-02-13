## DATA 101
## WEEK 1: VISUALIZATION LECTURE

library(nycflights13)
library(tidyverse)
flights

##this dataset is really big. 
##you can open up all rows and variables with this command:
View(flights)

##FILTER: select observations by their values
##if you want to find flights that left on december 1st:

filter(flights,month==12,day==1)
dplyr::filter(flights, month==12, day==1)

##if you want to save this output for future analyses, 
##you can assign it to an object in R

Dec1 <- filter(flights, month==12, day==1)

##how would you find every flight delayed by more than 30min?

filter(flights, dep_delay>30)

##how would you find every flight with carrier United Airlines?

filter(flights,carrier=="UA")

##ARRANGE: reorders observations

arrange(flights, year, month, day)

##how to sort in DESCENDING order:

arrange(flights, desc(dep_delay))

##how would you find the flight that was in the air for the 
##longest? how would you find the flight that was in the air
##for the shortest amount of time?

arrange(flights, desc(air_time))

##SELECT: picks variables; if you only want to see certain columns

select(flights,month,day)
##everything EXCEPT a certain variable:
select(flights,-dep_time)

select(flights,starts_with("sch"))

##start with a certain variable:
select(flights,air_time, everything())

united <- filter(flights, carrier=="UA")
select(united,carrier,everything())

##renaming variables

rename(flights,sched_dep=sched_dep_time)

##quiz: how would you make a dataset without either
##actual or scheduled departure time?

select(flights,-dep_time,-sched_dep_time)
##or
select(flights,-c(dep_time,sched_dep_time))

##MUTATE: makes new variables as functions of existing variables

flights_sml <- select(flights, year:day,ends_with("delay"),distance,air_time)
flights_sml

mutate(flights_sml,speed=distance/air_time*60)

##transmute will replace the old variables with the new variable

##MODULAR ARITHMETIC
##split departure time into hours AND minutes 
transmute(flights,dep_time,hour=dep_time%/%100,minute=dep_time%/%100)

##quiz: how would you change departure time into a variable 
##that records the number of minutes elapsed since midnight?

transmute(flights,dep_time,hour=dep_time%/%100,minute=dep_time%%100,(elapsed_time=(hour*60)+minute)

          
##SUMMARISE: collapses variables down to a single summary
##if you wanted to find the mean of all flight delays:
summarise(flights,delay=mean(dep_delay,na.rm=TRUE))
##where na.rm allows R to ignore values of NA (no value)

##group data by a specific variable
by_day <- group_by(flights,year,month,day)
summarise(by_day,delay=mean(dep_delay,na.rm=TRUE))

##quiz: which month has the longest average departure delay?
##which has the shortest?

by_month <- group_by(flights,month)
summarise(by_month, delay=mean(dep_delay,na.rm=TRUE))

##USING THE PIPE

##1.group flights by destination
##2.use the grouped data to calculate distance and average delay
##3.then plot using ggplot

by_dest <- group_by(flights,dest)
delay <- summarise(by_dest,count=n(),dist=mean(distance,na.rm=TRUE),delay=mean(arr_delay,na.rm=TRUE))

ggplot(data =delay, mapping =aes(x =dist, y =delay)) +geom_point(aes(size =count), alpha =1/3) +geom_smooth(se =FALSE)

##tidy up that plot

delay <-filter(delay,count>20,dest!="HNL")
ggplot(data=delay,mapping=aes(x=dist,y=delay))+geom_point(aes(size=count),alpha=1/3)+geom_smooth(se=FALSE)

##another way to do this, using the PIPE

delays <-flights %>%
  group_by(dest)%>%
  summarise(
    count=n(),
    dist=mean(distance,na.rm=TRUE)
    delay=mean(arr_delay,na.rm=TRUE)
  )%>%
  filter(count>20, dest!="HNL")
  )

##quiz: calculate the average arrival delay by carrier using the pipe

flights %>%
  group_by(carrier) %>%
  summarise(count=n())

##EXPLORING MISSING DATA
##na.rm=TRUE

not_cancelled <- flights%>%
  filter(!is.na(dep_delay),!is.na(arr_delay))

delays <- not_cancelled %>%
  group_by(tailnum)%>%
  summarise(delay=mean(arr_delay))

