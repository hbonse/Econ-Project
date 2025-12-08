#This file is designed to import all the relevant libraries and data
#into your environment


#Now load the packages
library(tidyverse)
library(readxl)
library(sf)

#Time to import the data into our environment:

#Importing the Excel data
#First is the income data
UK_Income <- read_excel("data/regionalgrossdisposablehouseholdincomelocalauthorities2023.xlsx", sheet = "Table 1", skip = 1)
#Now we need to filter out to get the data we actually need
UK_Income_2021 <- UK_Income %>%
  select('LAD code', '2021')%>%
  rename('Income_2021' = '2021')

#Population Data
UK_Population <- read_excel("data/Population.xlsx", skip = 7)
UK_Population_2021 <- UK_Population %>%
  select('...2', 'All persons')%>%
  rename('LAD code' = '...2', 'Population_number' = 'All persons')

#Education Data
UK_Education <- read_excel("data/Education.xlsx", skip = 8)
UK_Education_2021 <- UK_Education %>%
  select('...2', 'number...13')%>%
  rename('LAD code' = '...2', 'Batchalors degree or higher' = 'number...13')

#Next is the energy data
#~~~need to specify the correct sheet to import~~~#
Shapefile <- st_read("data/BoundaryData (1)/england_ltla_2022.shp")
UK_energy <- read_excel("data/Renewable_electricity_by_local_authority_2014-2024.xlsx", sheet = "LA - Generation, 2021")
UK_energy_2021 <- UK_energy %>%
  select('Local Authority Code [note 1]', 'Total')%>%
  rename('LAD code' = 'Local Authority Code [note 1]', 'Total_Generation_Output' = 'Total')

#Finally we will import the shapefile this will be important for generating cool visula regresion analysis later
Shapefile <- st_read("data/BoundaryData (1)/england_ltla_2022.shp")
Shapefile2 <- Shapefile %>%
  select(ltla22cd, name, geometry)%>%
  rename('LAD code' = 'ltla22cd')

#Time to combine the sheets if

Combined_Data <- UK_Income_2021 %>%
  inner_join(UK_energy_2021, by = "LAD code") %>%
  #inner_join(Shapefile2, by = "LAD code")%>%
  inner_join(UK_Population_2021, by = "LAD code")%>%
  inner_join(UK_Education_2021, by = "LAD code")

#Now all the data is in one nice clean sheet we can remove the rest
rm(UK_Income, UK_Income_2021, UK_energy, UK_energy_2021, Shapefile, Shapefile2, UK_Population, UK_Population_2021, UK_Education, UK_Education_2021)


