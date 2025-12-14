# Part 0: Load required libraries ----
#time to for analysis
# Load necessary libraries
library(tidyverse)
library(sf)
library(ggplot2)
library(spdep)
library(tmap)
library(lubridate)
library(corrplot)
library(plm)
library(spatialreg)
library(broom)

install.packages("spdep")
install.packages("tmap")
install.packages("lubridate")
install.packages("corrplot")
install.packages("plm")
install.packages("spatialreg")


# Part 1: Cleaning energy generation variables ----
# ***********************************************************
# Energy generation variables are imported as character strings
# and contain suppressed values coded as "[X]" as well as NA values.
#
# Assumption:
# Suppressed or missing values are interpreted as zero recorded
# generation. This avoids dropping regions from the analysis,
# but may understate true output if suppression is systematic.
Combined_Data <- Combined_Data %>%
  mutate(
    across(
      .cols = matches("Wind|Solar|Hydro|Biomass|Generation|Capacity|MWh"),
      ~ str_replace_all(.x, "[X]", "0")
    )
  )
Combined_Data[Combined_Data == "[X]"] <- 0.0
Combined_Data[is.na(Combined_Data)] <- 0.0

# Convert energy-related variables to numeric format
# Commas are removed prior to conversion to avoid coercion errors
Combined_Data <- Combined_Data %>%
  mutate(
    across(
      .cols = matches("Wind|Solar|Hydro|Biomass|Generation|MWh|Capacity"),
      ~ as.numeric(stringr::str_replace_all(.x, ",", ""))
    )
# Part 2: Construction of derived indicators ----
# ***********************************************************
# This section constructs per-capita and technology composition
# indicators to allow comparison across regions of different sizes.

Analysis_Data_Super_Awesome <- Combined_Data %>%
  mutate(
    total_gen_out_2024_mw = Total_Generation_Output_2024 / Population_number *100,
    total_gen_out_2014_mw = Total_Generation_Output_2014 / Population_number *100,
    total_change_mw = total_gen_out_2024_mw - total_gen_out_2014_mw,
    wind_pc_2024 = (Onshore_Wind_2024 + Offshore_Wind_2024) / Total_Generation_Output_2024 * 1000,
    wind_pc_2014 = (Onshore_Wind_2014 + Offshore_Wind_2014) / Total_Generation_Output_2014 * 1000,
    wind_pc_change = (wind_pc_2024 - wind_pc_2014), 
    solar_pc_2024 = (Photovoltaics_2024) / Total_Generation_Output_2024 * 1000,
    solar_pc_2014 = (Photovoltaics_2014) / Total_Generation_Output_2014 * 1000,
    solar_pc_change = (solar_pc_2024 - solar_pc_2014),
    hydro_pc_2024 = (Hydro_2024) / Total_Generation_Output_2024 * 1000,
    hydro_pc_2014 = (Hydro_2014) / Total_Generation_Output_2014 * 1000,
    hydro_pc_change = (hydro_pc_2024 - hydro_pc_2014),
    Total_Generation_Output_2014 = as.numeric(Total_Generation_Output_2014),
    Total_Generation_Output_2024 = as.numeric(Total_Generation_Output_2024),
    diff_2024 = Total_Generation_Output_2024 - Total_Generation_Output_2014)


# Basic summary statistics
summary_stats <- Analysis_Data_Super_Awesome %>%
  summarise(
    avg_income = mean(Income, na.rm = TRUE),
    median_income = median(Income, na.rm = TRUE),
    avg_population = mean(Population_number, na.rm = TRUE),
    median_population = median(Population_number, na.rm = TRUE),
    avg_total_gen_out_2024_mw = mean(total_gen_out_2024_mw, na.rm = TRUE),
    median_total_gen_out_2024_mw = median(total_gen_out_2024_mw, na.rm = TRUE)
  )



# Part 3: Regional comparison of renewable generation ----
# ***********************************************************
# This figure compares renewable generation output across regions
# in 2014 and 2024 to illustrate spatial differences and changes over time.

Combined_Data2 <- Analysis_Data_Super_Awesome %>%
  select(Region_name, total_gen_out_2014_mw, total_change_mw) %>%
  rename( '2024' = total_change_mw,
          '2014' = total_gen_out_2014_mw) %>%
  pivot_longer(cols = c('2014','2024'),
               names_to = "Year",
               values_to = "Total_Generation_Output") %>%
  mutate(Year = factor(Year, levels =c("2014", "2024"))) %>%
  group_by(Region_name) %>%
  mutate(Median_Renewable_Generation = median(Total_Generation_Output, na.rm = TRUE)) %>%
  ungroup()

ggplot(
  Combined_Data2,
  aes(x = Region_name, y = Total_Generation_Output,
    fill = Year )
) +
  geom_col(position = "dodge") +
  scale_fill_manual(
    values = c("2014" = "blue", "2024" = "green"),
    name = "Year" ) +
  labs(title = "Renewable Generation Output by Region",
    subtitle = "Comparison between 2014 and 2024",
    x = "Region",
    y = "Generation Output"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)
  )









###
#time series plot 2014 vs 2024 total generation output per capita by region
ggplot(Analysis_Data_Super_Awesome, aes(x = Region_name)) +
  geom_bar(aes(y = total_gen_out_2014_mw, fill = "2014"), stat = "identity", position = "dodge") +
  geom_bar(aes(y = total_gen_out_2024_mw, fill = "2024"), stat = "identity", position = "dodge") +
  labs(title = "Total Generation Output per Capita by Region (2014 vs 2024)",
       x = "Region",
       y = "Total Generation Output per Capita (MW)") +
  scale_fill_manual(name = "Year", values = c("2014" = "blue", "2024" = "green")) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#time series plot 2014 vs 2024 total generation output per capita by region
ggplot(Analysis_Data_Super_Awesome, aes(x = Region_name)) +
  geom_bar(aes(y = total_gen_out_2024_mw, fill = "2024"), stat = "identity", position = "dodge") +
  geom_bar(aes(y = total_gen_out_2014_mw, fill = "2014"), stat = "identity", position = "dodge") +
  labs(title = "Total Generation Output per Capita by Region (2014 vs 2024)",
       x = "Region",
       y = "Total Generation Output per Capita (MW)") +
  scale_fill_manual(name = "Year", values = c("2024" = "blue", "2014" = "green")) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggplot(Analysis_Data_Super_Awesome, aes (x = Region_name, y = total_gen_out_2024_mw, fill = "2024"), stat = "identity", position = "dodge") +
  stat_summary(fun = sum, geom = "line") +
  labs(title = "Median_Renewable_Generation_Over_Time", y = "MWH")
