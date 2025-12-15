## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7, fig.height = 4.2,
  dpi = 120
)
library(tatooheene)
library(dplyr)
library(tidyr)
library(lifecycle)

## ----peek-data----------------------------------------------------------------
df_ref_prices %>%
  head()

## ----default------------------------------------------------------------------
nl_ref_prices()

## ----specific-----------------------------------------------------------------
nl_ref_prices(year = 2022, unit = "Emergency care")

## ----range--------------------------------------------------------------------
nl_ref_prices(year = 2022:2024, category = "Nursing")

## ----multiple-----------------------------------------------------------------
# nl_ref_prices(
#   year     = 2024,
#   category = "Nursing",
#   unit     = c("Nursing day excluding personnel costs, hospital",
#                "Nursing day including personnel costs, hospital")
# )

