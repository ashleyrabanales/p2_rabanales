#%%

import pandas as pd
import numpy as np
#%%
year = 2013
url = "ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2013us.zip"
#%%

l2 <- str(year)[2:] 
fnames <- ["deaths", "guns", "suicide"]
#%%
#leave for later the tibble of names
pd.DataFrame
#%%
format_widths = [19,1,40,2,1,1,2,2,1,4,1,2,2,2,2,1,1,1,16,4,
1,1,1,1,34,1,1,4,3,1,3,3,2,1,281,1,2,1,1,1,1,33,3,1,1]

format_names = ["drop1", "res_status", "drop2", "education_89", "education_03", "education_flag", "month", 
"drop3", "sex", "detail_age", "age_flag", "age_recode", "age_recode2", "age_group", 
"age_infant", "death_place", "marital", "day_of_week", "drop4", "data_year", "at_work", 
"death_manner", "burial", "autopsy", "drop5", "activity", "injury_place", 
"underlying_cause", "cause_recode358", "drop6", "cause_recode113", "cause_recode130", 
"cause_recode39", "drop7", "multiple_causes", "drop8", "race", "race_bridged", "race_flag", 
"race_recode", "race_recode2", "drop9", "hispanic", "drop10", "hispanic_recode"]
#%%
raw_file = pd.read_fwf("data/mort2013us.zip", nrows = 
1000, compression="zip", header=None, names = format_names,
widths = format_widths)


#%%

# Drop empty fields
drop_names = raw_file.filter(regex="drop").columns

raw_file.drop(drop_names, axis = 1)


#check to read all lines at the end
#using local files 

#%%
# suicide_code <- c(stringr::str_c("X", 60:84), "U03", "Y870")
suicide_code  = ["X" + str(i) for i in range (60, 84)] + ["U03", "Y870"]

#%%
raw_file.query('underlying_cause in @suicide_code').assign(
    gun =  lambda x:  np.where(x.underlying_cause).isin
    (['X72', 'X73', 'X74']), 1, 0),
    year = year
)

#ifelse similar to np.where 
suicide.underlying_cause.value_counts()
##to check if it filter