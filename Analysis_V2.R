
library(tidyverse)
library(stargazer) # For nice tables
library(gridExtra) # For arranging plots

combined_analysis<-Combined_Data

combined_analysis<- combined_analysis%>%
  mutate(
    Total_Cap_Per_Person_2014 = Total_Capacity_2014 / Population_number,
    Total_Cap_Per_Person_2024 = Total_Capacity_2024 / Population_number)

# Reshape data into long format
# Rationale:
# Long-format data allows consistent plotting across years
# and avoids manual duplication of ggplot layers.
combined_analysis_long <- combined_analysis%>%
  pivot_longer(
    cols = matches("2014|2024"),
    names_to = c("Energy_Type", "Year"),
    names_pattern = "(.*)_(20\\d\\d)", 
    values_to = "Capacity"
  ) %>%
  mutate(
    Capacity_Per_Person = Capacity / Population_number,
    Year = as.factor(Year)
  )

# Check the structure of the data
glimpse(combined_analysis)
glimpse(combined_analysis_long)
# Part 1: Construction of per-capita capacity indicators ----
# ***********************************************************
# This section constructs per-capita renewable capacity measures
# to enable meaningful comparison across local authorities
# with different population sizes.

# --- PART B: Descriptive Statistics and Visualisations ---

# summary data section
summary_data <- combined_analysis%>%
  select(Name, GDHI_PH, Population_number, 
         Total_Capacity_2014, Total_Capacity_2024, 
         Total_Cap_Per_Person_2024)

# Part 2: Descriptive statistics ----
# ***********************************************************
# This section summarises key socio-economic and energy
# characteristics at the local authority level.
# The table reports average income and renewable capacity
# levels to provide baseline context for later analysis.

summary_table <- summary_data %>%
  group_by(Name) %>%
  summarise(
    Count = n(),
    Avg_Income = mean(GDHI_PH, na.rm = TRUE),
    Avg_Total_Cap_2024 = mean(Total_Capacity_2024, na.rm = TRUE),
    Max_Total_Cap_2024 = max(Total_Capacity_2024, na.rm = TRUE)
  )




# View the summary table
print(summary_table)


write_csv(summary_table, "Table1_Summary_Statistics.csv")

#### visualisations

plot1 <- combined_analysis_long %>%
  filter(Energy_Type == "Total_Capacity") %>%
  group_by(Name, Year) %>%
  summarise(Mean_Capacity = mean(Capacity, na.rm = TRUE)) %>%
  ggplot(aes(x = Name, y = Mean_Capacity, fill = Year)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() + # Makes labels easier to read
  labs(
    title = "Evolution of Mean Total Renewable Capacity by Region",
    subtitle = "Comparison: 2014 vs 2024",
    y = "Mean Capacity (MW)",
    x = "Region"
  ) +
  theme_minimal()
# Part 3: Regional evolution of renewable capacity ----
# ***********************************************************
# This figure compares mean total renewable capacity
# across regions in 2014 and 2024 to illustrate spatial
# divergence and convergence patterns.


# Export Plot 1
ggsave("Figure1_Regional_Evolution.png", plot = plot1, width = 10, height = 6)
print(plot1)
###Objective 2: Distribution and Hotspots (Skewness)
# Plot 2: Distribution of Capacity Per Person (Identifying Skewness/Hotspots)
plot2 <- ggplot(combined_analysis, aes(x = Total_Cap_Per_Person_2024)) +
  geom_histogram(bins = 30, fill = "steelblue", color = "white") +
  geom_vline(aes(xintercept = mean(Total_Cap_Per_Person_2024, na.rm=TRUE)), 
             color="red", linetype="dashed", size=1) +
  labs(
    title = "Distribution of Renewable Capacity Per Capita (2024)",
    subtitle = "Right-skew indicates 'Hotspots' (few LAs with very high capacity)",
    x = "Capacity Per Person",
    y = "Count of Local Authorities"
  ) +
  theme_minimal()

# Export Plot 2
ggsave("Figure2_Distribution.png", plot = plot2, width = 8, height = 5)
print(plot2)

#objective 3: Socio-Economic Correlations
# Plot 3: Scatter Plot - Income vs Renewable Capacity
# We use log scale for capacity if the data is highly skewed
plot3 <- ggplot(combined_analysis, aes(x = GDHI_PH, y = Total_Cap_Per_Person_2024)) +
  geom_point(alpha = 0.6, color = "darkgreen") +
  geom_smooth(method = "lm", color = "red") + # Adds a regression line
  labs(
    title = "Correlation: Income vs. Renewable Capacity (2024)",
    subtitle = "Does wealthier imply greener?",
    x = "Median Income",
    y = "Total Capacity Per Person"
  ) +
  theme_minimal()

# Plot 4: Scatter Plot - Education vs Renewable Capacity
plot4 <- ggplot(combined_analysis, aes(x = `Batchalors_degree_or_higher_(%)`, y = Total_Cap_Per_Person_2024)) +
  geom_point(alpha = 0.6, color = "purple") +
  geom_smooth(method = "lm", color = "red") +
  labs(
    title = "Correlation: Education vs. Renewable Capacity (2024)",
    x = "% Bachelors Degree or Higher",
    y = "Total Capacity Per Person"
  ) +
  theme_minimal()

# Arrange and Export correlations next to each other
combined_correlations <- grid.arrange(plot3, plot4, ncol = 2)
ggsave("Figure3_SocioEco_Correlations.png", plot = combined_correlations, width = 12, height = 5)


# --- Part 4: Regression Analysis ---

#scale Income (divide by 1000) to make coefficients more readable
model <- lm(Total_Cap_Per_Person_2024 ~ I(GDHI_PH/1000) + `Batchalors_degree_or_higher_(%)`, data = combined_analysis)


summary(model)
