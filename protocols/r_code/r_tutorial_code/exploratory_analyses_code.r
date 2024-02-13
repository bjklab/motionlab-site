## Week 3 - 

## Exploratory Data Analysis
## finding patterns in our data 

library(tidyverse)
summary(diamonds)
library(lubridate)

## Summary will give you a snapshot of the distribution of your variables

## make a plot of diamond price
ggplot(data=diamonds)+
  geom_histogram(aes(x=price))

## how many bins should you have?  (it defaulted to 30)

ggplot(data=diamonds)+
  geom_histogram(aes(x=price),bins=250)

## explore how the factors of a diamond affect its price
## Carats

ggplot(data=diamonds)+
  geom_histogram(aes(x=carat), bins=250)

## closer look at diamonds around 1 carat & GIVE ME ONLY 30 VALUES

diamonds%>%
  filter(carat>=0.89, carat <=1.1)%>%
  count(carat)%>%
  print(n=30)

## create the same tibble around the spike at 1.5 carats

diamonds%>%
  filter(carat>=1.3, carat <=1.8)%>%
  count(carat)%>%
  print(n=30)

## explore relationships between two variables 
## COVARIANCE = how do the two variables change together?

ggplot(diamonds)+
  geom_point(aes(x=carat,y=price))

##not linear

ggplot(diamonds)+
  geom_boxplot(aes(x=color,y=price))+
  coord_flip()

ggplot(diamonds)+
  geom_point(aes(x=carat,y=price,color=color,alpha=0.5))

ggplot(diamonds)+
       geom_bar(aes(x=cut))
  
ggplot(diamonds)+
  geom_boxplot(aes(x=cut,y=price))+
  coord_flip()

ggplot(diamonds)+
  geom_point(aes(x=carat,y=price, color=cut),alpha=0.5)

ggplot(diamonds)+
  geom_count(aes(x=cut,y=color))

## ___________
## flights data set exploratory analyses

library(nycflights13)
data(flights)
## calculate the average delay by day

flights%>%
  group_by(month,day)%>%
  summarise(avg_delay=mean(arr_delay),na.rm=T)%>%
  ungroup()%>%
  arrange(-avg_delay)%>%
  head(10)

  ##head(10) gives you first 10 results 

## condition on flights that are non-negative delays

flights%>%
  filter(arr_delay>=0)%>%
  group_by(month,day)%>%
  summarise(avg_delay=mean(arr_delay),na.rm=T)%>%
  ungroup()%>%
  arrange(-avg_delay)%>%
  head(10)

install.packages("lubridate")
library(lubridate)

flights%>%
  mutate(flight_day=make_datetime(year,month,day))%>%
  group_by(flight_day)%>%
  summarise(avg_delay=mean(arr_delay,na.rm=T))%>%
  ggplot(.,aes(x=flight_day,y=avg_delay))+
  geom_point()+
  geom_smooth()

## quiz: how would you look to examome whether the patterns we
## found here are different by originating airport?

flights%>%
  mutate(flight_day=make_datetime(year,month,day))%>%
  group_by(flight_day,origin)%>%
  summarise(avg_delay=mean(arr_delay,na.rm=T))%>%
  ggplot(.,aes(x=flight_day,y=avg_delay,color=origin))+
  geom_point()+
  geom_smooth()

## how would you edit this code to have only one trend line for 
## all three airports?

flights%>%
  mutate(flight_day=make_datetime(year,month,day))%>%
  group_by(flight_day,origin)%>%
  summarise(avg_delay=mean(arr_delay,na.rm=T))%>%
  ggplot(.,aes(x=flight_day,y=avg_delay))+
  geom_point(aes(color=origin))+
  geom_smooth()

## improve the presentation of our graphs

## CHANGE AXIS NAMES from variable names
## CHANGE TICK MARKS
## ADD A TITLE
## CHANGE BACKGROUND COLOR
## CHANGE LEGEND

library(scales)

flights%>%
  mutate(flight_day=make_datetime(year,month,day))%>%
  group_by(flight_day,origin)%>%
  summarise(avg_delay=mean(arr_delay,na.rm=T))%>%
  ggplot(.,aes(x=flight_day,y=avg_delay))+
  geom_point(aes(color=origin))+
  geom_smooth()+
  ylab("Average Arrival Delay (Minutes)")+
  xlab("")+
  scale_x_datetime(date_breaks="3 months",labels=date_format("%b"))+
  scale_y_continuous(breaks=c(0,30,60,90,120))+
  ggtitle("Average Daily Flight Delay by NYC Airport, 2013")+
  theme_bw()+
  theme(plot.title=element_text(hjust=0.5),legend.position="bottom")+
  scale_color_discrete(name="Originating Airport", labels=c("Newark","Kennedy","LaGuardia"))

  ## variables can either be discrete, continuous or datetime

## DATE_FORMATS
##  %b = abbreviated month
## %A = weekday names
## %a = abbreviated weekday names
## %B = month name
## %y = year without century 

##_____________________________##
##   CODE STYLE & R MARKDOWN
##_____________________________##

## always comment what your code does as you work for your future self!


