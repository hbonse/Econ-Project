#This file is designed to import all the relevant libraries and data into your environment

# 1) Import the necessary libraries
library(readxl)
library(sf)
library(tidyverse)

# 2) Load the dataset

## Load the Excel files

# 2a) Gross Disposable Household Income Data
UK_Income <- read_excel("data/regionalgrossdisposablehouseholdincomelocalauthorities2023.xlsx", sheet = "Table 1", skip = 1)

# 2b) UK Population Data
UK_Population <- read_excel("data/Population.xlsx", skip = 7)

# 2c) UK Education Data
UK_Education <- read_excel("data/Education.xlsx", skip = 8)

# 2d) UK Renewable Energy Data (2024)
UK_energy_2024 <- read_excel("data/Renewable_electricity_by_local_authority_2014-2024.xlsx", sheet = "LA - Capacity, 2024")

# 2e) UK Renewable Energy Data (2014)
UK_energy_2014 <- read_excel("data/Renewable_electricity_by_local_authority_2014-2024.xlsx", sheet = "LA - Capacity, 2014")

## Load the shapefile for UK Local Authorities
Shapefile <- st_read("data/BoundaryData (1)/england_ltla_2022.shp")

# 3) Print the first few rows of each dataset to verify that is has sucessfully been imported
head(UK_Income)
head(UK_Population)
head(UK_Education)
head(UK_energy_2024)
head(UK_energy_2014)
head(Shapefile)
