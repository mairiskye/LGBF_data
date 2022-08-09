library(httr)
library(dplyr)
library(stringr)
library(magrittr)
library(tibble)

#This script queries the NOMIS API for data for two LGBF indicators;
#ECON 12a:  Claimants as a proportion of residents aged 16-64
#ECON 12b:  (NUMERATOR) the count of claimants who are 16-24 at March each year
#           (DENOMINATOR) the mid year estimate of population aged 16-24 (at June each year)

# %claimants 16-64===================================================

get_claimant_propo_16_65 <- httr::GET("https://www.nomisweb.co.uk/api/v01/dataset/NM_162_1.data.csv?geography=2013265931TYPE432&measure=2&measures=20100&gender=0&time=2010,latest&age=0&select=DATE,GEOGRAPHY_NAME,OBS_VALUE")
claimant_propo_16_65 <- content(get_claimant_propo_16_65, as = "parsed", type = "text/csv") %>%
  as_tibble() %>%
  dplyr::filter(grepl("03", DATE)) %>%
  dplyr::rename(Year = DATE, 
                ClaimantsAsPropOf16_65Pop = OBS_VALUE,
                Council = GEOGRAPHY_NAME)

#change year from 2010-03 format and encode to appropriate financial year 200
claimant_propo_16_65$Year <- stringr::str_sub(claimant_propo_16_65$Year, 1, 4)
claimant_propo_16_65$Year <- paste0(as.numeric(claimant_propo_16_65$Year) - 1, "/",(substr(claimant_propo_16_65$Year,3,4)))

#16-24 claimant count===========================================

get_claimant_count_16_24 <- httr::GET("https://www.nomisweb.co.uk/api/v01/dataset/NM_162_1.data.csv?geography=2013265931TYPE432&measure=1&measures=20100&gender=0&time=2010,latest&age=2&select=date,geography_name,obs_value")
claimant_count_16_24 <- content(get_claimant_count_16_24, as = "parsed", type = "text/csv") %>%
  as.tibble() %>%
  dplyr::filter(grepl("03", DATE)) %>%
  dplyr::rename(Year = DATE, 
                ClaimantCountAged16_24AtMarch = OBS_VALUE,
                Council = GEOGRAPHY_NAME)

claimant_count_16_24$Year <- stringr::str_sub(claimant_count_16_24$Year, 1, 4)
claimant_count_16_24$Year <- paste0(as.numeric(claimant_count_16_24$Year) - 1, "/",(substr(claimant_count_16_24$Year,3,4)))

# population 16-24 ====================================

query_16_24 <- httr::GET("https://www.nomisweb.co.uk/api/v01/dataset/NM_2002_1.data.csv?geography=2013265931TYPE432&time=2009,latest&c_age=250&gender=0&measures=20100&select=date,geography_name,obs_value")
pop_16_24 <- content(query_16_24, as = "parsed") %>%
  dplyr::rename(Population16_24 = OBS_VALUE, Year = DATE, Council = GEOGRAPHY_NAME)

pop_16_24$Year <- paste0(pop_16_24$Year, "/",(as.numeric(substr(pop_16_24$Year,3,4))+1))

# claimants as % 16-24 pop =========================

claimant_proportions_16_24 <- dplyr::left_join(claimant_count_16_24, pop_16_24, by = c("Council", "Year")) %>%
  dplyr::mutate(Proportion16_24AreClaimants = round((ClaimantCountAged16_24AtMarch / Population16_24 * 100),1))

# final data to csv ==========================

econ_12_data <- dplyr::left_join(claimant_propo_16_65, claimant_proportions_16_24, by = c("Year", "Council"))

write.csv(econ_12_data, "Data/Econ12_claimant_data.csv")                
