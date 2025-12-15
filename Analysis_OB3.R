install.packages("stargazer")
library("stargazer")


Analysis_OB3


Combined_Data <- Combined_Data %>%
  mutate(
    income_group = ntile(GDHI_PH, 3) %>%
      factor(labels = c("Low income", "Middle income", "High income"))
  )

Combined_Data %>%
  group_by(income_group) %>%
  summarise(
    mean_pc = mean(total_pc_2024, na.rm = TRUE),
    median_pc = median(total_pc_2024, na.rm = TRUE),
    sd_pc = sd(total_pc_2024, na.rm = TRUE),
    n = n()
  )

ggplot(Combined_Data, aes(x = GDHI_PH, y = total_pc_2024)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    x = "GDHI per Head (£)",
    y = "Per-Capita Renewable Capacity",
    title = "Income and Renewable Energy Capacity"
  )

ggplot(Combined_Data, aes(
  x = `Batchalors_degree_or_higher_(%)`,
  y = total_pc_2024
)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    x = "Population with Bachelor’s Degree or Higher (%)",
    y = "Per-Capita Renewable Capacity",
    title = "Education and Renewable Energy Capacity"
  )



ggplot(Combined_Data, aes(
  x = Mean_age,
  y = total_pc_2024
)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    x = "Population average age",
    y = "Per-Capita Renewable Capacity",
    title = "Age and Renewable Energy Capacity"
  )



m1 <- lm(total_pc_2024 ~ GDHI_PH, data = Combined_Data)
summary(m1)
m2 <- lm(total_pc_2024 ~ `Batchalors_degree_or_higher_(%)`, data = Combined_Data)
summary(m2)
m3 <- lm(total_pc_2024 ~ Mean_age, data = Combined_Data)
summary(m3)
m4 <- lm(total_pc_2024 ~ GDHI_PH + `Batchalors_degree_or_higher_(%)` + Mean_age, data = Combined_Data)
summary(m4)

installed.packages("stargazer")
libary("stargazer")


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

