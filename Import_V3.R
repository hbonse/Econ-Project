#This file is designed to import all the relevant libraries and data into your environment

# 1) Import the necessary libraries
library(readxl)
library(sf)

# 2) Load the dataset

## Load the Excel files

# 2a) Gross Disposable Household Income Data
UK_income <- read_excel("data/Income/nomis_2025_12_13_131911.xlsx", sheet = "Data", skip = 6)

# 2b) UK Population Data
UK_population <- read_excel("data/Population/mye24tablesuk.xlsx", skip = 7, sheet = "MYE4")

UK_age <- read_excel("data/Population/mye24tablesuk.xlsx", skip = 7, sheet = "MYE6")

# 2c) UK Education Data
ew_education <- read_excel("data/Education/ew_education.xlsx", skip = 8)
#https://www.nomisweb.co.uk/query/construct/submit.asp?menuopt=201&subcomp=
s_education <- read_excel("data/Education/s_education.xlsx", skip = 11)
#https://www.scotlandscensus.gov.uk/webapi/jsf/tableView/tableView.xhtml
n_education <- read_excel("data/Education/n_education.xlsx", skip = 22, sheet = "LGD")
#https://www.nisra.gov.uk/publications/census-2021-main-statistics-qualifications-tables

# 2d) UK Renewable Energy Data (2024)
UK_energy_2024 <- read_excel("data/Renewable_electricity_by_local_authority_2014-2024.xlsx", sheet = "LA - Capacity, 2024")

# 2e) UK Renewable Energy Data (2014)
UK_energy_2014 <- read_excel("data/Renewable_electricity_by_local_authority_2014-2024.xlsx", sheet = "LA - Capacity, 2014")

# 2f) Load the shapefile for UK Local Authorities
Shapefile <- st_read("data/LAD_Shapefile/LAD_MAY_2025_UK_BUC.shp")
#https://www.data.gov.uk/dataset/1794b2e4-edf9-419b-9db0-82a4f26fc715/local-authority-districts-may-2025-boundaries-uk-buc

