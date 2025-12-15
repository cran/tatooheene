## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE, comment = "#>", fig.width = 7, fig.height = 4, dpi = 120
)
library(tatooheene)

## ----default------------------------------------------------------------------
depreciation_interest(
  v_replace_val = 50000, # replacement value 
  r_salvage_val = 5000   # salvage value at end of period 
)

## ----annuity-only-------------------------------------------------------------
depreciation_interest(
  v_replace_val = 50000,
  r_salvage_val = 5000,
  output = "annuity_factor"
)

## ----annual-only--------------------------------------------------------------
depreciation_interest(
  v_replace_val = 50000,
  r_salvage_val = 5000,
  output = "annual_cost"
)

## ----zero-interest------------------------------------------------------------
depreciation_interest(
  v_replace_val = 50000,
  r_salvage_val = 5000,
  n_amortisation_period = 8,
  i_interest_rt = 0,
  output = "dataframe"
)

## ----errors, error=TRUE-------------------------------------------------------
depreciation_interest(
  v_replace_val = 50000,
  r_salvage_val = -1
)

