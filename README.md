# Student At-Risk Data Analysis for Austin Independent School District

#### Introduction

‘Every Student Succeeds Act (ESSA), Title I’ defines “at-risk student” as a student at risk of academic failure. Texas Education Code §29.081 interprets an at-risk student as a “student at risk of dropping out of school’ and as such, defines a list of parameters aligned with federal law used to categorize students and assign services. Each parameter is assigned a code within the Public Education Information Management System (PEIMS), and through this mechanism student data is reported to state and federal education agencies for use in administering the block grants that fund services in Local Education Agencies (LEAs). The data derived from PEIMs At-Risk codes is used by decision makers for a wide variety of use cases, including those related to decisions of equitable grant allocation and program evaluation.

Due to the many factors that fall under the category of “at-risk”, as well as the diversity of campus characteristics, it can be difficult to compare and contrast the level of need for campuses across a school district, state, or the national level. Considering this problem, one can pose two related research questions: “can at-risk indicators of a campus be aggregated and transformed into an At-Risk Coefficient (ARC) for use in comparing campuses for purposes of decision making and program evaluation within an LEA and at the state and federal level? And related, “can the central limit theorem, confidence intervals, hypothesis testing, and multiple regression analysis be used to better understand, calibrate, and refine the derived ARC?”

#### Methodology

In order to approach this problem, a table of campus-level at-risk student data for each campus in Austin ISD was compiled from six standard reports exported from the district’s Student Information System (SIS) *(see [Data Sources](https://drive.google.com/drive/folders/1q6Yv7wxb6xZzHh344kPvB2MTc-hstmE2?usp=sharing) and [Appendix for “Mapping at\_risk data to derived sources”](https://docs.google.com/document/d/15e-tgXUnR9YhntkTvVplupV707vM7Gw2CrfmP3JnYwM/edit?usp=sharing))*. These reports provide data on various risk factors that contribute to a student’s likelihood of dropping out of school. 

To ensure the At-Risk Coefficient (ARC) accurately reflects the impact of each factor on dropout risk, specific weights are assigned to each factor based on empirical research *(see [Appendix for “Research on Risk Factors and Dropout Rates” and “Research-Based Weights”](https://docs.google.com/document/d/15e-tgXUnR9YhntkTvVplupV707vM7Gw2CrfmP3JnYwM/edit?usp=sharing)).*

To calculate the campus-level at-risk coefficient (ARC), the following formula is used, utilizing the research derived weights for each risk category:  
ARC \= j=1J(njNwj)j=1Jwj100

Where:

* N= Total number of students on the campus.  
* J= Number of risk categories  
* nj= Number of students in risk category j  
* wj= Weight assigned to risk category j  
* njN= Proportion of students in risk category j

###### *Note: the following statistical analysis will be performed on at\_risk\_data\_with\_arc.csv*

#### Analysis 1: Normal Distribution (Module 1\)

Research Question: What minimum ARC value would a school have in order to be in the top quartile of schools? What minimum ARC value would an elementary school need to have in order to be in the top quartile of elementary schools?

#### Analysis 2: Confidence Interval of Estimation (Module 2\)

Research Question: What is the 95% confidence interval for the mean ARC among secondary (middle and high) schools compared to elementary schools?

#### Analysis 3: Hypothesis Testing (Module 4\)

Research Question: Is the mean ARC significantly different between schools with high chronic absenteeism (greater than 6%) and those with low chronic absenteeism (less than 6%)?

#### Analysis 4: Multiple Regression (Module 5\)

Research Question: Which risk factors most strongly predict chronic absenteeism? Which risk factors most strongly predict chronic absenteeism in elementary schools?

#### Calculations

The calculations of ARC and Analyses 1-4 will be computed using the statistical software language ‘R’.

#### Considerations for Future Developments

To ensure ARC effectively compares campus needs in Austin ISD and is a valid predictor of dropout risk, research-based weights for risk factors could be validated using a correlation analysis between ARC and the actual dropout rate, and a multiple regression analysis for dropout rate against each at-risk variable. If discrepancies arise, weights could be adjusted and ARC recalculated with updated weights, repeating analyses 1-4 for comparison, and iterating this process until ARC optimally balances research evidence and local data.

#### Considerations for Data Quality

Additional context may be necessary for an appropriate analysis. For example, the sub categories of homeless or foster may be relevant to how a student is weighted in ARC, or the differences between risk factors at different student ages.

# Data Analysis for At-Risk Student Coefficient (ARC) in Austin ISD

### **Overview**

This project analyzes at-risk student data from Austin Independent School District (AISD) to develop and evaluate an At-Risk Coefficient (ARC), a weighted aggregate score for comparing campuses' risk levels and informing resource allocation. Data was compiled from AISD reports (n=120 campuses, filtered to n=108 excluding special schools) on factors like economic disadvantage, homelessness, and chronic absenteeism. ARC is calculated using research-based weights (see appendix for details and formula), applied via R software. Analyses cover Modules 1 (normal distribution), 2 (confidence intervals), 4 (hypothesis testing with multiple samples), and 5 (multiple regression). Subsets include elementary (n=77) and secondary (n=31) schools. Detailed dataset, R code, and outputs are in the appendix.

### **Analysis 1: Normal Distribution (Module 1\)**

**Research Question:** What minimum ARC value places a school in the top quartile overall? For elementary schools only? For secondary schools only?

Using quantiles on ARC distributions:

* All schools: Minimum ARC for top quartile is 21.40.  
* Elementary schools: Minimum ARC for top quartile is 19.67.  
* Secondary schools: Minimum ARC for top quartile is 26.54.

In simple terms, secondary schools tend to have higher ARC due to factors like teen pregnancy and end-of-course exam failures, which don't affect elementary schools. This suggests it is best to compare schools within the same level for fair evaluations.

### **Analysis 2: Confidence Interval Estimation (Module 2\)**

**Research Question:** What is the 95% confidence interval for mean ARC in secondary vs. elementary schools?

T-tests provided intervals:

* Secondary: 15.31 to 21.90.  
* Elementary: 12.21 to 15.40.

The minimal overlap indicates likely differences in average risk levels. In layman's terms, we're 95% confident secondary schools face more at-risk challenges overall, supporting targeted support like counseling programs for older students.

### **Analysis 3: Hypothesis Testing (Module 4\)**

**Research Question:** Is mean ARC significantly different between schools with high (\>6%) vs. low (≤6%) chronic absenteeism?

A two-sample t-test (Welch, assuming unequal variances) compared groups (high: n=41, low: n=67):

* t \= 6.44, df \= 70.96, p-value \= 1.22e-08.  
* Mean ARC: High \= 21.20, Low \= 12.53.  
* 95% CI for difference: 5.98 to 11.35.

The very small p-value rejects the null hypothesis of no difference. In plain terms, schools with over 6% absenteeism have much higher overall risk, making absenteeism a clear red flag for broader issues like family instability.

### **Analysis 4: Multiple Regression (Module 5\)**

**Research Question:** Which risk factors most strongly predict chronic absenteeism across all schools? In elementary schools? In secondary schools?

Multiple linear regression models predicted absenteeism using proportion-based risk factors (R software; adjusted R-squared values indicate strong fits).

* **All Schools (Adjusted R² \= 0.771):** Significant predictors (p\<0.05): Homelessness (p=0.017), academic underperformance (p=0.0002), incarceration/delinquency (p=1.52e-05), teen pregnancy (p=0.006). Non-significant: Economic disadvantage, foster care, migrant, ELL. This explains 77.1% of variance; in simple terms, factors like legal issues and poor grades drive absenteeism district-wide.  
* **Elementary (Adjusted R² \= 0.707, excluded teen pregnancy):** Significant: ELL (p=0.005), academic underperformance (p=2.05e-10). Non-significant: Others. Explains 70.7% of variance; language barriers and low performance are key for young students.  
* **Secondary (Adjusted R² \= 0.807):** Significant: Academic underperformance (p=0.035), incarceration/delinquency (p=0.001), teen pregnancy (p=0.016). Non-significant: Others. Explains 80.7% of variance; behavioral and life-event issues dominate for older students.

In layman's terms, predictors vary by level: Elementary needs focus on language/academic support, while secondary requires programs for delinquency and pregnancy. Models are reliable for guiding policies.

### **Key Insights**

ARC enables equitable comparisons, revealing higher risks in secondary schools and links to absenteeism. Recommendations: Tailor interventions (e.g., ELL programs for elementary, anti-delinquency for secondary) and validate weights with local dropout data. For detailed R outputs and analysis, see Data\_Analysis.docx. Run project\_analyses.R in RStudio for additional diagnostics.

# **Data Analysis for At-Risk Student Coefficient (ARC) in Austin ISD**

# 

## Preparation:

To perform the analysis in R, load the required libraries and dataset, ensuring proper data handling.

\> \# Load required libraries  
\> library(dplyr)    \# For data manipulation  
\> library(readr)    \# For reading CSV files  
\> library(ggplot2)  \# For visualizations  
\> library(car)      \# For VIF (multicollinearity check)  
\> library(MASS)     \# For stepwise regression

\> \# Load data  
\> data \<- read\_csv("at\_risk\_data\_with\_arc.csv", show\_col\_types \= FALSE)

\> \# Preview data  
\> cat("Data Preview:\\n")  
\> head(data)  
\> summary(data)

Create proportion columns for each risk indicator (except chronic absenteeism, which is already a percentage) to enable comparisons across campuses of varying sizes.

\> \# Create proportion columns (excluding chronic\_absenteeism, already %)  
\> data \<- data %\>%  
\+  mutate(  
\+    prop\_economic\_disadvantage \= economic\_disadvantage / total\_students,  
\+    prop\_homeless \= homeless / total\_students,  
\+    prop\_foster\_care \= foster\_care / total\_students,  
\+    prop\_migrant \= migrant / total\_students,  
\+    prop\_ell \= ell / total\_students,  
\+    prop\_academic\_underperformance \= academic\_underperformance / total\_students,  
\+    prop\_incarceration\_delinquency \= incarceration\_delinquency / total\_students,  
\+    prop\_teen\_pregnancy \= teen\_pregnancy / total\_students  
\+  )

Filter out 'special' schools (alternative or magnet settings) to avoid skewing results.

\> \# Create filtered dataset (removes 'special' schools if remove\_outliers \= TRUE)  
\> data\_no\_outliers \<- data %\>% filter(school\_level \!= "special")  
\> cat("Original n:", nrow(data), "Filtered n:", nrow(data\_no\_outliers), "\\n")  
Original n: 120 Filtered n: 108

Create subsets for elementary and secondary schools, as ARC measurements differ (e.g., no teen pregnancy or EOC exams in elementary).

\> \# Create group\_level for secondary  
\> data \<- data %\>%  
\+  mutate(group\_level \= ifelse(school\_level %in% c("middle school", "high school"), "secondary", school\_level))  
\>   
\> \# Subsets for analyses  
\> all\_data \<- data  
\> elementary\_data \<- all\_data %\>% filter(school\_level \== "elementary school")  
\> secondary\_data \<- all\_data %\>% filter(group\_level \== "secondary")

Group schools by high (\>6%) and low (≤6%) chronic absenteeism for further analysis.

\> all\_data \<- all\_data %\>%  
\+  mutate(absent\_group \= ifelse(chronic\_absenteeism \> 6, "High (\>6%)", "Low (\<=6%)"))  
\> high\_absent\_all \<- all\_data %\>% filter(absent\_group \== "High (\>6%)")  
\> low\_absent\_all \<- all\_data %\>% filter(absent\_group \== "Low (\<=6%)")

\> elementary\_data \<- elementary\_data %\>%  
\+  mutate(absent\_group \= ifelse(chronic\_absenteeism \> 6, "High (\>6%)", "Low (\<=6%)"))  
\> high\_absent\_elem \<- elementary\_data %\>% filter(absent\_group \== "High (\>6%)")  
\> low\_absent\_elem \<- elementary\_data %\>% filter(absent\_group \== "Low (\<=6%)")

\> secondary\_data \<- secondary\_data %\>%  
\+  mutate(absent\_group \= ifelse(chronic\_absenteeism \> 6, "High (\>6%)", "Low (\<=6%)"))  
\> high\_absent\_sec \<- secondary\_data %\>% filter(absent\_group \== "High (\>6%)")  
\> low\_absent\_sec \<- secondary\_data %\>% filter(absent\_group \== "Low (\<=6%)")

The data is now ready for analysis.

## Analysis 1: Normal Distribution (Module 1\)

### Research Question: What minimum ARC value would a school have in order to be in the top quartile of schools? What minimum ARC value would an elementary school need to have in order to be in the top quartile of elementary schools? What minimum ARC value would a secondary school need to have in order to be in the top quartile of secondary schools?

#### R Code:

\> \# Analysis 1: Normal Distribution (Module 1\)  
\> \# Research Question: What minimum ARC value would a school have in order to be in the top quartile of schools?   
\> \# What minimum ARC value would an elementary school need to have in order to be in the top quartile of elementary schools?  
\> \# What minimum ARC value would a secondary school need to have in order to be in the top quartile of secondary schools?  
\> top\_quartile\_min\_all \<- quantile(all\_data$arc, probs \= 0.75, na.rm \= TRUE)  
\> cat("Minimum ARC value for top quartile (all schools):", top\_quartile\_min\_all, "\\n")  
Minimum ARC value for top quartile (all schools): 21.4047   
\>   
\> top\_quartile\_min\_elementary \<- quantile(elementary\_data$arc, probs \= 0.75, na.rm \= TRUE)  
\> cat("Minimum ARC value for top quartile (elementary schools):", top\_quartile\_min\_elementary, "\\n")  
Minimum ARC value for top quartile (elementary schools): 19.66603   
\>   
\> top\_quartile\_min\_secondary \<- quantile(secondary\_data$arc, probs \= 0.75, na.rm \= TRUE)  
\> cat("Minimum ARC value for top quartile (secondary schools):", top\_quartile\_min\_secondary, "\\n")  
Minimum ARC value for top quartile (secondary schools): 26.53917

#### Results and Interpretation:

The minimum ARC for the top quartile across all schools is 21.40. For elementary schools, it is 19.67, and for secondary schools, it is 26.54. In plain terms, this means secondary schools generally have higher ARC values due to factors like EOC exam failures and teen pregnancies, which do not apply to elementary schools. This highlights the need to compare schools within similar levels when using ARC for resource allocation or evaluation.

## Analysis 2: Confidence Interval of Estimation (Module 2\)

### Research Question: What is the 95% confidence interval for the mean ARC among secondary (middle and high) schools compared to elementary schools?

#### R Code:

\> \# Analysis 2: Confidence Interval Estimation (Module 2\)  
\> if (nrow(secondary\_data) \> 1\) {  
\+  ci\_secondary \<- t.test(secondary\_data$arc, conf.level \= 0.95)$conf.int  
\+  cat("95% CI for mean ARC in secondary schools:", ci\_secondary\[1\], "to", ci\_secondary\[2\], "\\n")  
\+ } else {  
\+  cat("Secondary CI skipped: insufficient data.\\n")  
\+ }  
95% CI for mean ARC in secondary schools: 15.31208 to 21.89703   
\>   
\> if (nrow(elementary\_data) \> 1\) {  
\+  ci\_elementary \<- t.test(elementary\_data$arc, conf.level \= 0.95)$conf.int  
\+  cat("95% CI for mean ARC in elementary schools:", ci\_elementary\[1\], "to", ci\_elementary\[2\], "\\n")  
\+ } else {  
\+  cat("Elementary CI skipped: insufficient data.\\n")  
\+ }  
95% CI for mean ARC in elementary schools: 12.20731 to 15.39846   
\> 

#### Results and Interpretation:

The 95% confidence interval for mean ARC in secondary schools is 15.31 to 21.90. For elementary schools, it is 12.21 to 15.40. Using filtered data (n=108; 77 elementary, 31 secondary), the minimal overlap suggests a likely significant difference in mean ARC between levels. In simple terms, we can be 95% confident that secondary schools face higher at-risk challenges on average, reinforcing the value of disaggregating data by school level for targeted interventions.

## Analysis 3: Hypothesis Testing (Module 4\)

### Research Question: Is the mean ARC significantly different between schools with high chronic absenteeism (greater than 6%) and those with low chronic absenteeism (less than 6%)?

#### R Code:

\> \# Analysis 3: Hypothesis Testing (Module 4\)  
\> \# Research Question: Is the mean ARC significantly different between schools with high chronic absenteeism (\>6%) and low (\<=6%)?  
\> if (nrow(high\_absent\_all) \> 0 && nrow(low\_absent\_all) \> 0\) {  
\+  t\_test\_result \<- t.test(arc \~ absent\_group, data \= all\_data, var.equal \= FALSE)  
\+  cat("T-Test for ARC by Absenteeism Group:\\n")  
\+  print(t\_test\_result)  
\+ } else {  
\+  cat("T-Test skipped: insufficient data in high/low absenteeism groups.\\n")  
\+ }  
T-Test for ARC by Absenteeism Group:

	Welch Two Sample t-test

data:  arc by absent\_group  
t \= 6.4425, df \= 70.963, p-value \= 1.217e-08  
alternative hypothesis: true difference in means between group High (\>6%) and group Low (\<=6%) is not equal to 0  
95 percent confidence interval:  
  5.982614 11.345740  
sample estimates:  
mean in group High (\>6%) mean in group Low (\<=6%)   
                21.19794                 12.53376 

\> 

#### Results and Interpretation:

The analysis used is a two-sample t-test that compares the means between the two groups without assuming equal variances. Utilizing the filtered data, n \= 108, and there are 41 schools considered to have high absenteeism scores (\>6%) and 67 schools considered to have low absenteeism scores (\<6%). For the analysis, the hypothesis are as follows:

H0: Mean ARChigh absenteeism-Mean ARClow absenteeism= 0  
Ha: Mean ARChigh absenteeism-Mean ARClow absenteeism 0

The t-statistic measures how far apart the group means are, relative to variability. The large, positive value of t \= 6.44 indicates that the high absenteeism group has a much higher mean ARC than the low absenteeism group. The p-value of 1.217e-08 is extremely small For this reason, we reject the null hypothesis because there is strong evidence of a difference between schools in the ARC scores for schools with high absenteeism and low absenteeism.

Further analysis in this test shows that the 95% confidence interval of 5.98 to 11.35 indicates that with 95% certainty, the true difference between ARC of high and low absenteeism schools is between \~6 and 11.4. And finally, the test finds the sample mean ARC for high absenteeism schools is found to be \~21.20 and the sample mean ARC for low absenteeism schools is found to be \~12.53. 

In layman's terms, schools with chronic absenteeism above 6% have notably higher at-risk levels, suggesting absenteeism as a key warning sign for broader student risks.

## Analysis 4: Multiple Regression (Module 5\)

### Research Question: Which risk factors most strongly predict chronic absenteeism across all schools? Which are most predictive in elementary schools? In secondary schools?

#### R Code:

\> \# Analysis 4: Multiple Regression (Module 5\)  
\> \# Research Question: Which risk factors most strongly predict chronic absenteeism?   
\> \# Which risk factors most strongly predict chronic absenteeism in elementary schools?  
\>   
\> \# Full model (all schools)  
\> model\_full \<- lm(chronic\_absenteeism \~ prop\_economic\_disadvantage \+ prop\_homeless \+  
\+                   prop\_foster\_care \+ prop\_migrant \+ prop\_ell \+  
\+                   prop\_academic\_underperformance \+ prop\_incarceration\_delinquency \+  
\+                   prop\_teen\_pregnancy, data \= all\_data)  
\> cat("Regression Summary for Full Data:\\n")  
Regression Summary for Full Data:  
\> print(summary(model\_full))

Call:  
lm(formula \= chronic\_absenteeism \~ prop\_economic\_disadvantage \+   
    prop\_homeless \+ prop\_foster\_care \+ prop\_migrant \+ prop\_ell \+   
    prop\_academic\_underperformance \+ prop\_incarceration\_delinquency \+   
    prop\_teen\_pregnancy, data \= all\_data)

Residuals:  
    Min      1Q  Median      3Q     Max   
\-4.7750 \-0.7980 \-0.0494  0.7765  5.0149 

Coefficients:  
                                Estimate Std. Error t value Pr(\>|t|)      
(Intercept)                       0.9216     0.4372   2.108 0.037571 \*    
prop\_economic\_disadvantage        0.8807     1.2820   0.687 0.493712      
prop\_homeless                    19.8853     8.1548   2.438 0.016531 \*    
prop\_foster\_care                 20.3208    67.3777   0.302 0.763594      
prop\_migrant                   \-230.3078   229.3211  \-1.004 0.317681      
prop\_ell                          0.1683     1.2646   0.133 0.894408      
prop\_academic\_underperformance    6.6351     1.7204   3.857 0.000205 \*\*\*  
prop\_incarceration\_delinquency  143.2895    31.4812   4.552 1.52e-05 \*\*\*  
prop\_teen\_pregnancy             600.3485   213.0503   2.818 0.005837 \*\*   
\---  
Signif. codes:  0 â€˜\*\*\*â€™ 0.001 â€˜\*\*â€™ 0.01 â€˜\*â€™ 0.05 â€˜.â€™ 0.1 â€˜ â€™ 1

Residual standard error: 1.754 on 99 degrees of freedom  
Multiple R-squared:  0.788,	Adjusted R-squared:  0.7708   
F-statistic: 45.99 on 8 and 99 DF,  p-value: \< 2.2e-16

\>   
\> \# Elementary model (exclude teen\_pregnancy as itâ€™s zero)  
\> model\_elementary \<- lm(chronic\_absenteeism \~ prop\_economic\_disadvantage \+ prop\_homeless \+  
\+                         prop\_foster\_care \+ prop\_migrant \+ prop\_ell \+  
\+                         prop\_academic\_underperformance \+ prop\_incarceration\_delinquency,  
\+                       data \= elementary\_data)  
\> cat("Regression Summary for Elementary Schools:\\n")  
Regression Summary for Elementary Schools:  
\> print(summary(model\_elementary))

Call:  
lm(formula \= chronic\_absenteeism \~ prop\_economic\_disadvantage \+   
    prop\_homeless \+ prop\_foster\_care \+ prop\_migrant \+ prop\_ell \+   
    prop\_academic\_underperformance \+ prop\_incarceration\_delinquency,   
    data \= elementary\_data)

Residuals:  
    Min      1Q  Median      3Q     Max   
\-2.6216 \-0.4702 \-0.1235  0.4086  2.7690 

Coefficients:  
                               Estimate Std. Error t value Pr(\>|t|)      
(Intercept)                      0.4478     0.3206   1.397  0.16688      
prop\_economic\_disadvantage       0.3150     1.2065   0.261  0.79481      
prop\_homeless                    3.3076     5.7497   0.575  0.56699      
prop\_foster\_care                \-7.6285    43.3360  \-0.176  0.86079      
prop\_migrant                    69.4767   158.2560   0.439  0.66202      
prop\_ell                        \-2.7209     0.9374  \-2.903  0.00496 \*\*   
prop\_academic\_underperformance  15.7692     2.1176   7.447 2.05e-10 \*\*\*  
prop\_incarceration\_delinquency 100.2406   144.4191   0.694  0.48995      
\---  
Signif. codes:  0 â€˜\*\*\*â€™ 0.001 â€˜\*\*â€™ 0.01 â€˜\*â€™ 0.05 â€˜.â€™ 0.1 â€˜ â€™ 1

Residual standard error: 1.051 on 69 degrees of freedom  
Multiple R-squared:  0.7342,	Adjusted R-squared:  0.7073   
F-statistic: 27.23 on 7 and 69 DF,  p-value: \< 2.2e-16

\>   
\> \# Secondary model (full)  
\> model\_secondary \<- lm(chronic\_absenteeism \~ prop\_economic\_disadvantage \+ prop\_homeless \+  
\+                        prop\_foster\_care \+ prop\_migrant \+ prop\_ell \+  
\+                        prop\_academic\_underperformance \+ prop\_incarceration\_delinquency \+  
\+                        prop\_teen\_pregnancy, data \= secondary\_data)  
\> cat("Regression Summary for Secondary Schools (Full):\\n")  
Regression Summary for Secondary Schools (Full):  
\> print(summary(model\_secondary))

Call:  
lm(formula \= chronic\_absenteeism \~ prop\_economic\_disadvantage \+   
    prop\_homeless \+ prop\_foster\_care \+ prop\_migrant \+ prop\_ell \+   
    prop\_academic\_underperformance \+ prop\_incarceration\_delinquency \+   
    prop\_teen\_pregnancy, data \= secondary\_data)

Residuals:  
    Min      1Q  Median      3Q     Max   
\-3.3855 \-1.6120  0.3044  0.8239  5.2973 

Coefficients:  
                                Estimate Std. Error t value Pr(\>|t|)      
(Intercept)                      \-0.4907     1.3208  \-0.372 0.713806      
prop\_economic\_disadvantage       \-4.6808     3.0515  \-1.534 0.139306      
prop\_homeless                    42.8313    33.0700   1.295 0.208687      
prop\_foster\_care               \-257.2604   329.7976  \-0.780 0.443670      
prop\_migrant                   \-993.7454   845.6936  \-1.175 0.252530      
prop\_ell                          1.2610     3.8816   0.325 0.748342      
prop\_academic\_underperformance   10.5657     4.7161   2.240 0.035494 \*    
prop\_incarceration\_delinquency  192.2540    50.2008   3.830 0.000913 \*\*\*  
prop\_teen\_pregnancy            1064.5201   409.3993   2.600 0.016338 \*    
\---  
Signif. codes:  0 â€˜\*\*\*â€™ 0.001 â€˜\*\*â€™ 0.01 â€˜\*â€™ 0.05 â€˜.â€™ 0.1 â€˜ â€™ 1

Residual standard error: 2.315 on 22 degrees of freedom  
Multiple R-squared:  0.8582,	Adjusted R-squared:  0.8066   
F-statistic: 16.64 on 8 and 22 DF,  p-value: 1.118e-07

#### Results and Interpretation:

This analysis identifies key predictors of chronic absenteeism across all schools (n=108), elementary schools (n=77), and secondary schools (n=31), using multiple regression to assess the strength of risk factors.

* **All Schools:** The model has an adjusted R-squared of 0.771, meaning it explains 77.1% of the variance in chronic absenteeism, indicating a strong fit.   
* Significant predictors (p\<0.05) are:  
  * Homelessness (p=0.017): Higher proportions increase absenteeism.  
  * Academic underperformance (p=0.0002): Strongly linked to absenteeism.  
  * Incarceration/delinquency (p=1.52e-05): A major driver of absenteeism.  
  * Teen pregnancy (p=0.006): Notably increases absenteeism. 

Non-significant predictors (p\>0.05) include economic disadvantage (p=0.494), foster care (p=0.764), migrant status (p=0.318), and ELL status (p=0.894). 

In layman's terms, homelessness, poor academic performance, legal issues, and teen pregnancy strongly predict absenteeism district-wide, while other factors are less influential.

* **Elementary Schools:** The model has an adjusted R-squared of 0.707, explaining 70.7% of variance, a strong fit.   
* Significant predictors are:  
  * ELL status (p=0.005): Language barriers increase absenteeism.  
  * Academic underperformance (p=2.05e-10): A dominant factor. 

Non-significant predictors include economic disadvantage (p=0.795), homelessness (p=0.567), foster care (p=0.861), migrant status (p=0.662), and incarceration/delinquency (p=0.490). 

In simple terms, language challenges and poor academic performance are key drivers of absenteeism in elementary grades, unlike other factors.

* **Secondary Schools:** The model has an adjusted R-squared of 0.807, explaining 80.7% of variance, a strong fit.   
* Significant predictors are:  
  * Academic underperformance (p=0.035): Linked to absenteeism.  
  * Incarceration/delinquency (p=0.001): Strongly predictive.  
  * Teen pregnancy (p=0.016): A significant factor. 

Non-significant predictors include economic disadvantage (p=0.139), homelessness (p=0.209), foster care (p=0.444), migrant status (p=0.253), and ELL status (p=0.748). 

In plain terms, behavioral issues, legal troubles, and teen pregnancy drive absenteeism in secondary schools, while other factors are less impactful.

**Key Insights:** The differing predictors by school level highlight the need for tailored interventions. Elementary schools should focus on language support and academic improvement, while secondary schools need programs addressing behavioral issues and teen pregnancy. The high adjusted R-squared values confirm the models' reliability for guiding resource allocation.

For the dataset and detailed outputs, see the appendix. Run project\_analyses.R in RStudio for visualizations and additional diagnostics.

# Mapping at\_risk\_data to derived sources

**campus\_id** comes from column 'Campus' in District-EnrollmentCountsbyDate.pdf

**total\_students** comes from column 'Enrolled' in District-EnrollmentCountsbyDate.pdf

**economic\_disadvantage** comes from DistrictEconomicDisadvantageListing.pdf in rows such as "Total Students for Akins Early College High School: 1,460"

**homeless** comes from DistrictAt-RiskListing.csv, ‘HMLS-Homeless’

**foster\_care** comes from DistrictAt-RiskListing.csv 'DPRS-DPRS' 

**migrant** come from DistrictMigrantListing.pdf 

**ell** comes from DistrictAt-RiskListing.csv, 'LEP-LEP'

**academic\_underperformance** comes from DistrictAt-RiskListing.csv ‘RTND-Retained’, 'EOC-Failed EOC', 'FNG2-Failing 2+', 'STAR-Failed STAAR', 'MAPG-MAP Growth: 14' 'RECO-Enrolled in Dropout Recovery School', 'FED2-Failed 2+',

**incarceration\_delinquency** DistrictAt-RiskListing.csv, 'EXP-Expulsion', 'DAEP-Place DAEP', 'RPF-Residential Facility'

**teen\_pregnancy** DistrictAt-RiskListing.csv, 'PREG-Pregnant Student', 'PRNT-Student Parent'

**chronic\_absenteeism** comes from DistrictPercentageofAttendanceSummaryAISD.pdf, '% Attendance'. The value in that column is subtracted from 100 to determine the value for chronic\_absenteeism. Note that chronic\_absenteeism is treated as a percentage rate in ARC, while all other risk factors are treated as a proportion of students with the risk factor to the total number of students on campus.

#### **Research on Risk Factors and Dropout Rates**

To derive research-based weights, I reviewed studies focusing on K-12 dropout risk factors, particularly meta-analyses and national statistics, given the Austin ISD context. The following sources were pivotal:

1. **Meta-Analytic Review**: "Risk Factors for School Absenteeism and Dropout: A Meta-Analytic Review" (Maynard et al., 2019, PMC, \[[https://pmc.ncbi.nlm.nih.gov/articles/PMC6732159/](https://pmc.ncbi.nlm.nih.gov/articles/PMC6732159/)\]) provided effect sizes (correlations, r) for various risk domains related to dropout, classified by family, child, school, and community domains.   
2. **Specific Studies on Dropout Rates**:

   1. **Homelessness**:  
      1. **Source**: California Department of Education ([https://www.cde.ca.gov/ds/sg/homelessyouth.asp](https://www.cde.ca.gov/ds/sg/homelessyouth.asp))  
      2. **Finding**: In 2023-24, homeless students had a dropout rate of 16.8% vs. 8.2% for non-homeless, implying an odds ratio of approximately 2.27.  
      3. **Source**: SchoolHouse Connection ([https://schoolhouseconnection.org/number-of-students-experiencing-homelessness-reaches-all-time-high-growth-in-numbers-of-unaccompanied-youth-most-marked/](https://schoolhouseconnection.org/number-of-students-experiencing-homelessness-reaches-all-time-high-growth-in-numbers-of-unaccompanied-youth-most-marked/))  
      4. **Finding**: National graduation rate for homeless students was 64% (36% dropout) vs. 84.1% overall (15.9% dropout) in 2016-17.  
   2. **Foster Care**:  
      1. **Source**: California Department of Education ([https://www.cde.ca.gov/ds/sg/fosteryouth.asp](https://www.cde.ca.gov/ds/sg/fosteryouth.asp))  
      2. **Finding**: In 2023-24, foster youth had a 24.9% dropout rate vs. 8.7% for non-foster students, with an odds ratio of approximately 3.48.  
      3. **Source**: Foster Youth of America (https://www.fosteryouthofamerica.org/the-97-project)  
      4. **Finding**: California foster youth had a 42% dropout rate (58% graduation) vs. 16% statewide in 2009-10.  
   3. **English Language Learner (ELL)**:  
      1. **Source**: NCES Fast Facts .  
      2. **Finding**: In 2019-20, ELL graduation rate was 71% vs. 86% overall, implying a 29% dropout rate vs. 14% (odds ratio ≈ 2.67).  
      3. **Source**: Education Week ([https://www.edweek.org/teaching-learning/the-complex-factors-affecting-english-learner-graduation-rates/2024/05](https://www.edweek.org/teaching-learning/the-complex-factors-affecting-english-learner-graduation-rates/2024/05))  
      4. **Finding**: In New York City, ELLs were 4% less likely to graduate on time, with variations by race and socioeconomic status.  
   4. **Teen Pregnancy**:  
      1. **Source**: ACLU of Washington ([https://www.aclu-wa.org/blog/teen-pregnancy-discrimination-and-dropout-rate](https://www.aclu-wa.org/blog/teen-pregnancy-discrimination-and-dropout-rate))  
      2. **Finding**: Approximately 70% of teenage girls who give birth drop out.  
      3. **Source**: [Youth.gov](http://Youth.gov) ([https://youth.gov/youth-topics/pregnancy-prevention/adverse-effects-teen-pregnancy](https://youth.gov/youth-topics/pregnancy-prevention/adverse-effects-teen-pregnancy))  
      4. **Finding**: By age 22, only 50% of teen mothers have a high school diploma vs. 90% of non-teen mothers (odds ratio ≈ 9).  
   5. **Chronic Absenteeism**:  
      1. **Source**: U.S. Department of Education ([https://www2.ed.gov/datastory/chronicabsenteeism.html](https://www2.ed.gov/datastory/chronicabsenteeism.html))  
      2. **Finding**: A single year of chronic absenteeism between 8th and 12th grade increases dropout likelihood sevenfold.  
      3. **Source**: Panorama Education ([https://www.panoramaed.com/blog/the-effects-of-chronic-absenteeism-in-schools](https://www.panoramaed.com/blog/the-effects-of-chronic-absenteeism-in-schools))  
      4. **Finding**: Chronic absenteeism is a stronger predictor of dropout than test scores.  
   6. **Migrant Status**:  
      1. **Source**: Pew Research Center ([https://www.pewresearch.org/race-and-ethnicity/2005/11/01/the-higher-drop-out-rate-of-foreign-born-teens/](https://www.pewresearch.org/race-and-ethnicity/2005/11/01/the-higher-drop-out-rate-of-foreign-born-teens/))  
      2. **Finding**: Foreign-born teens with prior schooling difficulties have dropout rates exceeding 70% vs. 8% for other foreign-born youth.  
      3. **Source**: NCES ([https://nces.ed.gov/pubs/dp95/97473-4.asp](https://nces.ed.gov/pubs/dp95/97473-4.asp))  
      4. **Finding**: Immigrant youth have a 29.1% dropout rate vs. 9.9% for native-born.

**Notes**:

* **ELL**: Inferred from academic achievement due to language barriers, supported by a 15% graduation rate gap.  
* **Chronic Absenteeism**: Inferred from negative school attitude, with studies showing a sevenfold dropout risk increase.  
* **Teen Pregnancy**: Meta-analysis suggests a small effect, but specific studies show a strong impact (50% graduation rate vs. 90%).  
* **Homelessness**: Inferred from low family SES, with California data showing a doubled dropout rate.

#### **Research-Based Weights**

Using data from a meta-analysis ("Risk Factors for School Absenteeism and Dropout: A Meta-Analytic Review," 2019\) and specific studies, we assign weights based on effect sizes (correlation coefficient r) or odds ratios, adjusted for consistency:

* **Academic Underperformance**: r=0.316  (large effect from meta-analysis)  
* **Chronic Absenteeism**: Adjusted r=0.350 (increased from inferred r=0.298 r \= 0.298 r=0.298 based on its role as a leading indicator)  
* **English Language Learner (ELL)**: r=0.388  (averaged from meta-analysis r=0.316 and odds ratio-derived r=0.46)  
* **Economic Disadvantage**: r=0.222 (medium effect from meta-analysis)  
* **Homelessness**: r=0.306 (averaged from meta-analysis r=0.222 and odds ratio-derived r=0.39)  
* **Foster Care**: r=0.364 (averaged from meta-analysis r=0.178 r \= 0.178 r=0.178 and odds ratio-derived r=0.55)  
* **Incarceration/Delinquency**: r=0.223 (medium effect from meta-analysis)  
* **Teen Pregnancy**: r=0.485 (averaged from meta-analysis r=0.170 and odds ratio-derived r=0.8 reflecting specific studies’ larger impact)  
* **Migrant Status**: r=0.062 (small effect from meta-analysis)

Table 1 summarizes the effect sizes for relevant factors:

| Risk Factor | Effect Size (r) | Classification | Notes | Scaled Weight (Effect SizeMax Effect Size) |
| ----- | ----- | ----- | ----- | ----- |
| Economic Disadvantage (Low family SES) | 0.222 | Family domain | Medium effect, significant (p\<0.001 p \< 0.001 p\<0.001) | 0.222/0.485 0.458 |
| Homelessness | Inferred 0.306 | Family domain | Assumed similar to low family SES, medium effect | 0.306/0.485 0.631 |
| Foster Care | Inferred 0.364 | Family domain | Related to family structure, small-medium effect | 0.364/0.485 0.751 |
| Migrant Status | Inferred 0.062 | Child domain | Related to ethnicity, small effect, significant (p=0.017 p \= 0.017 p=0.017) | 0.062/0.485 0.128 |
| English Language Learner (ELL) | Inferred 0.388 | Child domain | Related to low academic achievement, large effect, significant | 0.388/0.485 0.800 |
| Academic Underperformance | 0.316 | Child domain | Low academic achievement, large effect, significant (p\<0.001 p \< 0.001 p\<0.001) | 0.316/0.485 0.652 |
| Incarceration/Delinquency | 0.223 | Child domain | Delinquent behavior, medium effect, significant (p\<0.001 p \< 0.001 p\<0.001) | 0.223/0.485 0.460 |
| Teen Pregnancy | 0.485 | Child domain | High sexual involvement, small effect, non-significant (p=0.139 p \= 0.139 p=0.139) | 0.485/0.485 \=1.0 |
| Chronic Absenteeism | Inferred 0.350 | Child domain | Related to having a negative school attitude, medium-large effect | 0.350/0.485 0.722 |

#### **Other Sources**

[https://statutes.capitol.texas.gov/Docs/ED/htm/ED.29.htm](https://statutes.capitol.texas.gov/Docs/ED/htm/ED.29.htm)

[http://ritter.tea.state.tx.us/peims/standards/1314/e0919.html](http://ritter.tea.state.tx.us/peims/standards/1314/e0919.html)

#### **Potential Applications of ARC**

[See linked document for potential applications of ARC.](https://docs.google.com/document/d/1NMaSeJ5LXQ6VSs5U_p4SmeSD3fABsiYHs4aNU2LTi0U/edit?usp=sharing)

#### **Expanded notes on Evaluating ARC**

[See linked document for expanded notes on evaluating ARC.](https://docs.google.com/document/d/1L2pLiCG5QQwrQcsztxF0GxDw4fZeWonAeGf4VjqJ5Pk/edit?usp=sharing)

Improvements of Methodology   
