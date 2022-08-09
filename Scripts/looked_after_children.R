#Source: statistics.gov.scot
#Indicator: CH8, CH9
#Dataset: Looked After Children

library(httr)
library(magrittr)
library(dplyr)
library(readr)
library(tidyr)

#read in sparql query from file
lac_sparql <- readr::read_file("sparql/looked_after_children.txt")

#request data from api
lac_response <- httr::POST(
  url = "https://statistics.gov.scot/sparql.csv",
  body = list(query = lac_sparql))

#parse response from api
lac_data_raw <- httr::content(lac_response, as = "parsed", encoding = "UTF-8") %>%
  pivot_wider(names_from = status, values_from = lac_count) %>%
  select(!s_code)

names(lac_data_raw)[3:7] <- c("foster_or_prospective_adopters", "at_home",
                         "other_community_placement","residential_care", "all")

lac_proportions <- lac_data_raw %>%
  mutate(community = all - residential_care) %>%
  select(!c("foster_or_prospective_adopters", "at_home",
            "other_community_placement")) %>%
  mutate(`% LAC community` = community/all * 100,
         `% LAC residential` = residential_care/all * 100)

scotland_totals <- lac_proportions %>%
  aggregate(cbind(residential_care, all, community, `% LAC community`, `% LAC residential`) ~ year,
            .,
            sum,
            na.rm = TRUE) %>%
  mutate(council = "Scotland")

final_data <- rbind(lac_proportions, scotland_totals) %>%
  arrange(council, year)

#write.csv(final_data, " ", row.names = FALSE)
