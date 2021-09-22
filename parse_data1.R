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
library(purrr)


source("_functions.R")

# Now run the function for each year you want:
parse_cdc (2013, "ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2013us.zip")
parse_cdc (2014, "ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2014us.zip")

#########################################################################################################################

# The code below processes the data for FiveThirtyEight's Gun Deaths in America project

# For the project, we used the three most recent years available: 2012-14
# We'll combine these into a single data frame.
# In keeping with CDC practice, we'll eliminate deaths of non-U.S. residents
rds_guns <- list.files("death_data", "guns", full.names = TRUE)

all_guns <- purrr::map(rds_guns, ~read_rds(.x)) %>%
  dplyr::bind_rows() %>%
  dplyr::filter(res_status != 4)

# Create new categorical variables for place of injury, educational status, and race/ethnicity.
# For race/ethnicity, we used five non-overlapping categories: 
# Hispanic, non-Hispanic white, non-Hispanic black, non-Hispanic Asian/Pacific Islander, non-Hispanic Native American/Native Alaskan

all_guns <- all_guns %>%
  mutate(
    place = factor(injury_place, 
                   labels = c("Home", "Residential institution", "School/instiution",
                              "Sports", "Street", "Trade/service area", "Industrial/construction",
                              "Farm", "Other specified", "Other unspecified")),
    education = ifelse(education_flag == 1,
                       cut(as.numeric(education_03), breaks = c(0, 2, 3, 5, 8, 9)),
                       cut(as.numeric(education_89), breaks = c(0, 11, 12, 15, 17, 99))) %>%
      factor(labels = c("Less than HS", "HS/GED", "Some college", "BA+", NA)),
    race = case_when(
      hispanic > 199 & hispanic < 996 ~ "Hispanic",
      race == "01" ~ "White",
      race == "02" ~ "Black",
      as.numeric(race) >= 4 & as.numeric(race) <= 78 ~ "Asian/Pacific Islander",
      is.na(race) ~ "Uknown",
      # I think this step matches their code.
      TRUE ~ "Native American/Native Alaskan")) %>% 
  select(year, month, intent, police, sex,
         age, race, hispanic, place, education)

# This is the main data frame FiveThirtyEight used in its analysis.
# For example:
# Gun suicides by year:
readr::write_rds(all_guns, "full_data.rds")
readr::write_csv(all_guns, "full_data.csv")
