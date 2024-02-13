## DATA 101
## WEEK 1: VISUALIZATION LECTURE

library(tidyverse)
mpg
?mpg
##producing a scatterplot of cylinder # vs. hwy MPG
ggplot(data=mpg)+
  geom_point(mapping = aes(x=displ, y=hwy))
##scatterplot of cylinder # vs. city MPG
ggplot(data=mpg)+
  geom_point(mapping = aes(x=displ, y=cty))]
##introducing color assigned to class of vehicle (compact, subcompact, etc)
ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ, y=hwy, color=class))
##introducing shapes assigned to class of vehicle
ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ, y=hwy, shape=class))
##facet = subplots
##used to visualize the relationship between two variables across a 3rd variable
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 3) 
##
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ, y=hwy)) +
  facet_wrap(~ year, nrow = 3)
##CHANGING GRAPH TYPE: line graph
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))
##Changing aesthetics of line graphs
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = as.factor(year))
##COMBINING GRAPH TYPES (LINE AND SCATTER)
ggplot(data = mpg) +
  geom_point(mapping= aes (x=displ, y=hwy)) +
  geom_smooth(mapping= aes (x=displ, y=hwy))
##more efficient way of coding for combined graph types
ggplot(data = mpg, mapping=aes(x=displ, y=hwy)) +
  geom_smooth() +
  geom_point()
##it's beneficial to write the code with separate mappings to different geoms if you change the aesthetics of only one
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class)) +
  geom_smooth()
##BOX PLOTS
ggplot(data=mpg) +
  geom_boxplot(mapping=aes(x=class,y=hwy))
##flip the grid for ease of reading
ggplot(data=mpg) +
  geom_boxplot(mapping=aes(x=class,y=hwy)) + coord_flip()

##SINGLE VARIABLE GRAPHS (BAR CHARTS)
ggplot(data=mpg) +
  geom_bar(mapping=aes(x=class)) 
ggplot(data=mpg) +
  geom_bar(mapping=aes(y=class))
##overriding R's assumption and writing in that you want
## the proportion of cars in bar form
##group = 1 refers to treating all cars as cars
ggplot(data = mpg) +
  geom_bar(mapping = aes(x = class, y = ..prop.., group = 1))
#adding color to bar graphs
ggplot(data=mpg) +
  geom_bar(mapping=aes(x=class, fill=class))
##plotting how the number of cars in each class differed by year
##single bar, broken by color
ggplot(data=mpg) +
  geom_bar(mapping=aes(x=class, fill=as.factor(year)), position = "fill")
##multiple bars, differing in color
ggplot(data=mpg) +
  geom_bar(mapping=aes(x=class, fill=as.factor(year)),
           position = "dodge")
