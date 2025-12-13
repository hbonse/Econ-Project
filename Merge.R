# Education_Data

ewn_education <- bind_rows(ew_education_clean, n_education_clean)
rm(ew_education_clean, n_education_clean)

# Merge all cleaned datasets into one

Combined_Data <- UK_Population_clean %>%
  left_join(s_education_clean, by = "Name") %>%
  left_join(UK_income_clean, by = "LAD code")%>%
  #left_join(UK_Population_clean, by = "LAD code") %>%
  left_join(UK_Age_clean, by = "LAD code") %>%
  left_join(UK_energy_2024_clean, by = "LAD code")%>%
  left_join(ewn_education, by = "LAD code") %>%
  left_join(UK_energy_2014_clean, by = "Name") %>%
  filter(Total_Capacity_2024 != "na")%>%
  mutate(
    `Batchalors_degree_or_higher_(%)` = coalesce(
      `Batchalors_degree_or_higher_(%).y`, 
      `Batchalors_degree_or_higher_(%).x`)) %>%
  select(-'Batchalors_degree_or_higher_(%).x', -'Batchalors_degree_or_higher_(%).y', -'LAD code.y') %>%
  rename('LAD code' = 'LAD code.x')
  
  #inner_join(Shapefile2, by = "LAD code") - not being used due to CSV issues due to geometry column

#Now all the data is in one nice sheet we can remove the rest
rm(UK_Income_clean, UK_Population_clean, UK_Education_clean, UK_energy_2014_clean, UK_energy_2024_clean, Shapefile_clean)
