#The FiveThirtyEight data is a bit old, and our client would like us to use the
#most recent data from the CDC. He would also like the parser script to use 
#Python instead of R.

#While their visualizations focused on yearly averages, our client wants to create
#commercials that help reduce gun deaths in the US. They would like to target the 
#commercials in different seasons of the year (think month variable) to audiences 
#that could significantly reduce gun deaths. Our challenge is to summarize and 
#visualize seasonal trends across the other variables in these data.

# The goals:
  ####PYTHON TRANSLATION
#1. Translate FiveThirtyEight's CDC_parser.R script into a Python script.
#2.  Verify that your output matches their results.
#3. Build new data sets that use data through 2019.
#Client needs (charts and munging done in Python and R)


#1. Provide a brief summary of the FiveThirtyEight article.
#   a.Create one plot that provides similar insight to their visualization in the article. It does not have to look like theirs.
#   b.Write a short paragraph summarizing their article.
#2. Address the client's need for emphasis areas of their commercials for different seasons of the year.
#   a. Provide plots that help them know the different potential groups (variables) they could address in different seasons (2-4 visualizations seem necessary).
#   b. Write a short paragraph describing each image.
library(tidyverse)
library(dplyr)
library(tidyr)
library(magritter)
library(ggplot2)
library()

httpgd::hgd()
httpgd::hgd_browse()

guns <- read_csv("https://github.com/fivethirtyeight/guns-data/raw/master/full_data.csv") 

guns_counts <- guns %>%
  count(race, year)
#' Used this information to build the values.
# https://www.census.gov/quickfacts/fact/table/US/POP010220
dat_pop <- tibble(
  table_var = c("Asian/Pacific Islander",  
                "Black",  "Hispanic",  
                "Native American/Native Alaskan",  "White"), 
  N =  331449281 *c(.061, .134, .185, .013, .763))

#' Used this information to build the values.

guns <- guns
 mutate(age_group = case_when(
  age < 18 ~ "young",
  TRUE ~ old))
  
  #long code
  guns
    group_by(race, year)
  summarise(n = n())
  #ungroup() <- find similar code?
  
  #short code
  dat_counts <- dat  
  count(race, year)
  
  dat_count %>%
    left_join(dat_pop, by = "race")
  
#What type of variation occurs within my variables?
#What type of covariation occurs between my variables?
#outliers? Significant? 
#is there a strong correlation between the variables?

guns <- group_by(suicide, sex, year, month)
delay <- summarise(guns,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE)
)


#######graph 1 - line graph age group by months in years
#group the months by year 
#group the age group by 0-17, 18-24, 25-44,  65+, *new variables/*
summary(guns)
#create new variable "age"
guns$growth[guns$age < 14] < -"0-14"
guns$growth[guns$age >= 15 & guns$age <=24]<-"15-24"
guns$growth[guns$age >=25 & guns$age<=34]<-"25-34"
guns$growth[guns$age >=35 & guns$age<=44]<-"35-44"
guns$growth[guns$age >=45 & guns$age<=54]<-"45-54"
guns$growth[guns$age >=55 & guns$age<=64]<-"55-64"
guns$growth[guns$age >65]<-"65+"
guns  #Check to see if it appears


###Fixing the order###
whatever <- ordered(guns$growth, c( "0-14", "15-24", "25-34", "35-44", "45-54","55-64", "65+")) #order the categorical vari
table(whatever) #Will reorder

guns_2 <- guns[guns$intent == "Suicide",]
guns_age_30 <- guns[guns$age > 30,] #EXAMPLE
  ##suicide rates by months, years.
guns_2 %>%
  filter(intent == "Suicide") %>%
  group_by(year) %>%
  summarize(suicides = length(year))
guns_2 %>%
drop_na(growth) 
ggplot(aes(x = month, y = age)) +
geom_line(aes(color = growth)) +
  labs(x = "Months",
       y = "Age",
       title ="Suicide Rates by Age: 2012-2014") +
  facet_wrap(~year, nrow = 1) +
  theme_bw()


drop_na(growth) 

ggplot(data = guns_2, aes(x = month, y = growth)) +
geom_bar(position = "dodge", 
         alpha = 0.5) +
facet_wrap(~years, nrow = 1) + 
      labs(title = "Suicide Rates by Age: 2012-2014",
           subtitle = "Suicides By White Men Peak in Middle Age", 
           x="Months ", y="Age", color = "Age") 

##brad help
df2<-
  guns%>%
  filter(intent == "Suicide")%>%
  group_by(race,age,sex)%>%
  summarize(suicides = length(year))
#Then:
  df2%>%
  ggplot(aes(x = age, y = suicides)) +
  geom_line(aes(color = sex)) +
  labs(x = "Age",
       y = "Suicides",
       title = "Suicides By Non-Whites Decline With Age",
       subtitle = "Suicides By White Men Peak in Middle Age") +
  facet_wrap(~race, scales = "free") +
  theme_bw()
  
#######
  
ggplot(data = guns, mapping = aes(x = month, y = age, color = growth)) +
    facet_wrap(~year, nrow = 1)  + 
    geom_line(data = guns_2, aes(race)) +  labs( x="Months ", y="Age") +
  labs(color = "Age") + ggtitle("Suicide Rates by Age: 2012-2014")

#graph 2 side by side bar graph
#between gender by race
 

ggplot(data = guns, mapping = aes(x = , colour = ()))

ggplot(data = guns, mapping = aes(y = year, x= race, colour = year)) +
  geom_bar(stat ="identity")

ggplot(data = guns, mapping = aes(x = intent, y = race)) + 
  geom_freqpoly(mapping = aes(colour = race), binwidth = 500)


#graph 3 - what month has the highest suicide during the year?


 
  



#> `geom_smooth()` using method = 'loess' and formula 'y ~ x'
  

  