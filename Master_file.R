# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Master File
# Purpose : To run all scripts in order
# Author  : Hugo Bonsey
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Welcome to the master file
#This file is designed to run all the relevant scripts in order
#To ensure smooth running ensure all files in the project are closed

#Libraries needed:
install.packages(c("tidyverse", "readxl", "sf", "stargazer"))
#restart as needed


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Part 1) Data Import
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Importing data
source("Import_V3.R") #Imports all the data we need for this project

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Part 2) Data Cleaning
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Cleaning data
source("Clean_V2.R") #Cleans the data to make it is ready for merger

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Part 3) Data Merging
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Merging data
source("Merge.R") #Merges all the clean data into one table

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Part 4) Data Analysis
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Doing Data Analysis
options(warn = -1) #Turn off warnings for this section - due to missing data warning show, to turn on change value to 0
source("Analysis_OB1.R") #Analyses the data and creates visualisations for OB1
# This file will show warning messages after running, this is due to missing data for 2014 in some local authorities
source("Analysis_OB2.R") #Analyses the data and creates visualisations for OB2
# This file will show warning messages after running, this is due to missing data for 2014 in some local authorities
source("Analysis_OB3.R") #Analyses the data and creates visualisations for OB3
options(warn = 0)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#All done! the outputs can be found in the output folder

#End of Master File