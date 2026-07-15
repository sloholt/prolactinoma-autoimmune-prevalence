# install.packages(c('mice', 'howManyImputations', 'DHARMa', 'car'))
library('readr')
library('dplyr')
library('DHARMa')
library('mice')
library('howManyImputations')
library('car')

df <- read_csv('data/AIDData.csv')

df$Sex <- as.factor(df$Sex)
df$case <- as.factor(df$case)
#view(df)

# Select relevant columns
df_mice <- df[,-c(1,2,4,8)]

# Perform multiple imputation
set.seed(123) # For reproducibility
imputed_data <- mice(df_mice, m = 4)
summary(imputed_data)

# Add Ethnicity_Category variable
imputed_data <- complete(imputed_data, "long", include = TRUE) |>
  mutate(Ethnicity_Category = ifelse(Ethnicity == "Caucasian", "Caucasian", "Non-Caucasian"),
         Ethnicity_Category = as.factor(Ethnicity_Category)) |>
  as.mids()


#Imputation Model Diagnostic
densityplot(imputed_data)
bwplot(imputed_data, Largest_d ~ .imp)


# Fit logistic regression model on each imputed dataset
fit <- with(imputed_data, glm(AID_Y_N ~ case + Age_Dx + Sex + Largest_d + Ethnicity_Category,
                              family = binomial()))

# Pool the results
pooled <- pool(fit)
summary(pooled, conf.int = TRUE, exponentiate = TRUE)


#Logistic Regression assumption checks
test_set <- complete(imputed_data, action = 1) # Using the first imputed dataset for assumption checks
model = glm(AID_Y_N ~ case + Age_Dx + Sex + Largest_d + Ethnicity_Category, data=test_set, family = 'binomial')


simulationOutput <- simulateResiduals(fittedModel = model)
plot(simulationOutput, asFactor = F)

# Calculate VIF values
vif_values <- vif(model)

# Print the values
print(vif_values)

logit_vals <- predict(model, type = "link")

cont_vars <- c("Age_Dx",
               "Largest_d")

# 3) Plot each predictor vs. logit with a smooth LOWESS curve
for (v in cont_vars) {
  x <- test_set[[v]]
  plot(x, logit_vals,
       xlab = v,
       ylab = "Logit(Change)",
       main = paste("Logit vs", v))
  lines(lowess(x, logit_vals))
}

testOutliers(simulationOutput)
testDispersion(simulationOutput)
