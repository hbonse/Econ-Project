#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Title: Renewable Energy Generation Distribution in the UK
#
# Purpose: To analyse the merged data for Objective 2
#
# Output:
#   - ob2_per_capita_2024_map.png
#   - ob2_top10_per_capita_2024.csv
#   - ob2_persistence_per_capita_scatter.png
#   - ob2_persistence_per_capita_onshore_scatter.png
#   - ob2_persistence_per_capita_solar_scatter.png
#   - ob2_persistence_per_capita_offshore_scatter.png
#   - ob2_per_capita_onshore_2024_map.png
#   - ob2_per_capita_solar_2024_map.png
#   - ob2_per_capita_offshore_2024_map.png
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Part 5: Analysing the data for Objective 2
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 1)load the libraries that will be used in this file
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
library(ggplot2)
library(sf)
library(ggrepel) # to label data points in the scatter plot


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 2) Create variables and sort data that is needed for analysis
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Combined_Data <- Combined_Data %>%
  mutate(
    total_pc_2024 = Total_Capacity_2024 / Population_number * 1000,
    total_pc_2014 = Total_Capacity_2014 / Population_number * 1000,
    pv_pc_2024 = Photovoltaics_2024 / Population_number * 1000,
    onshore_pc_2024 = Onshore_Wind_2024 / Population_number * 1000,
    offshore_pc_2024 = Offshore_Wind_2024 / Population_number * 1000,
    pv_pc_2014 = Photovoltaics_2014 / Population_number * 1000,
    onshore_pc_2014 = Onshore_Wind_2014 / Population_number * 1000,
    offshore_pc_2014 = Offshore_Wind_2014 / Population_number * 1000
  )

#table that shows the top 10 local authorities by per capita capacity in 2024
ob2_summary_table <- Combined_Data %>%
  arrange(desc(total_pc_2024)) %>%
  select(Name, total_pc_2024, total_pc_2014) %>%
  head(10)
#export to csv
write.csv(ob2_summary_table, "output/OB2/ob2_top10_per_capita_2024.csv", row.names = FALSE)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 3) Combine the spatial data with the main data for mapping
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Combined_Data <- shapefile_clean %>%
  left_join(Combined_Data, by = c("LAD code" = "LAD code"))
#remove the shape file as we no longer need it, if this code is run again it will cause an error
rm(shapefile_clean)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 4) Spatial Mapping Analysis
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 4.1) Map: Total Per-Capita Capacity (2024)
ggplot(Combined_Data) +
  geom_sf(aes(fill = total_pc_2024), colour = NA) +
  scale_fill_viridis_c() +
  labs(
    fill = "MW per 1,000 people",
    title = "Per Capita Renewable Capacity\nby Local Authority (2024)"
  ) +
  theme_minimal()
#export to png
ggsave("output/OB2/ob2_per_capita_2024_map.png", width = 8, height = 6)

# 4.2) Maps: Per-Capita Capacity by Technology (2024)
# 4.21) Per-Capita onshore wind map
ggplot(Combined_Data) + 
  geom_sf(aes(fill = onshore_pc_2024), colour = NA) +
  scale_fill_viridis_c() +
  labs(
    fill = "MW per 1,000 people",
    title = "Per Capita Onshore Wind\nCapacity by Local Authority (2024)"
  ) +
  theme_minimal()
#export
ggsave("output/OB2/ob2_per_capita_onshore_2024_map.png", width = 8, height = 6)

# 4.22) Per-Capita photovoltics map
ggplot(Combined_Data) +
  geom_sf(aes(fill = pv_pc_2024), colour = NA) +
  scale_fill_viridis_c() +
  labs(
    fill = "MW per 1,000 people",
    title = "Per Capita Solar Capacity\nby Local Authority (2024)"
  ) +
  theme_minimal()
#export
ggsave("output/OB2/ob2_per_capita_solar_2024_map.png", width = 8, height = 6)

# 4.23) Per-Capita offshore wind map
ggplot(Combined_Data) +
  geom_sf(aes(fill = offshore_pc_2024), colour = NA) +
  scale_fill_viridis_c() +
  labs(
    fill = "MW per 1,000 people",
    title = "Per Capita Offshore Wind\nCapacity by Local Authority (2024)"
  ) +
  theme_minimal()
#export
ggsave("output/OB2/ob2_per_capita_offshore_2024_map.png", width = 8, height = 6)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 5) Scatter Plot Analysis
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 5.1) Scatter Plot: Total Capacity Change of each Local Authority (2014 vs 2024)
ggplot(Combined_Data, aes(x = total_pc_2014, y = total_pc_2024)) +
  geom_point(alpha = 0.6) +
  #Labels the top 10 local authorities by per capita in 2024
  geom_text_repel(
    data = ob2_summary_table,
    aes(label = Name),
    box.padding = 0.5,
    max.overlaps = Inf
  ) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  labs(
    x = "Per-Capita Capacity (2014)",
    y = "Per-Capita Capacity (2024)",
    title = "Change in Renewable\nEnergy Hotspots"
  )
#certain local authorities were excluded due to missing data for 2014
#export
ggsave("output/OB2/ob2_persistence_per_capita_scatter.png", width = 8, height = 6)
rm(ob2_summary_table)

# 5.2) Scatter Plots: Capacity Change by Technology of each Local Authority (2014 vs 2024)
# 5.21) Scatter Plot: Onshore Wind Capacity Change
ggplot(Combined_Data, aes(x = onshore_pc_2014, y = onshore_pc_2024)) +
  geom_point(alpha = 0.6) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  labs(
    x = "Per Capita Onshore Wind Capacity (2014)",
    y = "Per Capita Onshore Wind Capacity (2024)",
    title = "Persistence of Onshore Wind\nEnergy Hotspots"
  )
#export
ggsave("output/OB2/ob2_persistence_per_capita_onshore_scatter.png", width = 8, height = 6)

# 5.22) Scatter Plot: Solar Capacity Change
ggplot(Combined_Data, aes(x = pv_pc_2014, y = pv_pc_2024)) +
  geom_point(alpha = 0.6) +
  geom_abline(slope = 1, intercept = 0, linetype =  "dashed") +
  labs( 
    x = "Per Capita Solar Capacity (2014)",
    y = "Per Capita Solar Capacity (2024)",
    title = "Persistence of Solar\nEnergy Hotspots"
  )
#export
ggsave("output/OB2/ob2_persistence_per_capita_solar_scatter.png", width = 8, height = 6)

# 5.23) Scatter Plot: Offshore Wind Capacity Change
ggplot(Combined_Data,  aes(x = offshore_pc_2014, y = offshore_pc_2024)) +
  geom_point(alpha = 0.6) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  labs(
    x = "Per Capita Offshore Wind Capacity (2014)",
    y = "Per Capita Offshore Wind Capacity (2024)",
    title = "Persistence of Offshore Wind\nEnergy Hotspots"
  )
#export
ggsave("output/OB2/ob2_persistence_per_capita_offshore_scatter.png", width = 8, height = 6)

rm(ob2_summary_table)
#End of Analysis_OB2.R
