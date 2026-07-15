# Math 527 W26 - Consulting Group 4 
# Mock Project Descriptive Stats

library(tidyverse)
library(lubridate)
library(readr)
library(ggplot2)

df <- read.csv("data/AIDData.csv")

df$Ethnicity_Category <- ifelse(
  df$Ethnicity == "Caucasian",
  "Caucasian",
  "Non-Caucasian"
)

df <- df %>%
  mutate(across(where(is.character), str_trim)) %>%
  #Recompute age (in years) based on the dates
  mutate(DOB = as.Date(DOB), 
         Date_Dx = as.Date(Date_Dx),
         Age_recomputed = as.numeric(difftime(Date_Dx, DOB, units = 'days'))/365)
  

# Age Distributions: 
age_distribution <- ggplot(df, aes(x = Age_recomputed)) +
  geom_histogram(bins = 30) + 
  labs(
    title = "Distribution of Age", x = "Age", y = "Count"
  )+
  theme_minimal()
age_distribution

age_descriptions <- df %>%
  summarise(
    median_age = median(Age_recomputed, na.rm = TRUE),
    IQR_age = IQR(Age_recomputed, na.rm = TRUE)
  )

# Gender Distributions: 
table(df$Sex, useNA = "ifany")
gender_proportions <- prop.table(table(df$Sex))
100 * gender_proportions

sex_counts <- df %>%
  count(Sex) %>%
  mutate(
    percent = round(n / sum(n) * 100, 1)
  )

sex_counts
print("Total Observations: 215")

# Case Distributions: 

# By Gender: 
case_bySex <- table(df$case, df$Sex)
case_bySex
prop.table(case_bySex, margin = 1)

# By Ethnicity: 
case_byEthnicity <- table(df$case, df$Ethnicity_Category)
case_byEthnicity
prop.table(case_byEthnicity, margin = 1)


# Prolactin Distributions: 
prolactin_distribution <- ggplot(df, aes(x = Prolactin_Dx)) +
  geom_histogram(bins = 30) + 
  labs(
    title = "Distribution of Prolactin", x = "Prolactin", y = "Count"
  )+
  theme_minimal()
prolactin_distribution

prolactin_descriptions <- df %>%
  summarise(
    median_prolactin = median(Prolactin_Dx, na.rm = TRUE),
    IQR_prolactin = IQR(Prolactin_Dx, na.rm = TRUE)
  )
prolactin_descriptions

# Prolactin by gender: 
prolactin_bySex <- df %>%
  filter(!is.na(Sex), Sex != "")%>%
  group_by(Sex) %>%
  summarise(
    n = n(), 
    median_prolactin = median(Prolactin_Dx, na.rm = TRUE),
    IQR_prolactin = IQR(Prolactin_Dx, na.rm = TRUE)
  )
prolactin_bySex

# Prolactin by case: 
prolactin_byCase <- df %>%
  filter(!is.na(case), case != "")%>%
  group_by(case) %>%
  summarise(
    n = n(), 
    median_prolactin = median(Prolactin_Dx, na.rm = TRUE),
    IQR_prolactin = IQR(Prolactin_Dx, na.rm = TRUE)
  )
prolactin_byCase

# Diameter Distributions: 
df$Largest_d <- as.numeric(df$Largest_d)

diameter_distribution <- ggplot(df, aes(x = Largest_d)) +
  geom_histogram(bins = 30) + 
  labs(
    title = "Distribution of Largest Diameters", x = "Largest Diameter", y = "Count"
  )+
  theme_minimal()
diameter_distribution

diameter_descriptions <- df %>%
  summarise(
    median_largest_diameter = median(Largest_d, na.rm = TRUE),
    IQR_largest_diameter = IQR(Largest_d, na.rm = TRUE)
  )
diameter_descriptions

# Prolactin by gender: 
diameter_bySex <- df %>%
  filter(!is.na(Sex), Sex != "")%>%
  group_by(Sex) %>%
  summarise(
    n = n(), 
    median_diameter = median(Largest_d, na.rm = TRUE),
    IQR_diameter = IQR(Largest_d, na.rm = TRUE)
  )
diameter_bySex

# Largest diameters measured by case: 
diameter_byCase <- df %>%
  filter(!is.na(case), case != "")%>%
  group_by(case) %>%
  summarise(
    n = n(), 
    median_diameter = median(Largest_d, na.rm = TRUE),
    IQR_diameter = IQR(Largest_d, na.rm = TRUE)
  )
diameter_byCase

