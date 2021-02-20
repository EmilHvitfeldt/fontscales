#' Tidy Violent Crime Rates by US State
#'
#' Tidy version of \link[datasets]{USArrests}. Contains state name as a variable
#' and all variables are lowercase.
#'
#' @format A data frame with 53940 rows and 10 variables:
#' \describe{
#'   \item{state}{Character, Name of state}
#'   \item{urban_pop}{numeric, Percent urban population}
#'   \item{murder}{Numeric,	Murder arrests (per 100,000)}
#'   \item{assault}{Numeric, Assault arrests (per 100,000)}
#'   \item{rape}{Numeric,	Rape arrests (per 100,000)}
#' }
"usa_arrests"
