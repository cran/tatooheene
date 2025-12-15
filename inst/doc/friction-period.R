## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7, fig.height = 4.2,
  dpi = 120
)
library(tatooheene)
library(dplyr)

## ----peek-data----------------------------------------------------------------
df_fp %>%
  select(Year,
         `Friction period in days`,
         `Friction period days average over 5 years`,
         `Friction period in weeks`,
         `Friction period weeks average over 5 years`) %>%
  head()

## ----default------------------------------------------------------------------
tatooheene::friction_period()

## ----single-value-------------------------------------------------------------
tatooheene::friction_period(year = 2019, units = "weeks", avg = "5yr", output = "value")

## ----days-1yr-----------------------------------------------------------------
tatooheene::friction_period(year = 2018:2020, units = "days", avg = "1yr")

## ----multi-cols---------------------------------------------------------------
tatooheene::friction_period(
  year  = 2015:2019,
  units = c("days", "weeks"),
  avg   = "1yr"       # try c("1yr","5yr") to get four columns
)

