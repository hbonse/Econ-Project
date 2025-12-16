#Welcome to the master file
#This file is designed to run all the relevant scripts in order
#To ensure smooth running ensure all files in the project are closed

#Libraries needed:
install.packages(c("tidyverse", "readxl", "sf", "stargazer"))

#restart as needed - after restart the code will need to be run again

source("Import_V3.R") #Imports all the data we need for this project

source("Clean_V2.R") #Cleans the data to make it is ready for merger

source("Merge.R") #Merges all the clean data into one table

#You can now save this data as a CSV for future use
write.csv(Combined_Data, "data/Combined_Data.csv", row.names = FALSE)

#Time for analysis and visualisation!

source("Analysis_OB1.R") #Analyses the data and creates visualisations for OB1
source("Analysis_OB2.R") #Analyses the data and creates visualisations for OB2
source("Analysis_OB3.R") #Analyses the data and creates visualisations for OB3

#All done! the outputs can be found in the output folder
print("All scripts have been run successfully! Check the output folder for results.")
