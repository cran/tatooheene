#' A function to download the  Reference prices of the Dutch Costing Manual for one or multiple years
#' @description
#' `r lifecycle::badge("experimental")`
#' This function downloads the  Reference prices of the Dutch Costing Manual for one or multiple years. The prices are available in Euro (EUR) or International Dollar (INT$).
#'
#' @param year The year of which the reference price should be downloaded, multiple years are possible, default is the whole dataset
#' @param domain The domain of prices that should be included (one or more categories), default is including all categories
#' @param category The category of prices that should be included (one or more categories), default is including all categories
#' @param unit The reference price that should be included (one or multiple reference prices),  default is including the whole dataframe
#' @param short_unit The short variable name that should be included (one or more short variables), default is including all
#' @param currency The currency of the output of the prices. A decision can be made between EUR and INT$, the default is EUR.
#' @return A dataframe or value with the Medical Reference price(s) of the Dutch Costing Manual for the specified years
#' @examples
#' # Example usage of the nl_med_prices function
#' # Calculate for year 2024 with the category Nursing
#' nl_ref_prices(year = "2024", category = "Nursing")
#'
#' # Calculate for year 2022 and 2023 the category Nursing
#' nl_ref_prices(year = c(2022,2023), category = "Nursing")
#'
#' # Calculate for year 2022 with the category Nursing in INT$
#' nl_ref_prices(year = "2022", category = "Nursing" , currency = "INT$")
#'
#' @keywords Generic, Costing Manual, Dutch Reference Prices, Medical Prices
#' @export nl_ref_prices


nl_ref_prices <- function(
    year = "all",
    domain = "all",
    category = "all",
    unit = "all",
    short_unit = "all",
    currency = c("EUR", "INT$")){

  # match.arg() for the output parameter to ensure it is one of the valid choices
  currency <- match.arg(currency)

  # read in the dataset
  df <- tatooheene::df_ref_prices

  # year validation
  year_cols <- grep("^[0-9]{4}$", colnames(df), value = TRUE)
  if (!length(year_cols)) stop("No year columns found.", call. = FALSE)

  if (!identical(year, "all")) {
    year <- as.character(year)
    bad <- setdiff(year, year_cols)
    if (length(bad)) {
      stop(
        "Invalid year(s): ", paste(bad, collapse = ", "),
        "\nAvailable years: ", paste(year_cols, collapse = ", "),
        call. = FALSE
      )
    }
  }



  # year choices
  year_choices <- as.character(suppressWarnings(na.omit(as.numeric(colnames(df)))))
  if (identical(year, "all")) {
    year <- "all"
  } else {
    year <- match.arg(as.character(year), year_choices, several.ok = TRUE)
  }

  assertthat::assert_that(
    is.character(domain), length(domain) > 0L, ! anyNA(domain),
    all(domain %in% c("all", unique(df$Domain))),
    msg = "Invalid domain: select available domains or 'all'"
  )

  assertthat::assert_that(
    is.character(short_unit), length(short_unit) >0L, !anyNA(short_unit),
    all(short_unit %in% c("all", unique(df$short_var))),
    msg = "Invalid short_unit: select available short names or 'all'")


  possible_cat <- c("all", unique(df$Category))
  category <- match.arg(category, possible_cat, several.ok = TRUE)

  possible_unit <- c("all", unique(df$Unit))
  unit <- match.arg(unit, possible_unit, several.ok = TRUE)

  currency <- match.arg(currency)

  # If currency is INT$, change output
  if(currency == "INT$"){
    df_ppp <- tatooheene::nl_ppp()

    required_years <- if(identical(year, "all")) year_cols else year
    idx <- match(as.numeric(required_years), df_ppp$Year)
    if(anyNA(idx)){
      stop("PPP unavailable for year (s): ",
           paste(required_years[is.na(idx)], collapse = ", "), call. = FALSE)
    }

    df_ppp <- df_ppp |>
      dplyr::filter(as.numeric(Year) >= 2022) |>
      tidyr::pivot_wider(names_from = "Year", values_from = "PPP")

    df_ppp <- df_ppp[, rev(seq_len(ncol(df_ppp)))]

    common_years <- intersect(colnames(df), colnames(df_ppp))

    df[, common_years] <- sweep(df[, common_years], 2, as.numeric(df_ppp[, common_years]), `/`)
  }

  # If specified, filter based on domain
  if(!identical(domain, "all")){
    df <- df |>
      dplyr::filter(Domain %in% domain)
  }

  # If specified, filter based on category
  if(!identical(category, "all")){
    df <- df |>
      dplyr::filter(Category %in% category)
  }

  # If specified, filter based on unit
  if(!identical(unit, "all")){
    df <- df |>
      dplyr::filter(Unit %in% unit)
  }

  # If specified, filter based on unit
  if(!identical(short_unit, "all")){
    df <- df |>
      dplyr::filter(short_var %in% short_unit)
  }

  # If specified select the specified years or all years if not specified
  if(!identical(year, "all")){
    df <-  df |>
      tidyr::pivot_longer(
        cols = dplyr::matches("^[0-9]{4}$"),
        names_to = "Year",
        values_to = "Price")

    df <- df |>
      dplyr::filter(Year %in% year)

    # In case of single result print label and number
    if (nrow(df) == 1L && !identical(unit, "all")) {
      value <- suppressWarnings(as.numeric(df$Price))
      label <- paste0("Price in ", df$Year, " per ", df$Unit)
      cat(value, "\n", label, "\n", sep = "")
      return(value)
    }
  }

  return(df)
}


