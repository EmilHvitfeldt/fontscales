## code to prepare `usa_arrests` dataset goes here

library(magrittr)
library(tibble)
library(janitor)
library(dplyr)
usa_arrests <- rownames_to_column(USArrests, var = "State") %>%
  clean_names() %>%
  tibble() %>%
  select(state, urban_pop, everything())

usethis::use_data(usa_arrests, overwrite = TRUE)
