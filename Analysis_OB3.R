#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Title: Renewable Energy Generation Distribution in the UK
#
# Purpose: To merge all the data into 1 table
#
# Authors: Hugo Bonsey
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Part 6: Analysing the data for Objective 3
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 1)load the libraries that will be used in this file
library("stargazer")


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

#scatter plots and linear regression lines
# Income vs per-capita renewable capacity
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

# Education vs per-capita renewable capacity
ggplot(Combined_Data, aes(
  x = `Batchalors_degree_or_higher_(%)`,
  y = total_pc_2024
)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    x = "Population with Bachelor’s Degree or Higher (%)",
    y = "Per-Capita Renewable Capacity",
    title = "Education and Renewable\nEnergy Capacity"
  )
#export
ggsave("output/OB3/ob3_education_vs_renewable_capacity.png", width = 8, height = 6)

# Age vs per-capita renewable capacity
ggplot(Combined_Data, aes(
  x = Mean_age,
  y = total_pc_2024
)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    x = "Population average age",
    y = "Per-Capita Renewable Capacity",
    title = "Age and Renewable\nEnergy Capacity"
  )
#export
ggsave("output/OB3/ob3_age_vs_renewable_capacity.png", width = 8, height = 6)


# 3) Linear regression analysis
# separate models for each socio-economic variable, and a combined model with all variables
m1 <- lm(total_pc_2024 ~ GDHI_PH, data = Combined_Data)
summary(m1)
m2 <- lm(total_pc_2024 ~ `Batchalors_degree_or_higher_(%)`, data = Combined_Data)
summary(m2)
m3 <- lm(total_pc_2024 ~ Mean_age, data = Combined_Data)
summary(m3)
m4 <- lm(total_pc_2024 ~ GDHI_PH + `Batchalors_degree_or_higher_(%)` + Mean_age, data = Combined_Data)
summary(m4)


# 4) Export regression results table
# Use stargazer to create a nice table
stargazer(
  m1, m2, m3,
  type = "text",
  title = "Regression Results: Socio-Economic Correlates of Renewable Capacity",
  dep.var.labels = "Per-Capita Renewable Capacity (MW per 1,000 people)",
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