library(tidyverse)
library(lubridate)
data <- read.csv('data/AIDData.csv')
data <- data %>% mutate(Subject = as.numeric(Subject),
                DOB = as.Date(DOB),
                Sex = na_if(Sex, ""),
                Date_Dx = as.Date(Date_Dx),
                Prolactin_Dx = as.numeric(Prolactin_Dx),
                Largest_d = as.numeric(Largest_d),
                AID_Y_N = trimws(AID_Y_N))%>%
                mutate(Age_Dx = year(as.period(interval(as.Date(DOB), as.Date(Date_Dx)))))
#view(data)


#check if we do not have trailing spaces for string variables
unique(data$Ethnicity)
unique(data$case)
unique(data$Sex)
unique(data$AID_Y_N)


