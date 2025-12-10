Combined_Data <- UK_Income_clean %>%
  inner_join(UK_Population_clean, by = "LAD code") %>%
  inner_join(UK_Education_clean, by = "LAD code")%>%
  inner_join(UK_energy_2014_clean, by = "LAD code") %>%
  inner_join(UK_energy_2024_clean, by = "LAD code")
  #inner_join(Shapefile2, by = "LAD code") - not being used due to CSV issues due to geometry column

#Now all the data is in one nice sheet we can remove the rest
rm(UK_Income_clean, UK_Population_clean, UK_Education_clean, UK_energy_2014_clean, UK_energy_2024_clean, Shapefile_clean)