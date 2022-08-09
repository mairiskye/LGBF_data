library(onsr)
library(magrittr)
library(dplyr)
library(httr)
library(jsonlite)

datasets <- onsr::ons_ids() %>% as_tibble()

business <- onsr::ons_get("uk-business-by-enterprises-and-local-units")

geographies <-business$`administrative-geography`[grep("s", business$`administrative-geography`, ignore.case = T)] %>%
  unique()

scottish_business_data <- business %>%
  filter(`administrative-geography` %in% geographies)


