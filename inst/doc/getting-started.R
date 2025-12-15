## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(tatooheene)
library(dplyr)

## ----setup, eval = FALSE------------------------------------------------------
#  # CRAN
#  install.packages("tatooheene")

## ----load, eval = FALSE-------------------------------------------------------
#  # Load the package
#  library(tatooheene)
#  
#  # We recommend using the tidyverse style
#  library(tidyverse)

## ----eval = FALSE-------------------------------------------------------------
#  # Look up CPI indices with function nl_price_index()
#  idx19_23 <- nl_price_index(
#    start_year = 2019,
#    end_year = 2023,
#    output = "factor"  # see ?nl_price_index for available outputs
#  )
#  
#  idx19_23
#  
#  # Example tibble
#  costs <- tibble::tibble(item = c("GP consult", "MRI"), cost_2019 = c(34.5, 285))
#  
#  # Adjust costs to 2024 EUR using the CPI index
#  costs |>
#    mutate(cost_2024 = cost_2019 * idx19_23)

## -----------------------------------------------------------------------------
# Get the friction period for 2023
v_5yr_mean_friction <- tatooheene::friction_period(
  year = 2023, # Year of interest
  units = "days", # We are interested in the number of days
  avg = "5yr", # Use the 5-year average friction period as stated in the costing manual,
  output = "value" # Return a single value
  )

## -----------------------------------------------------------------------------
# Example sick-leave spells (days) and reference prices (EUR/day)
df_spells <- tibble::tibble(
  id = 1:3,
  sick_days = c(140, 122, 30)) 

# Get reference prices for productivity losses (paid work)
# These are in table df_rp_prod

# Get reference price for paid work in 2023
p_ref_prod_paid_2023 <- df_ref_prices |> 
  filter(short_var == "prodloss_paid_hour") %>% 
  pull(`2023`)

# Calculate productivity costs using the friction cost method
df_spells %>% 
  mutate(
    # Apply the friction cost method
    sick_days_friction = ifelse(
    sick_days > v_5yr_mean_friction, v_5yr_mean_friction, sick_days),
    # Calculate productivity costs
    prod_cost = sick_days_friction * p_ref_prod_paid_2023)

