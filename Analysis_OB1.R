library("tidyverse")

Combined_Data %>%
  summarise(
    mean_2014 = mean(Total_Capacity_2014, na.rm = TRUE),
    median_2014 = median(Total_Capacity_2014, na.rm = TRUE),
    sd_2014 = sd(Total_Capacity_2014, na.rm = TRUE),
    min_2014 = min(Total_Capacity_2014, na.rm = TRUE),
    max_2014 = max(Total_Capacity_2014, na.rm = TRUE),
    
    mean_2024 = mean(Total_Capacity_2024, na.rm = TRUE),
    median_2024 = median(Total_Capacity_2024, na.rm = TRUE),
    sd_2024 = sd(Total_Capacity_2024, na.rm = TRUE),
    min_2024 = min(Total_Capacity_2024, na.rm = TRUE),
    max_2024 = max(Total_Capacity_2024, na.rm = TRUE),
    
    n = n()
  )



ggplot(Combined_Data, aes(x = Total_Capacity_2024)) +
  geom_histogram(bins = 30, fill = "grey70", colour = "black") +
  labs(
    x = "Total Renewable Capacity (MW)",
    y = "Number of Local Authorities",
    title = "Distribution of Total Renewable Capacity (2024)"
  )
ggsave("histogram_total_capacity_2024.png", width = 8, height = 6)



Combined_Data %>%
  select(Photovoltaics_2024, Onshore_Wind_2024, Offshore_Wind_2024) %>%
  pivot_longer(
    cols = everything(),
    names_to = "technology",
    values_to = "capacity"
  ) %>%
  ggplot(aes(x = technology, y = capacity)) +
  geom_boxplot() +
  labs(
    x = "Technology",
    y = "Installed Capacity (MW)",
    title = "Renewable Capacity by Technology (2024)"
  )



Combined_Data %>%
  select(Total_Capacity_2014, Total_Capacity_2024) %>%
  pivot_longer(
    cols = everything(),
    names_to = "year",
    values_to = "capacity"
  ) %>%
  ggplot(aes(x = year, y = capacity)) +
  geom_boxplot() +
  labs(
    x = "Year",
    y = "Total Renewable Capacity (MW)",
    title = "Change in Renewable Capacity Between 2014 and 2024"
  )









#renewable growth over time
Combined_Data <- Combined_Data %>%
  mutate(
    pv_growth = Photovoltaics_2024 - Photovoltaics_2014,
    onshore_growth = Onshore_Wind_2024 - Onshore_Wind_2014,
    offshore_growth = Offshore_Wind_2024 - Offshore_Wind_2014
  )

Combined_Data %>%
  select(pv_growth, onshore_growth, offshore_growth) %>%
  pivot_longer(
    cols = everything(),
    names_to = "technology",
    values_to = "growth"
  ) %>%
  ggplot(aes(x = technology, y = growth)) +
  geom_boxplot() +
  labs(
    x = "Technology",
    y = "Capacity Growth (MW)",
    title = "Growth in Renewable Capacity by Technology (2014–2024)"
  )
