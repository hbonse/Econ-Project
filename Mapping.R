#1) Load Libraries and Data
library(sf)
library(tidyverse)

# 2)Join the files
uk_map  <- st_read("data/LAD_Shapefile/LAD_MAY_2025_UK_BUC.shp")%>%
#https://www.data.gov.uk/dataset/1794b2e4-edf9-419b-9db0-82a4f26fc715/local-authority-districts-may-2025-boundaries-uk-buc
  rename(`LAD code` = LAD25CD)

# 3) Join Data
# We use left_join to attach data to the map
map_data <- uk_map %>%
  left_join(combined_analysis, by = "LAD code")

# 4)Hotspot" Map (Total Capacity 2024)
map_plot <- ggplot(map_data) +
  geom_sf(aes(fill = Total_Capacity_2024), color = NA) +
  scale_fill_viridis_c(option = "magma", direction = -1, na.value = "grey90",
                       name = "Capacity (MW)") +
  labs(
    title = "UK Renewable Energy Hotspots (2024)",
    subtitle = "Total Capacity by Local Authority",
    caption = "Grey areas indicate missing data"
  ) +
  theme_void() + # Removes axes and grey background
  theme(legend.position = "right")

# Export the map
ggsave("Figure4_Hotspot_Map.png", plot = map_plot, width = 8, height = 10)
print(map_plot)

# 5) Map for Capacity Per Person
map_per_person <- ggplot(map_data) +
  geom_sf(aes(fill = Total_Cap_Per_Person_2024), color = NA) +
  scale_fill_viridis_c(option = "plasma", direction = -1, 
                       name = "MW Per Person") +
  labs(
    title = "Renewable Capacity Density (2024)",
    subtitle = "Capacity per Capita by Local Authority"
  ) +
  theme_void()

ggsave("Figure5_PerCapita_Map.png", plot = map_per_person, width = 8, height = 10)
print(map_per_person)
