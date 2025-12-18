#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Title: Renewable Energy Capacity Distribution in the UK
#
# Purpose: To Clean all the needed data to prepare it for merging
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Part 2: Preparing the data for merging
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 1)load the needed libraries
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# "readxl" for reading Excel files
# "sf" for reading spatial data files (i.e. shapefiles for mapping)
# "tidyverse" and "dplyr" for data manipulation
library(readxl)
library(sf)
library(tidyverse)
library(dplyr)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 2) Cleaning the datasets
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Import the data into new data tables, this allows us to got back and select it as opposed to importing the files again
# select only the needed columns and rename them for clarity
# In this case that is the LAD code and the relevant variables we are going to be testing later


# 2a) Clean UK_Population data
# For this data set the names have also been kept as the Scottish data set does not have LAD codes
UK_Population_clean <- UK_population %>%
  select('Code', 'Name', 'Mid-2024')%>%
  rename('LAD code' = 'Code', 'Population_number' = 'Mid-2024')


# 2b) Clean UK Income data for 2023
UK_income_clean <- UK_income %>%
  select('...2', 'Gross Disposable Household Income - GDHI (£m)', 'GDHI per head (£)')%>%
  rename('GDHI' = 'Gross Disposable Household Income - GDHI (£m)', 'GDHI_PH' = 'GDHI per head (£)', 'LAD code' = '...2')


# 2c) Clean UK_Age data
UK_Age_clean <- UK_age %>%
  select('Code', 'Mid-2024')%>%
  rename('LAD code' = 'Code', 'Mean_age' = 'Mid-2024')


# 2d) Clean UK_Education data

# 2d.i) England and Wales education data
ew_education_clean <- ew_education %>%
  select('...2', '%...6')%>%
  rename('LAD code' = '...2', 'Batchalors_degree_or_higher_(%)' = '%...6',) %>%
  slice(-c(319, 320))  # removes the last 2 rows which are blank

# 2d.ii) Scotland education data
s_education_clean <- s_education %>%
  select('Council Area 2019', '...3', '...9')%>%
  rename('Name' = 'Council Area 2019',)%>%
  slice(-c(33, 34, 35, 36, 37)) %>%  # removes the last 5 rows which are blank
# the data set only provides population numbers so we need to calculate the percentage to compare with other countries
  mutate('Batchalors_degree_or_higher_(%)' = (...9 / ...3) * 100) %>%
  select(-c('...9', '...3'))

# 2d.iii) Northern Ireland Education data
n_education_clean <- n_education %>%
  select('Geography code', 'Level 4 qualifications and above [note 6]')%>%
  rename('LAD code' = 'Geography code', 'Batchalors_degree_or_higher_(%)' = 'Level 4 qualifications and above [note 6]',)


# 2e) Clean UK_energy data for 2024
UK_energy_2024_clean <- UK_energy_2024 %>%
  select('Local Authority Code [note 1]', 'Photovoltaics', 'Onshore Wind', 'Offshore Wind', 'Total')%>%
  rename('LAD code' = 'Local Authority Code [note 1]', 'Total_Capacity_2024' = 'Total', 'Photovoltaics_2024' = 'Photovoltaics', 'Onshore_Wind_2024' = 'Onshore Wind', 'Offshore_Wind_2024' = 'Offshore Wind')


# 2f) Clean UK_energy data for 2014
UK_energy_2014_clean <- UK_energy_2014 %>%
  select('Local Authority Code [note 1]', 'Local Authority Name', 'Photovoltaics', 'Onshore Wind', 'Offshore Wind', 'Total')%>%
  rename('LAD code' = 'Local Authority Code [note 1]', 'Name' = 'Local Authority Name', 'Total_Capacity_2014' = 'Total', 'Photovoltaics_2014' = 'Photovoltaics', 'Onshore_Wind_2014' = 'Onshore Wind', 'Offshore_Wind_2014' = 'Offshore Wind')


# 2g) Clean Shape file data
shapefile_clean <- Shapefile %>%
  select(LAD25CD, LAD25NM, geometry)%>%
  rename('LAD code' = 'LAD25CD')

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 3)remove the data that is not needed any more
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
rm(UK_income, UK_population, UK_age, UK_energy_2024, UK_energy_2014, Shapefile, ew_education, s_education, n_education)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 4) missing data check
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Check for missing values in the cleaned datasets
missing_values_check <- function(data) {
  sum(is.na(data))
}
datasets <- list(UK_income_clean, UK_Population_clean, UK_Age_clean, ew_education_clean, s_education_clean, n_education_clean, UK_energy_2024_clean, UK_energy_2014_clean, shapefile_clean)
missing_values <- sapply(datasets, missing_values_check)
missing_values

# Print missing values for each dataset
for (i in 1:length(datasets)) {
  cat("Missing values in dataset", i, ":", missing_values[i], "\n")
}
# we can see income is missing some values and we need to investigate
missing_income <- UK_income_clean[is.na(UK_income_clean$GDHI) | is.na(UK_income_clean$GDHI_PH), ]
print(missing_income) #we can see 4 rows with no values
#view(UK_income_clean) # we can see the last 4 rows are empty so can be deleted
UK_income_clean <- UK_income_clean %>%
  slice(-c(373, 374, 375, 376))  # removes the last 4 rows which are blank
rm(missing_income)

# Recheck missing values after cleaning
datasets <- list(UK_income_clean, UK_Population_clean, UK_Age_clean, ew_education_clean, s_education_clean, n_education_clean, UK_energy_2024_clean, UK_energy_2014_clean, shapefile_clean)
missing_values <- sapply(datasets, missing_values_check)
missing_values
# Print missing values for each dataset
for (i in 1:length(datasets)) {
  cat("Missing values in dataset", i, ":", missing_values[i], "\n")
}
# Remove any last remaining unneeded files
rm(datasets, missing_values, missing_values_check, i)
# Now all datasets have 0 missing values
# We are ready to merge

#End of Clean_V2.R script