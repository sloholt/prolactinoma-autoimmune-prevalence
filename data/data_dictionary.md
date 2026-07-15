# Data Dictionary — `AIDData.csv`

One row per subject. Comma-delimited, UTF-8.

| Column | Type | Description | Values / Units |
|--------|------|-------------|----------------|
| `Subject` | integer | Subject identifier | — |
| `case` | factor | Adenoma group | `PRL` (prolactinoma), `NFPA` (non-functioning pituitary adenoma) |
| `DOB` | date | Date of birth | `YYYY-MM-DD` |
| `Age_Dx` | integer | Age at diagnosis of pituitary adenoma | years |
| `Sex` | factor | Patient sex | `F`, `M` (may contain missing values) |
| `Ethnicity` | string | Reported ethnicity (raw) | e.g. `Caucasian`, `Arabic`, `Hispano`, … |
| `Date_Dx` | date | Date of adenoma diagnosis | `YYYY-MM-DD` |
| `Prolactin_Dx` | numeric | Prolactin level at diagnosis | lab units |
| `Largest_d` | numeric | Largest adenoma diameter on imaging at diagnosis | mm |
| `AID_Y_N` | factor | Autoimmune disease present | `Y`, `N` |

## Derived variables (created in scripts)

| Variable | Created in | Definition |
|----------|-----------|------------|
| `Ethnicity_Category` | `02`, `03`, `04` | `Caucasian` if `Ethnicity == "Caucasian"`, else `Non-Caucasian` |
| `Age_recomputed` | `02_descriptive_stats.R` | Age in years from `difftime(Date_Dx, DOB)` / 365 |
| `Age_Dx` (recomputed) | `01_data_conversion.R` | Age at diagnosis recomputed from the `DOB`–`Date_Dx` interval |

## Notes

- The file has a UTF-8 byte-order mark (BOM) and CRLF line endings.
- `Sex` contains at least one blank value; scripts treat empty strings as `NA`.
- Missing values in `Sex`, `Prolactin_Dx`, and `Largest_d` are handled via multiple imputation in `03_multiple_imputations.R`.
