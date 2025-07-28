# Load required library
library(dplyr)

# Define risk factors and their weights (from Appendix.pdf)
risk_factors <- c(
  economic_disadvantage = 0.458,
  homeless = 0.631,
  foster_care = 0.751,
  migrant = 0.128,
  ell = 0.800,
  academic_underperformance = 0.652,
  incarceration_delinquency = 0.460,
  teen_pregnancy = 1.0,
  chronic_absenteeism = 0.722
)

# Function to calculate ARC using aggregate data
calculate_arc_aggregate <- function(data, campus_col, total_students_col, risk_count_cols, rate_cols = c("chronic_absenteeism")) {
  # Filter to avoid division by zero
  data <- data %>%
    filter(.data[[total_students_col]] > 0)
  
  # Sum of all weights for normalization
  total_weights <- sum(risk_factors)
  
  # Calculate ARC for each campus
  arc_results <- data %>%
    # Create proportion columns for count-based risks
    mutate(across(all_of(risk_count_cols), 
                  ~ .x / .data[[total_students_col]], 
                  .names = "prop_{.col}")) %>%
    # Create proportion for rate-based cols (e.g., chronic_absenteeism / 100)
    mutate(prop_chronic_absenteeism = chronic_absenteeism / 100) %>%  # Assuming 'chronic_absenteeism' is in %
    # Calculate weighted sum explicitly, handling NA with coalesce
    mutate(
      weighted_sum = (
        coalesce(prop_economic_disadvantage, 0) * risk_factors["economic_disadvantage"] +
          coalesce(prop_homeless, 0) * risk_factors["homeless"] +
          coalesce(prop_foster_care, 0) * risk_factors["foster_care"] +
          coalesce(prop_migrant, 0) * risk_factors["migrant"] +
          coalesce(prop_ell, 0) * risk_factors["ell"] +
          coalesce(prop_academic_underperformance, 0) * risk_factors["academic_underperformance"] +
          coalesce(prop_incarceration_delinquency, 0) * risk_factors["incarceration_delinquency"] +
          coalesce(prop_teen_pregnancy, 0) * risk_factors["teen_pregnancy"] +
          coalesce(prop_chronic_absenteeism, 0) * risk_factors["chronic_absenteeism"]
      )
    ) %>%
    # Calculate ARC
    mutate(arc = (weighted_sum / total_weights) * 100) %>%
    # Select relevant columns
    select({{campus_col}}, arc)
  
  return(arc_results)
}
