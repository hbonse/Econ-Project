Combined_Data <- Combined_Data %>%
  mutate(
    total_pc_2024 = Total_Capacity_2024 / Population_number * 1000,
    total_pc_2014 = Total_Capacity_2014 / Population_number * 1000
  )

library(ggplot2)
OB2_data <- Shapefile %>%
  left_join(Combined_Data, by = c("LAD25CD" = "LAD code"))

ggplot(OB2_data) +
  geom_sf(aes(fill = total_pc_2024), colour = NA) +
  scale_fill_viridis_c() +
  labs(
    fill = "MW per 1,000 people",
    title = "Per-Capita Renewable Capacity by Local Authority (2024)"
  ) +
  theme_minimal()


Combined_Data %>%
  arrange(desc(total_pc_2024)) %>%
  select(Name, total_pc_2024) %>%
  head(10)


Combined_Data <- Combined_Data %>%
  mutate(
    total_pc_2014 = Total_Capacity_2014 / Population_number * 1000
  )

ggplot(Combined_Data, aes(x = total_pc_2014, y = total_pc_2024)) +
  geom_point(alpha = 0.6) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  labs(
    x = "Per-Capita Capacity (2014)",
    y = "Per-Capita Capacity (2024)",
    title = "Persistence of Renewable Energy Hotspots"
  )


Combined_Data <- Combined_Data %>%
  mutate(
    pv_pc_2024 = Photovoltaics_2024 / Population_number * 1000,
    onshore_pc_2024 = Onshore_Wind_2024 / Population_number * 1000,
    offshore_pc_2024 = Offshore_Wind_2024 / Population_number * 1000
  )


#per capacity wind map
ggplot(OB2_data %>% left_join(Combined_Data, by = "Name")) +
  geom_sf(aes(fill = onshore_pc_2024), colour = NA) +
  scale_fill_viridis_c() +
  labs(
    fill = "MW per 1,000 people",
    title = "Per-Capita Onshore Wind Capacity by Local Authority (2024)"
  ) +
  theme_minimal()

