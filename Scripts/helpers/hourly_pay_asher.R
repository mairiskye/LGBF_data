#This script extracts appropriate parameter codes to query the numerator
#for the LGBF Indicator 'Proportion of people earning less than the living wage'
library(jsonlite)
library(httr)
library(nomisr)

#'asher' stands for Annual Survey of Hours and Earnings 
# and is the API reference as given on the Nomis Web page for this dataset

asher_search <- jsonlite::fromJSON(txt="https://www.nomisweb.co.uk/api/v01/dataset/def.sdmx.json?search=ASHER")
asher_dataset_id <- asher_search$structure$keyfamilies$keyfamily %>%
  pull(id)

asher_metadata <- nomisr::nomis_get_metadata(asher_dataset_id)

asher_measures <- nomisr::nomis_get_metadata(asher_dataset_id, concept = "MEASURES") %>%
  filter(description.en == "value") %>%
  pull(id)

#assuming 'hourly pay excluding overtime could be used 
asher_pay <- nomisr::nomis_get_metadata(asher_dataset_id, concept = "PAY") %>%
  filter(description.en == "Hourly pay - excluding overtime") %>%
  pull(id)

asher_item <- nomisr::nomis_get_metadata(asher_dataset_id, concept = "ITEM")

asher_geography_type <- nomisr::nomis_get_metadata(asher_dataset_id, concept = "GEOGRAPHY", type = "type") %>%
  filter(grepl("local authorities: district", description.en)) %>%
  filter(grepl("2021", description.en)) %>%
  pull(id)

asher_geography <- nomisr::nomis_get_metadata(asher_dataset_id, concept = "GEOGRAPHY", type = asher_geography_type) %>%
  filter(description.en == "Aberdeenshire") %>%
  pull(parentCode)

asher_sex <- nomisr::nomis_get_metadata(asher_dataset_id, concept = "SEX") %>%
  filter(description.en == "Total") %>%
  pull(id)

asher_freq <- nomisr::nomis_get_metadata(asher_dataset_id, concept = "FREQ")

asher_time <- nomisr::nomis_get_metadata(asher_dataset_id, concept = "TIME")

query_uri <- paste0("https://www.nomisweb.co.uk/api/v01/dataset/", asher_dataset_id, ".data.csv?geography=", asher_geography, asher_geography_type, "&MEASURES=20100&SEX=7")
