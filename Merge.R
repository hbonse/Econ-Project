#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Title: Renewable Energy Generation Distribution in the UK
#
# Purpose: To merge all the data into 1 table
#
# Authors: Hugo Bonsey
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Part 3: Merging the data
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 1) for ease we combine the England/Wales and Northern Ireland education data first
# this will make the final merge step easier, we can't add Scotland yet as it dosen't have LAD codes
# Education_Data_Merger_EWN
ewn_education <- bind_rows(ew_education_clean, n_education_clean)
rm(ew_education_clean, n_education_clean)

# 2) Now we can merge all the cleaned datasets into one table
Combined_Data <- UK_Population_clean %>%
  left_join(s_education_clean, by = "Name") %>% #No Lad_code so joined by name
  left_join(UK_income_clean, by = "LAD code")%>%
  left_join(UK_Age_clean, by = "LAD code") %>%
  left_join(UK_energy_2024_clean, by = "LAD code")%>%
  left_join(ewn_education, by = "LAD code") %>%
  left_join(UK_energy_2014_clean, by = "Name") %>%
  filter(Total_Capacity_2024 != "na")%>% # remove rows with NA in Total_Capacity_2024 as some of the data has data for different sized areas e.g. county level which we are not intrested in
  # unfortunately not all the data merges correctly so we have to do some cleaning here
  # this is mainly for the education data where the same varriable is sprad across 2 columns, so we need to merge them into one and delete the old columns
  mutate(
    `Batchalors_degree_or_higher_(%)` = coalesce(
      `Batchalors_degree_or_higher_(%).y`, 
      `Batchalors_degree_or_higher_(%).x`)) %>%
  select(-'Batchalors_degree_or_higher_(%).x', -'Batchalors_degree_or_higher_(%).y', -'LAD code.y') %>%
  rename('LAD code' = 'LAD code.x')
  
  #the shapefile will be joined later, as for now it can cause issues with CSV files

#Now all the data is in one nice sheet we can remove the rest
rm(UK_income_clean, UK_Population_clean, UK_Education_clean, UK_energy_2014_clean, UK_energy_2024_clean, UK_Age_clean, s_education_clean, ewn_education)
# We can now write this to a CSV for easy access later
write.csv(Combined_Data, "data/Combined_Data.csv", row.names = FALSE)

# Note some data is missing energy data for 2014, this is due to the data not being available at the local authority level for some areas at that time
# So these areas will be excluded when comparing data from 2014 to 2024