

# install.packages(c('DHARMa', 'car'))
library('readr')
library('dplyr')
library('DHARMa')
library('car')

df <- read_csv('data/AIDData.csv') %>% mutate(case = as.factor(case)) 
df$Ethnicity_Category <- ifelse(
    df$Ethnicity == "Caucasian",
    "Caucasian",
    "Non-Caucasian"
  )

## Diagnosis of Logistic Regression on not imputed data

#Model
df_no_na <- na.omit(df)
model <- glm(AID_Y_N ~ case + Age_Dx + Sex + Largest_d + Ethnicity_Category, data = df_no_na, family = 'binomial')

#Linearity
df_no_na$logit <- predict(model, type = 'link')
plot(
  df_no_na$Age_Dx, df_no_na$logit,
  main = "Linearity in the Logit (Age_Dx)",
  xlab = "Age at Diagnosis (Age_Dx)",
  ylab = "Estimated logit",
)

plot(
  df_no_na$Largest_d, df_no_na$logit,
  main = "Linearity in the Logit (Largest Diameter)",
  xlab = "Largest Diameter",
  ylab = "Estimated logit",
)


#Multicollinearity
vif(model)

#Cook's Distance
plot(cooks.distance(model),
     main = "Cook's Distance")


#DHARMA
sim_res <- simulateResiduals(
  fittedModel = model,
  n = 1000
)

#Checking residuals
plot(sim_res)
plotResiduals(sim_res, df_no_na$Largest_d)
plotResiduals(sim_res, df_no_na$Age_Dx)
plotResiduals(sim_res, df_no_na$Sex)
plotResiduals(sim_res, df_no_na$Ethnicity_Category)
