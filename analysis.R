library(tidyverse)
library(dplyr)
library(tidyr)
library(ggplot)


httpgd::hgd()
httpgd::hgd_browse()

dat <- read_csv("https://github.com/fivethirtyeight/guns-data/raw/master/full_data.csv") %>%
#%%

dat_counts <- dat %>%
    count(race, year)
#' Used this information to build the values.
# https://www.census.gov/quickfacts/fact/table/US/POP010220
dat_pop <- tibble(
    table_var = c("Asian/Pacific Islander",  
        "Black",  "Hispanic",  
        "Native American/Native Alaskan",  "White"), 
    N =  331449281 *c(.061, .134, .185, .013, .763))

#' Used this information to build the values.

dat <- dat
    mutate(age_group =case(when(
        age < 18 ~ "young",
        TRUE ~ old
    ))

#long code
dat %>%
    group_by(race, year)
    summarise(n = n())
    ungroup()

#short code
dat_counts <- dat  
    count(race, year)

dat_count %>%
    left_join(dat_pop, by = "race")