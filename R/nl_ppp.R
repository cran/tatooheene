#' A function to obtain the Dutch PPP factor values in International Dollar (INT$)
#'
#' @description
#' `r lifecycle::badge("experimental")`
#' This function downloads the Purchasing Power Parity (PPP) factor values for the Netherlands from the OECD website per year in International Dollar (Int$).
#'
#' @param year The year of which the PPP factor should be downloaded, multiple years are possible, default is the whole dataset.
#' @keywords Generic, Costing Manual, Purchasing Power Parity (PPP)
#' @return A dataframe or value with the PPP factor values for the specified years.
#' @examples
#' # Example usage of the nl_ppp function
#' nl_ppp(year = 2019)
#' @export nl_ppp

nl_ppp <- function(year = "all"){

  df <- tatooheene::df_ppp   # Read in the dataset

  # Select the specified years, or all years if not specified
  if(!identical(year, "all")){
    year <- suppressWarnings(as.numeric(as.character(year)))
    assertthat::assert_that(
      length(year) > 0L, all(is.finite(year)), all(year == trunc(year)),
      msg = "`year` must contain valid years")

    idx <- match(year, df$Year)
    if(anyNA(idx)){
      stop("PPP unavailable for year(s): ",
           paste(unique(year[is.na(idx)]), collapse = ", "), call. = FALSE)
    }

    ppp <- df$PPP[idx]
    assertthat::assert_that(all(is.finite(ppp)), all(ppp > 0),
      msg = "PPP factors must be finite and positive")
    return(unname(ppp))

  } else{

    return(df) # otherwise, return the full dataset
  }
}
