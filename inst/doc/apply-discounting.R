## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE, comment = "#>", fig.width = 7, fig.height = 4, dpi = 120
)
library(tatooheene)

## ----no-discount--------------------------------------------------------------
c_annual <- 100
c_t3_undiscounted <- 3 * c_annual
c_t3_undiscounted

## ----discount-rate------------------------------------------------------------
v_c_SoC <- rep(c_annual, 3) # Vector of costs values on all years for standard of care 
names(v_c_SoC) <- c("Year 1", "Year 2", "Year 3") # name the vector 

## ----example-guideline--------------------------------------------------------
apply_discounting(values = v_c_SoC, discount_rate = "costs", times = c(0, 1, 2))

## ----example-discount-stream-QALY---------------------------------------------
apply_discounting(values = c(1, 1, 1, 1), discount_rate = "effects", times = c(0, 1, 2, 3))

## ----example-guideline-sum----------------------------------------------------
# aggregate the values
sum(apply_discounting(values = v_c_SoC, discount_rate = "costs", times = c(0, 1, 2))) # sum 
apply_discounting(values = v_c_SoC, discount_rate = "costs", times = c(0, 1, 2), aggregate = TRUE) # aggregate TRUE


# rounding 
apply_discounting(values = v_c_SoC, discount_rate = "costs", times = c(0, 1, 2), digits = 3) # use 3 digits 
apply_discounting(values = v_c_SoC, discount_rate = "costs", times = c(0, 1, 2), aggregate = TRUE, digits = 2) # round to 2 decimals 

## ----example-value------------------------------------------------------------

c_PV_150 <- apply_discounting(values = 150, discount_rate = "costs", times = 4)

cat("Present Value of", 150, " Euro in", 4, "years at", 3, "% =", round(c_PV_150, 2), "\n")

## ----exmple-sick-sicker-monthly-----------------------------------------------
# Use the annual model
data("data_model_output_sick_sicker", package = "tatooheene")

l_m_M_monthly <- data_model_output_sick_sicker$l_m_M_monthly
l_u_monthly   <- data_model_output_sick_sicker$l_u_monthly

head(l_m_M_monthly[["Standard of care"]])
tail(l_m_M_monthly[["Standard of care"]]) 
# here you see this file has more cycles compared to the annual model

# Apply the utilities for the monthly cycles 
v_Q_SoC_monthly <- l_m_M_monthly[["Standard of care"]] %*% l_u_monthly[["Standard of care"]]
n_undiscounted_Q_SoC_monthly <- sum(v_Q_SoC_monthly) # get the undiscounted QALYs
n_undiscounted_Q_SoC_monthly

# Apply discounting without discounting in the first year 
cycle_length    <- 1/12 # cycle length in fraction of a year
v_times_monthly <- seq(from = 0, to = (length(v_Q_SoC_monthly) - 1) * cycle_length, by = cycle_length) 

v_times_monthly[1:((1/cycle_length))] <- 0 
v_times_monthly[1:20] # print first twenty items to show times vector

v_QALY_dis_Sick_Sicker_monthly <- apply_discounting(values = v_Q_SoC_monthly, discount_rate = "effects", times = v_times_monthly) # This gives the discounted QALYs
n_discounted_Q_SoC_monthly <- round(sum(v_QALY_dis_Sick_Sicker_monthly), 3)
n_discounted_Q_SoC_monthly


