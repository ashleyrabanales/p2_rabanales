# Function for downloading and parsing data:
CDC_parser <- function(year, url, folder_path) {
  
  # Set up files
  all_deaths_name <- paste0("deaths_", substr(year, 3, 4))
  all_deaths_save <- paste0("all_deaths_", substr(year, 3, 4), ".RData")
  gun_name <- paste0("guns_", substr(year, 3, 4))
  gun_save <- paste0("gun_deaths_", substr(year, 3, 4), ".RData")
  suicide_name <- paste0("suicide_", substr(year, 3, 4))
  suicide_save <- paste0("suicide_", substr(year, 3, 4), ".RData")
  
  # First download data. These are fixed-width files.
  # Layout for recent years (need tweaks for earlier year)
  layout <- fwf_widths(c(19,1,40,2,1,1,2,2,1,4,1,2,2,2,2,1,1,1,16,4,1,1,1,1,34,1,1,4,3,1,3,3,2,1,281,1,2,1,1,1,1,33,3,1,1),
                       col_names = c("drop1", "res_status", "drop2", "education_89", "education_03", "education_flag", "month", 
                                     "drop3", "sex", "detail_age", "age_flag", "age_recode", "age_recode2", "age_group", 
                                     "age_infant", "death_place", "marital", "day_of_week", "drop4", "data_year", "at_work", 
                                     "death_manner", "burial", "autopsy", "drop5", "activity", "injury_place", 
                                     "underlying_cause", "cause_recode358", "drop6", "cause_recode113", "cause_recode130", 
                                     "cause_recode39", "drop7", "multiple_causes", "drop8", "race", "race_bridged", "race_flag", 
                                     "race_recode", "race_recode2", "drop9", "hispanic", "drop10", "hispanic_recode"))
  
  temp <- tempfile()
  download.file(url, temp, quiet = T)
  
  # Read in data
  raw_file <- read_fwf(unzip(temp), layout)
  
  # Drop empty fields
  raw_file <- raw_file %>%
    select(-contains("drop"))

  # Save 'all_deaths' file
  assign(eval(all_deaths_name), raw_file)
  save(list = all_deaths_name, file = all_deaths_save)
  
  # Subset suicides
  # Suicide codes: X60 - X 84, U03, Y870
  
  suicide_code <- list()
  for (i in 1:24) {
    suicide_code[[i]] <- paste0("X", i + 59)
  }
  suicide_code[length(suicide_code)+1] <- "U03"
  suicide_code[length(suicide_code)+1] <- "Y870"
  
  # Gun suicides
  # X72 (Intentional self-harm by handgun discharge)
  # X73 (Intentional self-harm by rifle, shotgun and larger firearm discharge)
  # X74 (Intentional self-harm by other and unspecified firearm discharge)
  
  suicide <- raw_file %>%
    filter(underlying_cause %in% suicide_code) %>%
    mutate(gun = ifelse(underlying_cause %in% c("X72", "X73", "X74"), 1, 0),
           year = year)  
  
  assign(eval(suicide_name), suicide)
  save(list = suicide_name, file = suicide_save)
  rm(suicide)
  rm(list = suicide_name)
  
  # Subset firearm deaths
  
  # Firearm death codes
  # Accidental:
  # W32 (Handgun discharge)
  # W33 (Rifle, shotgun and larger firearm discharge)
  # W34 (Discharge from other and unspecified firearms)
  # 
  # Suicide:
  # X72 (Intentional self-harm by handgun discharge)
  # X73 (Intentional self-harm by rifle, shotgun and larger firearm discharge)
  # X74 (Intentional self-harm by other and unspecified firearm discharge)
  # 
  # Homicide:
  # U01.4 (Terrorism involving firearms)
  # X93 (Assault by handgun discharge)
  # X94 (Assault by rifle, shotgun and larger firearm discharge)
  # X95 (Assault by other and unspecified firearm discharge)
  # 
  # Undetermined intent:
  # Y22 (Handgun discharge, undetermined intent)
  # Y23 (Rifle, shotgun and larger firearm discharge, undetermined intent)
  # Y24 (Other and unspecified firearm discharge, undetermined intent)
  # 
  # Legal intervention (Note that we code legal intervention deaths as homicides)
  # Y35.0 (Legal intervention involving firearm discharge)
  
  guns <- raw_file %>%
    filter(underlying_cause %in% c("W32", "W33", "W34", "X72", "X73", "X74", "U014", "X93", "X94", "X95", "Y22", "Y23", "Y24", "Y350"))
  
  rm(raw_file)
  
  # Add categorical variable for intent, weapon, plus dummy for police shootings
  guns <- guns %>%
    mutate(intent = ifelse(underlying_cause %in% c("W32", "W33", "W34"), "Accidental",
                           ifelse(underlying_cause %in% c("X72", "X73", "X74"), "Suicide",
                                  ifelse(underlying_cause %in% c("*U01.4", "X93", "X94", "X95", "Y350"), "Homicide",
                                         ifelse(underlying_cause %in% c("Y22", "Y23", "Y24"), "Undetermined", NA)))),
           police = ifelse(underlying_cause == "Y350", 1, 0),
           weapon = ifelse(underlying_cause %in% c("W32", "X72", "X93", "Y22"), "Handgun",
                           ifelse(underlying_cause %in% c("W33", "X73", "X94", "Y23"), "Rifle etc",
                                  "Other/unknown")),
           year = year) # Dummy for young men (15-34)
  
  # Create a cleaner age variable. Every age under 1 year will be coded as "0"
  guns <- guns %>%
    mutate(age = ifelse(substr(detail_age, 1, 1) == "1", as.numeric(substr(detail_age, 2, 4)), # Year
                        ifelse(detail_age == 9999, NA, 0)),
           age = ifelse(age == 999, NA, age))
  
  assign(eval(gun_name), guns)
  save(list = gun_name, file = gun_save)
  rm(guns)
  rm(list = gun_name)
  
}
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