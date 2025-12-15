#Welcome to the master file
#This file is designed to run all the relevant scripts in order
#To ensure smooth running ensure all files in the project are closed

#Libraries needed:
install.packages(c("tidyverse", "readxl", "sf", "stargazer", "corrplot", "gridExtra"))

#restart as needed - after restart the code will need to be run again

source("Import_V3.R") #Imports all the data we need for this project

source("Clean_V2.R") #Cleans the data to make it is ready for merger

source("Merge.R") #Merges all the clean data into one table

source("Analysis_OB1.R") #Analyses the data and creates visualisations)
source("Analysis_OB2.R") #Analyses the data and creates visualisations)
source("Analysis_OB3.R") #Analyses the data and creates visualisations)

source("Mapping.R") #Creates visualisations for the report

#This will give you a combined data file with all the variables needed
head(Combined_Data) #to check this

#You can now save this data as a CSV for future use
write.csv(Combined_Data, "data/Combined_Data.csv", row.names = FALSE)

#Time for analysis and visualisation!

source("Analysis.R") #Time to analyse the data
