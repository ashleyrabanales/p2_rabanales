# This code parses data from the CDC's Multiple Cause of Death datafile for FiveThirtyEight's 
# "Gun Death in America" project.
# This code produces clean dataframes of firearm deaths and suicides (firearm and non-firearm).
# Code to further process this data for our interactive graphic can be found in the 'interactive_prep.R' file
# elsewhere in this repo.

# Questions/comments/corrections to ben.casselman@fivethirtyeight.com

# All data is from the CDC's Multiple Cause of Death datafile.
# Data: http://www.cdc.gov/nchs/data_access/VitalStatsOnline.htm#Mortality_Multiple
# Codebook: http://www.cdc.gov/nchs/data/dvs/Record_Layout_2014.pdf

# Most of these calculations can be checked through CDC's two web tools:
# Wonder search: http://wonder.cdc.gov/controller/datarequest/D76
# WISQARS search: http://webappa.cdc.gov/sasweb/ncipc/mortrate10_us.html (1999-2014)

library(readr)
library(tidyverse)
library(magrittr)

source("_functions.R")

# Enter year and url (urls are inconsistent, so easier to enter them directly)
year <- 2013
url <- "ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2013us.zip"

# Now run the function for each year you want:
CDC_parser(year, url)


#########################################################################################################################

# The code below processes the data for FiveThirtyEight's Gun Deaths in America project

# For the project, we used the three most recent years available: 2012-14
# We'll combine these into a single data frame.
# In keeping with CDC practice, we'll eliminate deaths of non-U.S. residents

load("gun_deaths_14.RData")
load("gun_deaths_13.RData")
load("gun_deaths_12.RData")

all_guns <- rbind(guns_12, guns_13, guns_14)
all_guns <- all_guns %>%
  filter(res_status != 4)

# Create new categorical variables for place of injury, educational status, and race/ethnicity.
# For race/ethnicity, we used five non-overlapping categories: 
# Hispanic, non-Hispanic white, non-Hispanic black, non-Hispanic Asian/Pacific Islander, non-Hispanic Native American/Native Alaskan

all_guns <- all_guns %>%
  mutate(place = factor(injury_place, labels = c("Home", "Residential institution", "School/instiution", "Sports", "Street", 
                                                 "Trade/service area", "Industrial/construction", "Farm", "Other specified", 
                                                 "Other unspecified")),
         education = ifelse(education_flag == 1, 
                            cut(as.numeric(education_03), breaks = c(0, 2, 3, 5, 8, 9)),
                            cut(as.numeric(education_89), breaks = c(0, 11, 12, 15, 17, 99))),
         education = factor(education, labels = c("Less than HS", "HS/GED", "Some college", "BA+", NA)),
         race = ifelse(hispanic > 199 & hispanic <996, "Hispanic",
                       ifelse(race == "01", "White",
                              ifelse(race == "02", "Black",
                                     ifelse(as.numeric(race) >= 4 & as.numeric(race) <= 78, "Asian/Pacific Islander","Native American/Native Alaskan")))),
         race = ifelse(is.na(race), "Unknown", race)) %>%
  select(year, month, intent, police, sex, age, race, hispanic, place, education)

# This is the main data frame FiveThirtyEight used in its analysis.
# For example:
# Gun suicides by year:
all_guns %>%
  filter(intent == "Suicide") %>%
  group_by(year) %>%
  summarize(suicides = length(year))

# Gun homicides of young men (15-34) by year:
all_guns %>%
  filter(intent == "Homicide", age >= 15, age < 35, sex == "M") %>%
  group_by(year) %>%
  summarize(homicides = length(year))

save(all_guns, file = "all_guns.RData")
write.csv(all_guns, file = "full_data.csv")
© 2021 GitHub, Inc.
Terms
Privacy
Security
Status
Docs
Contact GitHub
Pricing
API
Training
Blog
About
