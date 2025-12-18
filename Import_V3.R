#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Title: Renewable Energy Capacity Distribution in the UK
#
# Purpose: To Import all the needed data sets
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Part 1: Import different data sets
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 1)load the needed libraries
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# "readxl" for reading Excel files
# "sf" for handling spatial data files (i.e. shapefiles for mapping)
library(readxl)
library(sf)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 2) Import the dataset
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 2a) Gross Disposable Household Income Data
UK_income <- read_excel("data/Income/nomis_2025_12_13_131911.xlsx", sheet = "Data", skip = 6)

# 2b) UK Population Data 
UK_population <- read_excel("data/Population/mye24tablesuk.xlsx", skip = 7, sheet = "MYE4")

# 2c) UK Age Data
UK_age <- read_excel("data/Population/mye24tablesuk.xlsx", skip = 7, sheet = "MYE6")

# 2d) UK Education Data
# Note: There is no single source for UK education data,
# data was seperately for England/Wales, Scotland, and Northern Ireland

#England and Wales
ew_education <- read_excel("data/Education/ew_education.xlsx", skip = 8)
#Source: https://www.nomisweb.co.uk/query/construct/submit.asp?menuopt=201&subcomp=

#Scotland
s_education <- read_excel("data/Education/s_education.xlsx", skip = 11)
#Source: https://www.scotlandscensus.gov.uk/webapi/jsf/tableView/tableView.xhtml

#Northern Ireland
n_education <- read_excel("data/Education/n_education.xlsx", skip = 22, sheet = "LGD")
#Source: https://www.nisra.gov.uk/publications/census-2021-main-statistics-qualifications-tables

# 2e) UK Renewable Energy Capacity Data (2024)
UK_energy_2024 <- read_excel("data/Renewable_electricity_by_local_authority_2014-2024.xlsx", sheet = "LA - Capacity, 2024")

# 2f) UK Renewable Energy Capacity Data (2014)
UK_energy_2014 <- read_excel("data/Renewable_electricity_by_local_authority_2014-2024.xlsx", sheet = "LA - Capacity, 2014")

# 2g) Load the shapefile for UK Local Authorities to allow for mapping
Shapefile <- st_read("data/LAD_Shapefile/LAD_MAY_2025_UK_BUC.shp")
#Source: #https://www.data.gov.uk/dataset/1794b2e4-edf9-419b-9db0-82a4f26fc715/local-authority-districts-may-2025-boundaries-uk-buc

# End of Import_V3.R