#The purpose of this code is to import the relevant files into the enviroment

#Importing and installing the necessary libraries
#https://www.ons.gov.uk/datasets/create/filter-outputs/7e69fa95-ab71-448f-9c23-44857a2d1c3e#get-data

#This library is to read shape files
install.packages("sf")
library(sf) 

#This library is to read .xlsx files
install.packages("readxl")
library(readxl)

#Importing the shapefile
uk_shapefile <- st_read("C:/Users/H/OneDrive - King's College London/Enviromental Economics/Econ-Project/Data/Local_Authority_Districts_May_2024_Boundaries_UK_BFE_-5758551109064458912/LAD_MAY_2024_UK_BFE.shp")

#Importing the Excel file - please specify the correct sheet name in place of "?????"
#Energy Data
energy_data <- read_excel("C:/Users/H/OneDrive - King's College London/Enviromental Economics/Econ-Project/Data/Renewable_electricity_by_local_authority_2014-2024.xlsx", sheet = "LA - Generation, 2014")

install.packages("tidyverse")
library(tidyverse)

#Census Data
#car ownsership first
Car_ownership <- read_excel("C:/Users/H/OneDrive - King's College London/Enviromental Economics/Econ-Project/Data/custom-filtered-2025-12-03T19_18_23Z.xlsx", sheet = "Dataset")
Car_processed_<- Car_ownership %>%
  #This line filters out invalid rows
  filter(`Car or van availability (3 categories)` != "Does not apply") %>%
  #This line is to remove the category code colum so the columns can then merge
  select(-`Car or van availability (3 categories) Code`) %>%
  # this code is to merge them
  pivot_wider(
    names_from = `Car or van availability (3 categories)`,
    values_from = Observation
  ) %>%
  #renaming to make things look nice
  rename(
    Code = `Lower tier local authorities Code`,
    Name = `Lower tier local authorities`,
    No_Cars = `No cars or vans in household`,
    One_Plus_Cars = `1 or more cars or vans in household`
  ) %>%
  
  # Calculate Totals and Percentages to do hotspot map
  mutate(
    Total_Households = No_Cars + One_Plus_Cars,
    Pct_One_Plus_Cars = (One_Plus_Cars / Total_Households) * 100
  )

# View the top 5 areas with highest car ownership
print(head(arrange(Car_processed_, desc(Pct_One_Plus_Cars))))

map_data <- uk_shapefile %>%
  left_join(Car_processed_, by = c("LAD24CD" = "Code"))

install.packages("tmap")
library("tmap")

tmap_mode("view") # Change to "plot" for a static image

tm_shape(map_data) +
  tm_polygons(
    col = "Pct_One_Plus_Cars",          # Column to map
    title = "Households with 1+ Cars (%)",
    palette = "RdYlGn",                # Red (Low) to Green (High)
    style = "jenks",                    # Natural breaks for classification
    n = 5,                              # Number of color classifications
    popup.vars = c("Name", "Pct_One_Plus_Cars", "Total_Households")
  ) +
  tm_layout(title = "Car Ownership Hotspots")

#Viewing the imported data
head(uk_shapefile)
head(energy_data)

