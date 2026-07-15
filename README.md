# Autoimmune Disease Prevalence in Prolactinomas vs. Non-Functioning Pituitary Adenomas

A statistical consulting project (McGill University) examining whether patients with prolactinomas are more prone to autoimmune disease (AID) than patients with non-functioning pituitary adenomas.

## Background

Prolactin can modulate the immune response, and there is evidence that hyperprolactinemia may precipitate autoimmunity. This project tests the hypothesis that **prolactinoma patients are at higher risk of autoimmune disease** than a comparison group of non-functioning pituitary adenoma patients.

The analysis compares AID prevalence in two groups:

- **PRL** — prolactinoma patients
- **NFPA** — non-functioning pituitary adenoma patients

The outcome is `AID_Y_N` (autoimmune disease present, Y/N), modeled against group membership and the covariates age at diagnosis, sex, ethnicity (Caucasian vs. non-Caucasian), and largest adenoma diameter.

## Repository Structure

```
prolactinoma-autoimmune-prevalence/
├── README.md
├── data/
│   ├── AIDData.csv              # Raw study data
│   └── data_dictionary.md       # Variable definitions
├── R/
│   ├── 01_data_conversion.R     # Clean & type-convert; recompute age at diagnosis
│   ├── 02_descriptive_stats.R   # Summary stats & distribution plots
│   ├── 03_multiple_imputations.R# Imputation (mice) + pooled logistic regression
│   └── 04_diagnostics.R         # Complete-case regression diagnostics
├── docs/
│   ├── project_brief.pdf        # Original project brief
│   └── presentation.pptx        # Summary presentation
```

## Data

See [`data/data_dictionary.md`](data/data_dictionary.md) for the full variable list. Key fields: `case` (PRL/NFPA), `Age_Dx`, `Sex`, `Ethnicity`, `Prolactin_Dx`, `Largest_d`, and the outcome `AID_Y_N`.

Missing values in `Sex`, `Prolactin_Dx`, and `Largest_d` are handled by multiple imputation.

## Analysis Pipeline

Scripts are numbered in run order.

1. **`01_data_conversion.R`** — Convert types, parse dates, trim whitespace, recompute age at diagnosis from `DOB` and `Date_Dx`, and collapse `Ethnicity` into a binary category.
2. **`02_descriptive_stats.R`** — Distributions (age, prolactin, diameter) plus medians/IQRs and cross-tabulations stratified by group, sex, and ethnicity.
3. **`03_multiple_imputations.R`** — Impute missing data with `mice` (`m = 4`, `set.seed(123)`), fit a logistic regression per imputed dataset, and pool with Rubin's rules (odds ratios with CIs). Includes imputation diagnostics.
4. **`04_diagnostics.R`** — Logistic regression diagnostics on complete cases: linearity in the logit, VIF, Cook's distance, and `DHARMa` residual/outlier/dispersion checks.

## Requirements

- **R** ≥ 4.0
- Packages: `tidyverse`, `lubridate`, `readr`, `ggplot2`, `mice`, `howManyImputations`, `DHARMa`, `car`

```r
install.packages(c("tidyverse", "lubridate", "readr", "ggplot2",
                   "mice", "howManyImputations", "DHARMa", "car"))
```

## Running the Analysis

```r
source("R/01_data_conversion.R")
source("R/02_descriptive_stats.R")
source("R/03_multiple_imputations.R")
source("R/04_diagnostics.R")
```

## Project Context

Course: **MATH 527 — Statistical Consulting (Winter 2026) McGill University**. This is a mock consulting project; the data and results are for educational use.
