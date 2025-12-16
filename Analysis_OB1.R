#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Title: Renewable Energy Generation Distribution in the UK
#
# Purpose: To merge all the data into 1 table
#
# Authors: Hugo Bonsey
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Part 4: Analysing the data for Objective 1
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 1)load the libraries that will be used in this file
library("tidyverse")
library("dplyr")
library("tidyr")
library("knitr")
 #2) Load the combined data
Combined_Data <- read.csv("data/Combined_Data.csv")

# 3) Analysis of Renewable Energy Data
# summary statistics - useful for initial analysis
summery_table <- Combined_Data %>%
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
  ) %>%
  # Put all columns into a long list
  pivot_longer(cols = everything(), 
               names_to = c("Statistic", "Year"), 
               names_sep = "_") %>%
  # Put them back out so Statistics are headers
  pivot_wider(names_from = Statistic, 
              values_from = value)
# Save the table as a CSV to put in report
write.csv(summery_table, "output/summary_table_2014_2024.csv", row.names = FALSE)


# histogram of total renewable capacity in 2024
ggplot(Combined_Data, aes(x = Total_Capacity_2024)) +
  geom_histogram(bins = 30, fill = "grey70", colour = "black") +
  labs(
    x = "Total Renewable Capacity (MW)",
    y = "Number of Local Authorities",
    title = "Distribution of Total\nRenewable Capacity (2024)"
  )
ggsave("output/histogram_total_capacity_2024.png", width = 8, height = 6)

# boxplots comparing renewable capacity by technology in 2024
Combined_Data %>%
  select(Photovoltaics_2024, Onshore_Wind_2024, Offshore_Wind_2024) %>%
  pivot_longer(
    cols = everything(),
    names_to = "technology",
    values_to = "capacity"
  ) %>%
  ggplot(aes(x = technology, y = capacity)) +
  geom_boxplot() +
  scale_x_discrete(labels = c("Offshore Wind", "Onshore Wind", "Solar")) +
  labs(
    x = "Technology",
    y = "Renewable Capacity (MW)",
    title = "Renewable Capacity\nby Technology (2024)"
  )
ggsave("output/histogram_Renewable_capacity_by_type_2024.png", width = 8, height = 6)


# boxplots comparing total renewable capacity between 2014 and 2024
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
    title = "Change in Renewable Capacity\nBetween 2014 and 2024"
  )
ggsave("output/histogram_Renewable_capacity_2014-2024.png", width = 8, height = 6)

# boxplots comparing growth in renewable capacity by technology between 2014 and 2024
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
  scale_x_discrete(labels = c("Offshore Wind", "Onshore Wind", "Solar")) +
  labs(
    x = "Technology",
    y = "Capacity Growth (MW)",
    title = "Growth in Renewable Capacity\nby Technology (2014–2024)"
  )
ggsave("output/histogram_Renewable_growth_2014-2024.png", width = 8, height = 6)

#End of Analysis_OB1.R