#Next we need to clean the data to ensure that it is ready for analysis
#Cleaning the data

# Load necessary libraries
library(readxl)
library(sf)
library(tidyverse)

# Assuming there are no missing values, we proceed to clean the data
# Then Select desired columns and rename them for clarity

#1) Clean UK_Income data for 2023
UK_Income_clean <- UK_Income %>%
  select('LAD code', 'Region name', '2023')%>%
  rename('Income' = '2023', 'Region_name' = 'Region name')

#2) Clean UK_Population data for 2023
UK_Population_clean <- UK_Population %>%
  select('...2', 'All persons')%>%
  rename('LAD code' = '...2', 'Population_number' = 'All persons')

#3) Clean UK_Education data for 2023
UK_Education_clean <- UK_Education %>%
  select('...2', 'number...13', '...1')%>%
  rename('LAD code' = '...2', 'Batchalors_degree_or_higher' = 'number...13', 'Local Authority Name' = '...1')

#4) Clean UK_energy data for 2024
UK_energy_2024_clean <- UK_energy_2024 %>%
  select('Local Authority Code [note 1]', 'Photovoltaics', 'Onshore Wind', 'Offshore Wind', 'Total')%>%
  rename('LAD code' = 'Local Authority Code [note 1]', 'Total_Capacity_2024' = 'Total', 'Photovoltaics_2024' = 'Photovoltaics', 'Onshore_Wind_2024' = 'Onshore Wind', 'Offshore_Wind_2024' = 'Offshore Wind')

#5) Clean UK_energy data for 2014
UK_energy_2014_clean <- UK_energy_2014 %>%
  select('Local Authority Code [note 1]', 'Photovoltaics', 'Onshore Wind', 'Offshore Wind', 'Total')%>%
  rename('LAD code' = 'Local Authority Code [note 1]', 'Total_Capacity_2014' = 'Total', 'Photovoltaics_2014' = 'Photovoltaics', 'Onshore_Wind_2014' = 'Onshore Wind', 'Offshore_Wind_2014' = 'Offshore Wind')
#6) Clean Shapefile data
Shapefile_clean <- Shapefile %>%
  select(ltla22cd, name, geometry)%>%
  rename('LAD code' = 'ltla22cd')

# Check for missing values in the cleaned datasets
missing_values_Income_clean <- sapply(UK_Income_clean, function(x) sum(is.na(x)))
missing_values_Population_clean <- sapply(UK_Population_clean, function(x) sum(is.na(x)))
missing_values_Education_clean <- sapply(UK_Education_clean, function(x) sum(is.na(x)))
missing_values_2014_clean <- sapply(UK_energy_2014_clean, function(x) sum(is.na(x)))
missing_values_2024_clean <- sapply(UK_energy_2024_clean, function(x) sum(is.na(x)))

print(missing_values_Income_clean)
print(missing_values_Population_clean)
print(missing_values_Education_clean)
print(missing_values_2014_clean)
print(missing_values_2024_clean)

#If there are no missing values, we can proceed to remove the original datasets
#population and education were missing values so we will need to investigate
#As they are mssing both their LAD code and values we will remove these rows as they are just dummy rows
UK_Population_clean <- UK_Population_clean %>%
  filter(!is.na(`LAD code`) & !is.na(Population_number))
UK_Education_clean <- UK_Education_clean %>%
  filter(!is.na(`LAD code`) & !is.na(`Batchalors_degree_or_higher`))

#check again
missing_values_Population_clean <- sapply(UK_Population_clean, function(x) sum(is.na(x)))
missing_values_Education_clean <- sapply(UK_Education_clean, function(x) sum(is.na(x)))
print(missing_values_Population_clean)
print(missing_values_Education_clean)

#sucess
#Now all the data is clean we can remove the all unneeded dataframes
rm(missing_values_Income_clean, missing_values_Population_clean, missing_values_Education_clean, missing_values_2014_clean, missing_values_2024_clean)
rm(UK_Income, UK_energy_2024, UK_energy_2014, Shapefile, UK_Population, UK_Education)
#The data is now ready for merging

