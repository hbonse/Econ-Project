#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Title: Renewable Energy Generation Distribution in the UK
#
# Purpose: To Analyse the merged data for Objective 3
#
# Outputs:
#   - ob3_summary_by_income_group.csv
#   - ob3_income_vs_renewable_capacity.png
#   - ob3_education_vs_renewable_capacity.png
#   - ob3_age_vs_renewable_capacity.png
#   - ob3_regression_results.html
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Part 6: Analysing the data for Objective 3
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 1)load the libraries that will be used in this file
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
library("stargazer")

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 2) Prepare the needed data for Analysis
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#spliting  the data into income groups
Combined_Data <- Combined_Data %>%
  mutate(
    income_group = ntile(GDHI_PH, 3) %>%
      factor(labels = c("Low income", "Middle income", "High income"))
  )

#summary statistics by income group
ob3_data <- Combined_Data %>%
  group_by(income_group) %>%
  summarise(
    mean_pc = mean(total_pc_2024, na.rm = TRUE),
    median_pc = median(total_pc_2024, na.rm = TRUE),
    sd_pc = sd(total_pc_2024, na.rm = TRUE),
    n = n()
  )
#export to csv
write.csv(ob3_data, "output/OB3/ob3_summary_by_income_group.csv", row.names = FALSE)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 3) Visual Analysis
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 3.1) Scatter plot: Income vs Per-Capita renewable capacity
ggplot(Combined_Data, aes(x = GDHI_PH, y = total_pc_2024)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    x = "GDHI per Head (£)",
    y = "Per-Capita Renewable Capacity",
    title = "Income and\nRenewable Energy Capacity"
  )
#export
ggsave("output/OB3/ob3_income_vs_renewable_capacity.png", width = 8, height = 6)


# 3.2) Scatter plot: Education vs Per-Capita renewable capacity
ggplot(Combined_Data, aes(
  x = `Batchalors_degree_or_higher_(%)`,
  y = total_pc_2024
)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    x = "Population with Bachelor’s Degree or Higher (%)",
    y = "Per Capita Renewable Capacity",
    title = "Education and Renewable\nEnergy Capacity"
  )
#export
ggsave("output/OB3/ob3_education_vs_renewable_capacity.png", width = 8, height = 6)


# 3.3) Scatter plot: Age vs Per-Capita renewable capacity
ggplot(Combined_Data, aes(
  x = Mean_age,
  y = total_pc_2024
)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    x = "Population average age",
    y = "Per Capita Renewable Capacity",
    title = "Age and Renewable\nEnergy Capacity"
  )
#export
ggsave("output/OB3/ob3_age_vs_renewable_capacity.png", width = 8, height = 6)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 4) Regression Analysis
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 4.1) Linear regression analysis
# separate models for each socio-economic variable, and a combined model with all variables
# 4.11) Model 1: Income vs Per-Capita renewable capacity
m1 <- lm(total_pc_2024 ~ GDHI_PH, data = Combined_Data)
summary(m1)
# 4.12) Model 2: Education vs Per-Capita renewable capacity
m2 <- lm(total_pc_2024 ~ `Batchalors_degree_or_higher_(%)`, data = Combined_Data)
summary(m2)
# 4.13) Model 3: Age vs Per-Capita renewable capacity
m3 <- lm(total_pc_2024 ~ Mean_age, data = Combined_Data)
summary(m3)
# 4.14) Model 4: Combined model
m4 <- lm(total_pc_2024 ~ GDHI_PH + `Batchalors_degree_or_higher_(%)` + Mean_age, data = Combined_Data)
summary(m4)

# Export regression results table
# Use stargazer to create a nice table
stargazer(
  m1, m2, m3,
  type = "text",
  title = "Regression Results: Socio-Economic Correlates of Renewable Capacity",
  dep.var.labels = "Per Capita Renewable Capacity (MW per 1,000 people)",
  covariate.labels = c(
    "Income per Head (£)",
    "Bachelor’s Degree or Higher (%)",
    "Mean Age"
  ),
  omit.stat = c("f", "ser"),
  digits = 3
)
# Export as a html file - to put in report
stargazer(
  m1, m2, m3,
  type = "html",
  title = "Regression Results: Socio-Economic Correlates of Renewable Capacity",
  dep.var.labels = "Per-Capita Renewable Capacity (MW per 1,000 people)",
  covariate.labels = c(
    "Income per Head (£)",
    "Bachelor’s Degree or Higher (%)",
    "Mean Age"
  ),
  omit.stat = c("f", "ser"),
  digits = 3,
  out = "output/OB3/ob3_regression_results.html"
)

rm(m1, m2, m3, m4, ob3_data)
#End of file