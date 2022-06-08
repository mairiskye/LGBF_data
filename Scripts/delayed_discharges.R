library(phsopendata)
library(magrittr)
library(lubridate)
library(zoo)
library(dplyr)

delayed_discharges_recent_id <- "513d2d71-cf73-458e-8b44-4fa9bccbf50a"
delayed_discharges_recent <- phsopendata::get_resource(delayed_discharges_recent_id)

delayed_discharges_historic_id <- "2a07d2e2-fa0b-4bf7-8a49-36db4ca5f35e"
delayed_discharges_historic <- phsopendata::get_resource(delayed_discharges_historic_id)

#combine historic (2012-16) dataset with recent (2016-) dataset
delayed_discharges_combined <- dplyr::bind_rows(delayed_discharges_recent, delayed_discharges_historic)

#filter data by 75+ (age), drop irrelevant variables and aggregate to monthly data
delayed_discharges_clean <- dplyr::filter(delayed_discharges_combined, AgeGroup == "75plus") %>%
  dplyr::select(MonthOfDelay, CA, NumberOfDelayedBedDays) %>%
  dplyr::group_by(CA, MonthOfDelay) %>%
  dplyr::summarise(DelayedBedDays = sum(NumberOfDelayedBedDays))

#alter YYYYMM format to YYYY-MM-DD for easier aggregation
delayed_discharges_clean$MonthOfDelay <-  as.character(paste0(delayed_discharges_clean$MonthOfDelay, "01"))
delayed_discharges_clean$MonthOfDelay <- as.Date(delayed_discharges_clean$MonthOfDelay, "%Y%m%d")

#aggregate delayed bed days by financial year
delayed_discharges_finyear <- delayed_discharges_clean %>%
  dplyr::mutate(year_end = year(MonthOfDelay) + if_else(month(MonthOfDelay) >= 4, 1, 0),
                Year = paste0(year_end-1, "/", substr(year_end, 3, 4))) %>%
  dplyr::group_by(CA, Year) %>%
  dplyr::summarise(DelayedBedDays = sum(DelayedBedDays))

#WHY ARE THERE 'NA's INTRODUCED IN THE 'CLEAN' RECTANGLE OF DATA??

#final data
write.csv(delayed_discharges_finyear, "Data/DelayedDischarges.csv")
