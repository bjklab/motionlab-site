## Week 6 Lecture Code
## Map Making

install.packages("maps")
install.packages("mapdata")
library(tidyverse)
library(maps)
library(mapdata)

usa<-map_data("usa")
head(usa)

## how to draw the plot

ggplot()+
  geom_polygon(data=usa,aes(x=long,y=lat,group=group))+
  coord_quickmap

##by default, your polygon will be filled. If you want it to
## not be filled, use:

ggplot()+
  geom_polygon(data=usa,aes(x=long,y=lat,group=group),fill=NA,color="black")+
  coord_quickmap()

## the color parameter is for the outline, because without it, 
## this code would produce a blank map 

ggplot()+
  geom_polygon(data=usa, aes(x=long,y=lat,group=group))+
  coord_quickmap()+
  theme_void()


## Try a map of FRANCE

france<-map_data("france")
ggplot()+
  geom_polygon(data=france,aes(x=long,y=lat,group=group))+
  coord_quickmap()


## for a list of countries and other geographic entities
# in this package, run this code:

options(max.print=2000)
maps::map("world",namesonly=TRUE,plot=FALSE)

## you can also draw maps of states and counties within the US

states<-map_data("state")

ggplot(data=states)+
  geom_polygon(aes(x=long,y=lat,group=group),col="white",lwd=0.15)+
  coord_quickmap()

## you can filter for certain states

west_coast<-filter(states,region%in%
                     c("california","oregon","washington"))

ggplot()+
  geom_polygon(data=west_coast,aes(x=long,y=lat,group=group))+
  coord_quickmap()

## you can differentiate by county:

counties<-map_data("county")

ggplot(data=counties)+
  geom_polygon(aes(x=long,y=lat,group=group))+
  coord_quickmap()

## but this doesn't allow you to see county boundaries 

ggplot()+
  geom_polygon(data=counties,aes(x=long,y=lat,group=group))+
  geom_polygon(data=states,aes(x=long,y=lat,group=group),fill=NA,col="white",lwd=0.15)+
  coord_quickmap()

ggplot(data=counties,aes(long,lat,group=group))+
  geom_polygon(aes(fill=region))+
  theme(legend.position="none")+
  coord_quickmap()

## makes weird colors rather than state lines

## QUIZ: How would you draw a county level map of PA?

pa_counties<-filter(counties,region=="pennsylvania")

ggplot()+
  geom_polygon(data=pa_counties,aes(x=long,y=lat,group=group),fill="black",col="white",lwd=0.15)+
  coord_quickmap()

## you can then combine the maps data with other data sets, such as census data

data(county.fips)
head(county.fips)


## match and join variables for county and state between the maps
## and the fips datasets

county_with_fips<-counties%>%
  mutate(polyname=paste(region,subregion,sep=","))%>%
  left_join(county.fips,by="polyname")

head(county_with_fips)
