#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Title: Renewable Energy Generation Distribution in the UK
#
# Purpose: To merge all the data into 1 table
#
# Authors: Hugo Bonsey
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Part 5: Analysing the data for Objective 2
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 1)load the libraries that will be used in this file
library(ggplot2)


# 2) Load the combined data and add needed variables
Combined_Data <- Combined_Data %>%
  mutate(
    total_pc_2024 = Total_Capacity_2024 / Population_number * 1000,
    total_pc_2014 = Total_Capacity_2014 / Population_number * 1000
  )

#Combine it with the shape file for mapping
Combined_Data <- shapefile_clean %>%
  left_join(Combined_Data, by = c("LAD code" = "LAD code"))
#remove the shape file as we no longer need it
rm(shapefile_clean)

#per capacity map
ggplot(Combined_Data) +
  geom_sf(aes(fill = total_pc_2024), colour = NA) +
  scale_fill_viridis_c() +
  labs(
    fill = "MW per 1,000 people",
    title = "Per-Capita Renewable Capacity\nby Local Authority (2024)"
  ) +
  theme_minimal()
#export to png
ggsave("output/OB2/per_capita_2024_map.png", width = 8, height = 6)

ob2_summary_table <- Combined_Data %>%
  arrange(desc(total_pc_2024)) %>%
  select(Name, total_pc_2024) %>%
  head(10)
#export to csv
write.csv(ob2_summary_table, "output/ob2_top10_per_capita_2024.csv", row.names = FALSE)

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
    title = "Persistence of Renewable\nEnergy Hotspots"
  )
#certain local authorities were excluded due to missing data for 2014
#export
ggsave("output//OB2persistence_per_capita_scatter.png", width = 8, height = 6)

# Now we can look at the individual technologies per capita

Combined_Data <- Combined_Data %>%
  mutate(
    pv_pc_2024 = Photovoltaics_2024 / Population_number * 1000,
    onshore_pc_2024 = Onshore_Wind_2024 / Population_number * 1000,
    offshore_pc_2024 = Offshore_Wind_2024 / Population_number * 1000
  )


#per capacity Onshore wind map
ggplot(Combined_Data) + 
  geom_sf(aes(fill = onshore_pc_2024), colour = NA) +
  scale_fill_viridis_c() +
  labs(
    fill = "MW per 1,000 people",
    title = "Per-Capita Onshore Wind\nCapacity by Local Authority (2024)"
  ) +
  theme_minimal()
#export
ggsave("output/OB2/per_capita_onshore_2024_map.png", width = 8, height = 6)
#per capacity solar map
ggplot(Combined_Data) +
  geom_sf(aes(fill = pv_pc_2024), colour = NA) +
  scale_fill_viridis_c() +
  labs(
    fill = "MW per 1,000 people",
    title = "Per-Capita Solar Capacity\nby Local Authority (2024)"
  ) +
  theme_minimal()
#export
ggsave("output/OB2/per_capita_solar_2024_map.png", width = 8, height = 6)
#per capacity offshore wind map
ggplot(Combined_Data) +
  geom_sf(aes(fill = offshore_pc_2024), colour = NA) +
  scale_fill_viridis_c() +
  labs(
    fill = "MW per 1,000 people",
    title = "Per-Capita Offshore Wind\nCapacity by Local Authority (2024)"
  ) +
  theme_minimal()
#export
ggsave("output/OB2/per_capita_offshore_2024_map.png", width = 8, height = 6)

rm(ob2_summary_table)
#End of Analysis_OB2.R
