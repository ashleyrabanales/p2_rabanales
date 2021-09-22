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
 mutate(age_group = case(when(
  age < 18 ~ "young",
  TRUE ~ old)))
  
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
  
  
  