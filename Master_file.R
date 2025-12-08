#Welcome to the master file
#This file is designed to run all the relevant scripts in order
#To ensure somoth running ensure all files in the project are closed

#Libraries needed:

install.packages("tidyverse")
install.packages("readxl")
install.packages("sf")
#restart as needed - after restart the code will need to be run again

source("Import.R") #also cleans and merges data
#This will give you a combined data file with all the variables needed
head(Combined_Data) #to check this