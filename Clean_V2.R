#Next we need to clean the data to ensure that it is ready for analysis
#Cleaning the data

# Load necessary libraries
library(readxl)
library(sf)
library(tidyverse)
library(dplyr)

# Assuming there are no missing values, we proceed to clean the data
# Then Select the desired columns and rename them for clarity
# 1. Income Data (GDHI)
# Select relevant variables and rename for clarity
#1) Clean UK_Income data for 2023
UK_income_clean <- UK_income %>%
  select('...2', 'Gross Disposable Household Income - GDHI (£m)', 'GDHI per head (£)')%>%
  rename('GDHI' = 'Gross Disposable Household Income - GDHI (£m)', 'GDHI_PH' = 'GDHI per head (£)', 'LAD code' = '...2')

# 2. Population Data
# Keep LAD code and mid-year population estimate
#2) Clean UK_Population data
UK_Population_clean <- UK_population %>%
  select('Code', 'Name', 'Mid-2024')%>%
  rename('LAD code' = 'Code', 'Population_number' = 'Mid-2024')

#2.5 Clean UK_Age data
UK_Age_clean <- UK_age %>%
  select('Code', 'Mid-2024')%>%
  rename('LAD code' = 'Code', 'Mean_age' = 'Mid-2024')

# 3. Education Data
# England & Wales: percentage already provided
#3) Clean UK_Education data
ew_education_clean <- ew_education %>%
  select('...2', '%...6')%>%
  rename('LAD code' = '...2', 'Batchalors_degree_or_higher_(%)' = '%...6',)

# Scotland: calculate percentage manually
s_education_clean <- s_education %>%
  select('Council Area 2019', '...3', '...9')%>%
  rename('Name' = 'Council Area 2019',)%>%
  slice(-c(33, 34, 35, 36, 37)) %>% #remove the last 5 rows which are not needed
  mutate('Batchalors_degree_or_higher_(%)' = (...9 / ...3) * 100) %>%
  select(-c('...9', '...3'))

# Northern Ireland
n_education_clean <- n_education %>%
  select('Geography code', 'Level 4 qualifications and above [note 6]')%>%
  rename('LAD code' = 'Geography code', 'Batchalors_degree_or_higher_(%)' = 'Level 4 qualifications and above [note 6]',)

rm(ew_education, s_education, n_education)  

# 4. Energy Capacity Data (2014 & 2024)
# Clean renewable energy capacity variables
#4) Clean UK_energy data for 2024
UK_energy_2024_clean <- UK_energy_2024 %>%
  select('Local Authority Code [note 1]', 'Photovoltaics', 'Onshore Wind', 'Offshore Wind', 'Total')%>%
  rename('LAD code' = 'Local Authority Code [note 1]', 'Total_Capacity_2024' = 'Total', 'Photovoltaics_2024' = 'Photovoltaics', 'Onshore_Wind_2024' = 'Onshore Wind', 'Offshore_Wind_2024' = 'Offshore Wind')

#5) Clean UK_energy data for 2014
UK_energy_2014_clean <- UK_energy_2014 %>%
  select('Local Authority Code [note 1]', 'Local Authority Name', 'Photovoltaics', 'Onshore Wind', 'Offshore Wind', 'Total')%>%
  rename('LAD code' = 'Local Authority Code [note 1]', 'Name' = 'Local Authority Name', 'Total_Capacity_2014' = 'Total', 'Photovoltaics_2014' = 'Photovoltaics', 'Onshore_Wind_2014' = 'Onshore Wind', 'Offshore_Wind_2014' = 'Offshore Wind')

#6) Clean Shapefile data
Shapefile_clean <- Shapefile %>%
  select(LAD25CD, LAD25NM, geometry)%>%
  rename('LAD code' = 'LAD25CD')

# Check for missing values in the cleaned datasets ----- this needs fixing
missing_values_check <- function(Combined_Data) {
  sum(is.na(Combined_Data))
}
datasets <- list(UK_income_clean, UK_Population_clean, UK_Age_clean, ew_education_clean, s_education_clean, n_education_clean, UK_energy_2024_clean, UK_energy_2014_clean, Shapefile_clean)
missing_values <- sapply(datasets, missing_values_check)
missing_values




#If there are no missing values, we can proceed to remove the original datasets
#population and education were missing values so we will need to investigate
#As they are mssing both their LAD code and values we will remove these rows as they are just dummy rows

#check again

#sucess
#Now all the data is clean we can remove the all unneeded dataframes
rm
#The data is now ready for merging
