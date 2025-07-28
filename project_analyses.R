# Load required libraries
library(dplyr)    # For data manipulation
library(readr)    # For reading CSV files
library(ggplot2)  # For visualizations
library(car)      # For VIF (multicollinearity check)
library(MASS)     # For stepwise regression

# Options
export_results <- TRUE  # Set to TRUE to save summary CSV
remove_outliers <- TRUE  # Set to TRUE to exclude 'special' schools

# Step 1: Load data
data <- read_csv("at_risk_data_with_arc.csv", show_col_types = FALSE)

# Preview data
cat("Data Preview:\n")
head(data)
summary(data)

# Create proportion columns (excluding chronic_absenteeism, already %)
data <- data %>%
  mutate(
    prop_economic_disadvantage = economic_disadvantage / total_students,
    prop_homeless = homeless / total_students,
    prop_foster_care = foster_care / total_students,
    prop_migrant = migrant / total_students,
    prop_ell = ell / total_students,
    prop_academic_underperformance = academic_underperformance / total_students,
    prop_incarceration_delinquency = incarceration_delinquency / total_students,
    prop_teen_pregnancy = teen_pregnancy / total_students
  )

# Create filtered dataset
data_no_outliers <- data %>% filter(school_level != "special")
cat("Original n:", nrow(data), "Filtered n:", nrow(data_no_outliers), "\n")

if (remove_outliers) {
  data <- data_no_outliers
  cat("Using filtered data ('special' schools removed).\n")
}

# Create group_level for secondary
data <- data %>%
  mutate(group_level = ifelse(school_level %in% c("middle school", "high school"), "secondary", school_level))

# Elementary and Secondary subsets for analyses
all_data <- data
elementary_data <- all_data %>% filter(school_level == "elementary school")
secondary_data <- all_data %>% filter(group_level == "secondary")

# --------------------------------------------------------------------------------
# Group-Specific Visualizations and Tests (not included in final report)

# Boxplots
cat("Boxplot for All Schools:\n")
ggplot(all_data, aes(y = arc)) +
  geom_boxplot(fill = "lightblue") +
  labs(title = "Boxplot of ARC - All Schools", y = "ARC") +
  theme_minimal()
ggsave("boxplot_arc_all.png")

cat("Boxplot for Elementary Schools:\n")
ggplot(elementary_data, aes(y = arc)) +
  geom_boxplot(fill = "lightblue") +
  labs(title = "Boxplot of ARC - Elementary Schools", y = "ARC") +
  theme_minimal()
ggsave("boxplot_arc_elementary.png")

cat("Boxplot for Secondary Schools:\n")
ggplot(secondary_data, aes(y = arc)) +
  geom_boxplot(fill = "lightblue") +
  labs(title = "Boxplot of ARC - Secondary Schools", y = "ARC") +
  theme_minimal()
ggsave("boxplot_arc_secondary.png")

# Histograms
cat("Histogram for All Schools:\n")
ggplot(all_data, aes(x = arc)) +
  geom_histogram(fill = "lightblue", bins = 20) +
  labs(title = "Histogram of ARC Values - All Schools", x = "ARC") +
  theme_minimal()
ggsave("hist_arc_all.png")

cat("Histogram for Elementary Schools:\n")
ggplot(elementary_data, aes(x = arc)) +
  geom_histogram(fill = "lightblue", bins = 20) +
  labs(title = "Histogram of ARC Values - Elementary Schools", x = "ARC") +
  theme_minimal()
ggsave("hist_arc_elementary.png")

cat("Histogram for Secondary Schools:\n")
ggplot(secondary_data, aes(x = arc)) +
  geom_histogram(fill = "lightblue", bins = 20) +
  labs(title = "Histogram of ARC Values - Secondary Schools", x = "ARC") +
  theme_minimal()
ggsave("hist_arc_secondary.png")

# Shapiro-Wilk Tests
if (nrow(all_data) > 3) {
  cat("Shapiro-Wilk Test for All Schools:\n")
  print(shapiro.test(all_data$arc))
} else {
  cat("Shapiro-Wilk Test for All Schools skipped: insufficient data (n <= 3).\n")
}

if (nrow(elementary_data) > 3) {
  cat("Shapiro-Wilk Test for Elementary Schools:\n")
  print(shapiro.test(elementary_data$arc))
} else {
  cat("Shapiro-Wilk Test for Elementary Schools skipped: insufficient data (n <= 3).\n")
}

if (nrow(secondary_data) > 3) {
  cat("Shapiro-Wilk Test for Secondary Schools:\n")
  print(shapiro.test(secondary_data$arc))
} else {
  cat("Shapiro-Wilk Test for Secondary Schools skipped: insufficient data (n <= 3).\n")
}

# QQ Plots
cat("QQ Plot for All Schools:\n")
ggplot(all_data, aes(sample = arc)) +
  stat_qq() +
  stat_qq_line() +
  labs(title = "QQ Plot - All Schools") +
  theme_minimal()
ggsave("qqplot_arc_all.png")

cat("QQ Plot for Elementary Schools:\n")
ggplot(elementary_data, aes(sample = arc)) +
  stat_qq() +
  stat_qq_line() +
  labs(title = "QQ Plot - Elementary Schools") +
  theme_minimal()
ggsave("qqplot_arc_elementary.png")

cat("QQ Plot for Secondary Schools:\n")
ggplot(secondary_data, aes(sample = arc)) +
  stat_qq() +
  stat_qq_line() +
  labs(title = "QQ Plot - Secondary Schools") +
  theme_minimal()
ggsave("qqplot_arc_secondary.png")

# High/Low Absenteeism Histograms
all_data <- all_data %>%
  mutate(absent_group = ifelse(chronic_absenteeism > 6, "High (>6%)", "Low (<=6%)"))
high_absent_all <- all_data %>% filter(absent_group == "High (>6%)")
low_absent_all <- all_data %>% filter(absent_group == "Low (<=6%)")

cat("High Absenteeism Hist for All Schools:\n")
ggplot(high_absent_all, aes(x = arc)) +
  geom_histogram(fill = "red", bins = 15) +
  labs(title = "ARC for High Absenteeism - All Schools", x = "ARC") +
  theme_minimal()
ggsave("hist_high_absent_all.png")

cat("Low Absenteeism Hist for All Schools:\n")
ggplot(low_absent_all, aes(x = arc)) +
  geom_histogram(fill = "green", bins = 15) +
  labs(title = "ARC for Low Absenteeism - All Schools", x = "ARC") +
  theme_minimal()
ggsave("hist_low_absent_all.png")

elementary_data <- elementary_data %>%
  mutate(absent_group = ifelse(chronic_absenteeism > 6, "High (>6%)", "Low (<=6%)"))
high_absent_elem <- elementary_data %>% filter(absent_group == "High (>6%)")
low_absent_elem <- elementary_data %>% filter(absent_group == "Low (<=6%)")

cat("High Absenteeism Hist for Elementary Schools:\n")
ggplot(high_absent_elem, aes(x = arc)) +
  geom_histogram(fill = "red", bins = 15) +
  labs(title = "ARC for High Absenteeism - Elementary", x = "ARC") +
  theme_minimal()
ggsave("hist_high_absent_elem.png")

cat("Low Absenteeism Hist for Elementary Schools:\n")
ggplot(low_absent_elem, aes(x = arc)) +
  geom_histogram(fill = "green", bins = 15) +
  labs(title = "ARC for Low Absenteeism - Elementary", x = "ARC") +
  theme_minimal()
ggsave("hist_low_absent_elem.png")

secondary_data <- secondary_data %>%
  mutate(absent_group = ifelse(chronic_absenteeism > 6, "High (>6%)", "Low (<=6%)"))
high_absent_sec <- secondary_data %>% filter(absent_group == "High (>6%)")
low_absent_sec <- secondary_data %>% filter(absent_group == "Low (<=6%)")

cat("High Absenteeism Hist for Secondary Schools:\n")
ggplot(high_absent_sec, aes(x = arc)) +
  geom_histogram(fill = "red", bins = 15) +
  labs(title = "ARC for High Absenteeism - Secondary", x = "ARC") +
  theme_minimal()
ggsave("hist_high_absent_sec.png")

cat("Low Absenteeism Hist for Secondary Schools:\n")
ggplot(low_absent_sec, aes(x = arc)) +
  geom_histogram(fill = "green", bins = 15) +
  labs(title = "ARC for Low Absenteeism - Secondary", x = "ARC") +
  theme_minimal()
ggsave("hist_low_absent_sec.png")

# --------------------------------------------------------------------------------
# Analysis 1: Normal Distribution (Module 1)
# Research Question: What minimum ARC value would a school have in order to be in the top quartile of schools? 
# What minimum ARC value would an elementary school need to have in order to be in the top quartile of elementary schools?
# Added: What minimum ARC value would a secondary school need to have in order to be in the top quartile of secondary schools?
top_quartile_min_all <- quantile(all_data$arc, probs = 0.75, na.rm = TRUE)
cat("Minimum ARC value for top quartile (all schools):", top_quartile_min_all, "\n")

top_quartile_min_elementary <- quantile(elementary_data$arc, probs = 0.75, na.rm = TRUE)
cat("Minimum ARC value for top quartile (elementary schools):", top_quartile_min_elementary, "\n")

top_quartile_min_secondary <- quantile(secondary_data$arc, probs = 0.75, na.rm = TRUE)
cat("Minimum ARC value for top quartile (secondary schools):", top_quartile_min_secondary, "\n")

# --------------------------------------------------------------------------------
# Analysis 2: Confidence Interval Estimation (Module 2)
if (nrow(secondary_data) > 1) {
  ci_secondary <- t.test(secondary_data$arc, conf.level = 0.95)$conf.int
  cat("95% CI for mean ARC in secondary schools:", ci_secondary[1], "to", ci_secondary[2], "\n")
} else {
  cat("Secondary CI skipped: insufficient data.\n")
}

if (nrow(elementary_data) > 1) {
  ci_elementary <- t.test(elementary_data$arc, conf.level = 0.95)$conf.int
  cat("95% CI for mean ARC in elementary schools:", ci_elementary[1], "to", ci_elementary[2], "\n")
} else {
  cat("Elementary CI skipped: insufficient data.\n")
}

# --------------------------------------------------------------------------------
# Analysis 3: Hypothesis Testing (Module 4)
if (nrow(high_absent_all) > 0 && nrow(low_absent_all) > 0) {
  t_test_result <- t.test(arc ~ absent_group, data = all_data, var.equal = FALSE)
  cat("T-Test for ARC by Absenteeism Group:\n")
  print(t_test_result)
} else {
  cat("T-Test skipped: insufficient data in high/low absenteeism groups.\n")
}

# --------------------------------------------------------------------------------
# Analysis 4: Multiple Regression (Module 5)
# Research Question: Which risk factors most strongly predict chronic absenteeism? 
# Which risk factors most strongly predict chronic absenteeism in elementary schools?

# Full model (all schools, testing all variables)
model_full <- lm(chronic_absenteeism ~ prop_economic_disadvantage + prop_homeless +
                   prop_foster_care + prop_migrant + prop_ell +
                   prop_academic_underperformance + prop_incarceration_delinquency +
                   prop_teen_pregnancy, data = all_data)
cat("Regression Summary for Full Data:\n")
print(summary(model_full))

# Stepwise full model (all schools)
step_model_full <- step(model_full, direction = "both", trace = 0)
cat("Stepwise Regression Summary for Full Data:\n")
print(summary(step_model_full))

# Elementary model (excluding teen_pregnancy as it’s zero)
model_elementary <- lm(chronic_absenteeism ~ prop_economic_disadvantage + prop_homeless +
                         prop_foster_care + prop_migrant + prop_ell +
                         prop_academic_underperformance + prop_incarceration_delinquency,
                       data = elementary_data)
cat("Regression Summary for Elementary Schools:\n")
print(summary(model_elementary))

# Stepwise elementary model
step_model_elementary <- step(model_elementary, direction = "both", trace = 0)
cat("Stepwise Regression Summary for Elementary Schools:\n")
print(summary(step_model_elementary))

# Secondary model (secondary schools only, testing all variables)
model_secondary <- lm(chronic_absenteeism ~ prop_economic_disadvantage + prop_homeless +
                        prop_foster_care + prop_migrant + prop_ell +
                        prop_academic_underperformance + prop_incarceration_delinquency +
                        prop_teen_pregnancy, data = secondary_data)
cat("Regression Summary for Secondary Schools:\n")
print(summary(model_secondary))

# Stepwise secondary model
step_model_secondary <- step(model_secondary, direction = "both", trace = 0)
cat("Stepwise Regression Summary for Secondary Schools:\n")
print(summary(step_model_secondary))

# VIF for multicollinearity
cat("VIF for Full Model:\n")
print(vif(model_full))
cat("VIF for Elementary Model:\n")
print(vif(model_elementary))
cat("VIF for Secondary Model:\n")
print(vif(model_secondary))

# RegressionDiagnostics
# All Schools
png("diag_full_residuals.png")
plot(model_full, which = 1, main = "Residuals vs Fitted - All Schools")
dev.off()
png("diag_full_qq.png")
plot(model_full, which = 2, main = "QQ Residuals - All Schools")
dev.off()
png("diag_full_cooks.png")
cooks_d_full <- cooks.distance(model_full)
plot(cooks_d_full, type = "h", main = "Cook's Distance - All Schools", ylab = "Cook's Distance")
abline(h = 4 / nrow(all_data), col = "red")
dev.off()

# Elementary
png("diag_elem_residuals.png")
plot(model_elementary, which = 1, main = "Residuals vs Fitted - Elementary Schools")
dev.off()
png("diag_elem_qq.png")
plot(model_elementary, which = 2, main = "QQ Residuals - Elementary Schools")
dev.off()
png("diag_elem_cooks.png")
cooks_d_elem <- cooks.distance(model_elementary)
plot(cooks_d_elem, type = "h", main = "Cook's Distance - Elementary Schools", ylab = "Cook's Distance")
abline(h = 4 / nrow(elementary_data), col = "red")
dev.off()

# Secondary
png("diag_sec_residuals.png")
plot(model_secondary, which = 1, main = "Residuals vs Fitted - Secondary Schools")
dev.off()
png("diag_sec_qq.png")
plot(model_secondary, which = 2, main = "QQ Residuals - Secondary Schools")
dev.off()
png("diag_sec_cooks.png")
cooks_d_sec <- cooks.distance(model_secondary)
plot(cooks_d_sec, type = "h", main = "Cook's Distance - Secondary Schools", ylab = "Cook's Distance")
abline(h = 4 / nrow(secondary_data), col = "red")
dev.off()

# --------------------------------------------------------------------------------
# Export Results
if (export_results) {
  results_summary <- data.frame(
    Analysis = c(
      "1: Top Quartile ARC (All)", "1: Top Quartile ARC (Elementary)", "1: Top Quartile ARC (Secondary)",
      "2: Secondary CI Lower", "2: Secondary CI Upper",
      "2: Elementary CI Lower", "2: Elementary CI Upper",
      "3: T-Test p-value", "3: Mean ARC High Absent", "3: Mean ARC Low Absent",
      "4: Adj R-squared (Full)", "4: Adj R-squared (Full Stepwise)",
      "4: Adj R-squared (Elementary)", "4: Adj R-squared (Elementary Stepwise)",
      "4: Adj R-squared (Secondary)", "4: Adj R-squared (Secondary Stepwise)",
      "4: Full Significant Predictors",
      "4: Elementary Significant Predictors"
    ),
    Value = c(
      top_quartile_min_all, top_quartile_min_elementary, top_quartile_min_secondary,
      ci_secondary[1], ci_secondary[2],
      ci_elementary[1], ci_elementary[2],
      t_test_result$p.value,
      mean(high_absent_all$arc, na.rm = TRUE), mean(low_absent_all$arc, na.rm = TRUE),
      summary(model_full)$adj.r.squared, summary(step_model_full)$adj.r.squared,
      summary(model_elementary)$adj.r.squared, summary(step_model_elementary)$adj.r.squared,
      summary(model_secondary)$adj.r.squared, summary(step_model_secondary)$adj.r.squared,
      paste(names(coef(model_full))[summary(model_full)$coef[,4] < 0.05][-1], collapse = ", "),
      paste(names(coef(model_elementary))[summary(model_elementary)$coef[,4] < 0.05][-1], collapse = ", ")
    )
  )
  
  write_csv(results_summary, "analysis_results_summary.csv")
  cat("Results exported to 'analysis_results_summary.csv'.\n")
}
