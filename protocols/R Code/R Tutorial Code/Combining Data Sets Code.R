## DATA 101
## Wk 4 Combining Data Sets Lecture Code

library(tidyverse)
library(nycflights13)


## Keys = variables that allow us to uniquely identify a given observation
## Keys will allow you to combine information in different datasets

?flights
?planes
## ask yourself what is in both datasets?
##tailnum!

## three types of matches
## 1. one-to-one matches
## 2. one-to-many matches <- most common
## 3. many-to-many matches

## example
## join the flights dataset with airlines data set in order to 
## incorporate full airline names into the flights data

flights2<-flights%>%
  select(year:day, hour, origin, dest, tailnum, carrier)

flights2%>%
  left_join(airlines, by="carrier")

## where "carrier" is our key

##-----------------------------##

##inner_join(x,y)   keeps values that both x and y have in common
##left_join(x,y)    keeps all values in x
##right_join(x,y)   keeps all values in y
##full_join(x,y)    keeps all observations

x%>%
  full_join(y,by="key")

##-----------------------------##

## quiz: how can you combine flights and planes to see if larger
## planes were more subject to departure delays?

flights3<-flights%>%
  select(origin, dest, tailnum, carrier, dep_delay)

flights3%>%
  left_join(planes, by="tailnum")%>%
  select(carrier, seats, dep_delay)%>%
  arrange(seats)

## gets list

##to make plot:
flights%>%
  left_join(planes,by="tailnum")%>%
  filter(!is.na(dep_delay))%>%
  group_by(seats)%>%
  summarise(avg_delay=mean(dep_delay))%>%
  ggplot(aes(x=seats,y=avg_delay))+
  geom_point()+
  geom_smooth()

# how many planes with > 400 seats?
arrange(planes, desc(seats))
 ## only one!

##drop this observation

flights%>%
  left_join(planes,by="tailnum")%>%
  filter(!is.na(dep_delay)& seats<401)%>%
  group_by(seats)%>%
  summarise(avg_delay=mean(dep_delay))%>%
  ggplot(aes(x=seats,y=avg_delay))+
  geom_point()+
  geom_smooth()

## Joining with Filtered Data ##

## suppose you want to find the most popular destinations from
## NYC airports in 2013

top5 <- flights%>%
  count(dest,sort=T)%>%
  head(5)

## now suppose you want to see all the flights to these 
## five destinations and no others

# to do this, you would use semi_join

flights%>%
  semi_join(top5)

## whats the difference between semi_join and inner_join?
## a semi_join differs from an inner_join because an inner_join
## will return one row of X for each matching row of Y, where a 
## semi_join will never duplicate rows of X (R help file).

##semi_join is what you use when you've filtered down your data

## anti_join = keeps the rows that don't have a match
## useful in trying to find errors

flights%>%
  anti_join(planes,by="tailnum")%>%
  count(tailnum, sort=T)

flights%>%
  anti_join(planes,by="tailnum")%>%
  count(tailnum, sort=T)%>%
  filter(.,is.na(tailnum))%>%
  count(carrier)


## quiz: how would you find all flights flown by planes that
## flew at least 50 flights in 2013?

flights%>%
  group_by(tailnum)%>%
  count()%>%
  filter(n>49)%>%
  arrange(n)


#correct answer:

flew50<-flights%>%
  group_by(tailnum)%>%
  count()%>%
  filter(n>49)

flights%>%
  semi_join(flew50)



