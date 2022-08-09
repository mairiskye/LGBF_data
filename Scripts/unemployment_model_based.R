#Get Unemployment (model-based) count and rate from NOMIS API
#returns data for different periods

library(httr)
library(magrittr)
library(dplyr)
library(tidyr)

umb_uri <- "https://www.nomisweb.co.uk/api/v01/dataset/NM_127_1.data.csv?geography=2013265931TYPE432&measures=20100&select=DATE,GEOGRAPHY_NAME,ITEM_NAME,OBS_VALUE"

umB_data <- httr::GET(umb_uri) %>% 
  httr::content (as = "parsed", encoding = "UTF-8") %>%
  tidyr::pivot_wider(names_from = ITEM_NAME,
                     values_from = OBS_VALUE)

