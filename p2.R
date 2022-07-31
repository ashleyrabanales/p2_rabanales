library(tidyverse)
library(dplyr)
library(tidyr)
library(magritter)
library(ggplot2)


pacman::p_load(ggfittext, waffle, tidyverse, hrbrthemes)

guns <- read_csv("https://github.com/fivethirtyeight/guns-data/raw/master/full_data.csv") %>%
  mutate(month_number = as.numeric(month))

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

guns <- guns %>%
  mutate(age_group = case_when(
    age < 18 ~ "young",
    age >= 18 & age < 60 ~ "adult",
    TRUE ~ "elder")
  )
  
guns_counts <- guns %>%
  dplyr::count(race, year, age_group, month, intent)

  #long code
  guns
    group_by(race, year)
  summarise(n = n())
  #ungroup() <- find similar code?
  
  #short code
  guns_coun <- guns 
  count(race, year)
  
  guns_count %>%
    left_join(dat_pop, by = "race")

guns <- group_by(suicide, sex, year, month)
delay <- summarise(guns,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE)
)

data <- guns_counts_pop %>%
  filter(intent != "NA")

data %>%
  dplyr::mutate(age_group = fct_relevel(age_group,
                                        "young", "adult", "elder")) %>%
  ggplot(aes(x = month, y = n, color = race)) +
  geom_point(size = 1) +
  facet_grid(age_group ~ intent)  +
  theme_bw() +
  labs(
    title = "Gun Death Rates",
    caption = "Data from FiveThirtyEight.",
    tag = "Figure 1",
    x = "Month",
    y = "Count",
    colour = "Race") +
  scale_color_brewer(palette = "Set1")

ggsave(file = "gun_visualizationR.png", width = 15, height = 7)
#line graph





#######GRAPH 1 - line graph age group by months in years
#group the months by year 
#group the age group by 0-17, 18-24, 25-44,  65+, *new variables/*
summary(guns)
#create new variable "age"
guns$growth[guns$age < 17] < -"0-17"
guns$growth[guns$age >= 18 & guns$age <=24]<-"18-24"
guns$growth[guns$age >=25 & guns$age<=44]<-"25-44"
guns$growth[guns$age >=45 & guns$age<=64]<-"45-64"
guns$growth[guns$age >65]<-"65+"
guns  #Check to see if it appears


###Fixing the order###
whatever <- ordered(guns$growth, c( "0-17", "18-24", "25-44", "45-64","65" )) #order the categorical vari
table(whatever) #Will reorder

guns_20 <- guns %>%
  filter(intent == "Suicide") %>%
  mutate(growth = case_when(
    #create new variable "age"
    age <= 17 ~ "0-17",
    age <= 24  ~ "18-24",
    age <= 44 ~ "25-44",
    age <= 64 ~ "45-64",
    age >= 65 ~"65+"
  )) %>%
  na.omit(growth) %>%
  group_by( growth, year,  month) %>%
  summarize(suicides = n()) 

guns_20 %>%
ggplot(aes(x = as.numeric(month), y = suicides)) +
  geom_line(aes(color = growth))  +
  geom_point(aes(color = growth))  +
  labs(x = "Months",
       y = "Number of suicides",
       title ="Suicide Rates by Month",
       subtitle = "Suicides By Race, Gender, and Age, 2012-2014",
       color = "Age Group") +
  facet_wrap(~year , nrow = 1) +
  scale_x_continuous(breaks = seq(2, 12, by = 2)) +
  theme_bw()

ggsave(filename = "SuicidesRates_by_AgeR.png", width = 15, height = 7)

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

  
######GRAPH-2 SIDE BY SIDE BARCHART######
#######SUICIDES BY RACE, GENDER, AGE######
 
guns_all <-
  guns%>%
  filter(intent == "Suicide")%>%
  group_by(race,age,sex)%>%
  summarize(suicides = length(year))
guns_all$sex <- factor(guns_all$sex, levels = c("F", "M"),
                       labels = c("Female", "Male"))
  #Then:
  guns_all%>%
    ggplot(aes(x = age, y = suicides/10)) +
    geom_line(aes(color = race)) +
    labs(x = "Age",
         y = "Suicides",
         title = "Death by Suicide", color = "Race/Enthnicity",
         subtitle = "Suicides By Race,Enthnicity, and Age, 2012-2014", ) +
    facet_wrap(~sex, nrow = 1) +    
    theme(strip.text.y = element_text(
      size = 15, face = "bold.italic"
    ))
    theme_bw()
    
ggsave(filename = "Suicides_by_raceR.png", width = 15, height = 7)
  
# In Graph 2 is a line graph visual with the numbers of suicides by race,ethnicity,and age 
#from the year 2012-2014, separate by gender. As we can see White males and females
#have higher numbers of suicides, leading next to Blacks and Hispanics, and last
#to be Native American/Native Alaskan and Asian/Pacific Islander. Males to have a 
#higher rate of suicides than females.




#graph 3 - stack bar chart
guns_bar <- guns %>%
      filter(intent == "Homicide", "Suicide", "Accidental") %>%
      group_by( age, year,  month) %>%
      summarize(suicides = n()) %>%
  
#Then:
  guns_bar
    ggplot(aes(y = age, x = intent)) +
      geom_bar(stat = "intent")
  guns
      ggplot(aes(x = intent)) +
      geom_bar(aes(color = race)) +
      labs(x = "Age",
           y = "Intent",
           title = "Death by Intent", color = "Age",
           subtitle = "Intent By Race/Enthicity, and Gender. 2012-2014", ) +
      facet_wrap(~race, nrow = 1) +    
      theme(strip.text.y = element_text(
        size = 12, face = "bold.italic"
      ))
    theme_bw()

 

  

  