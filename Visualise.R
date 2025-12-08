#This file is currently used to work out calculations and visualisations

library(tidyverse)

Summary_Table <- Combined_Data %>%
  select(where(is.numeric))%>%
  pivot_longer(everything(), names_to = "Variable", values_to = "Value") %>%
  group_by(Variable) %>%
  summarise(
    Mean = mean(Value, na.rm = TRUE),
    Median = median(Value, na.rm = TRUE),
    SD = sd(Value, na.rm = TRUE),
    Max = max(Value, na.rm = TRUE),
    Min = min(Value, na.rm = TRUE),
    Count = n())

head(summary_data)

install.packages("ggplot2")
library(ggplot2)

#Lets do some comparison
ggplot(Combined_Data, aes(x = 'Income_2021', y = 'Total_Generation_Output')) +
  geom_point() +
  labs(title = "Scatter plot of Income vs Generation",
       x = "Income 2021",
       y = "Total Generation Output") +
  theme_minimal()

ggplot(Combined_Data, aes(x = Income_2021, y = Total_Generation_Output)) +
  geom_point(color = "blue") +
  scale_y_log10() +
  theme_minimal() +
  labs(
    x = "Income_2021",
    y = "Total Generation Output (log scale)",
    title = "Income vs Total Generation Output")


plot(
  Combined_Data$Income_2021,
  Combined_Data$'Total Generation Output',
  xlab = "Income (2021)",
  ylab = "Total Generation Output",
  main = "Income vs Generation Output",
  pch = 19,
  col = "blue",
  log = "y")


q <- quantile(data$'Total Generation Output', 0.99)

filtered <- subset(data, Total.Generation.Output < q)

plot(filtered$Income_2021, filtered$Total.Generation.Output,
     pch = 19, col = "blue")
  
Combined_Data$Income_2021 <- as.numeric(Combined_Data$Income_2021)
Combined_Data$Total.Generation.Output <- as.numeric(Combined_Data$'Total Generation Output')
  
Combined_Data$'Total Generation Output' <- gsub("[^0-9.]", "", Combined_Data$'Total Generation Output')
Combined_Data$'Income_2021' <- gsub("[^0-9.]", "", Combined_Data$'Income_2021') 
str(Combined_Data2)



Combined_Data$'Total Generation Output' <- as.numeric(Combined_Data$'Total Generation Output')
Combined_Data$Income_2021 <- as.numeric(Combined_Data$Income_2021)

is.numeric(Combined_Data$'Total Generation Output')
is.numeric(Combined_Data$Income_2021)
str(Combined_Data)


#boxplot time
ggplot(Combined_Data, aes(x = factor(0), y = Total_Generation_Output)) +
  geom_boxplot(fill = "lightblue", color = "darkblue") +
  scale_y_log10() +
  theme_minimal() +
  labs(
    x = "",
    y = "Total Generation Output (log scale)",
    title = "Boxplot of Total Generation Output")
#histogram time
ggplot(Combined_Data, aes(x = Total_Generation_Output)) +
  geom_histogram(binwidth = 1000000, fill = "lightgreen", color = "darkgreen") +
  scale_x_log10() +
  theme_minimal() +
  labs(
    x = "Total Generation Output (log scale)",
    y = "Frequency",
    title = "Histogram of Total Generation Output")
#density plot time
ggplot(Combined_Data, aes(x = Total_Generation_Output)) +
  geom_density(fill = "lightcoral", alpha = 0.7) +
  scale_x_log10() +
  theme_minimal() +
  labs(
    x = "Total Generation Output (log scale)",
    y = "Density",
    title = "Density Plot of Total Generation Output")
#bar chart time

