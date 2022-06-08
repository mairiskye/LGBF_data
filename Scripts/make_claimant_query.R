#search_claimant <- httr::GET("https://www.nomisweb.co.uk/api/v01/dataset/def.sdmx.json?search=UCJSA")
new_search <- jsonlite::fromJSON(txt="https://www.nomisweb.co.uk/api/v01/dataset/def.sdmx.json?search=UCJSA")
claimant_code <- new_search$structure$keyfamilies$keyfamily %>%
  pull(id)

claimant_metadata <- nomisr::nomis_get_metadata(claimant_code)


claimant_time <- nomisr::nomis_get_metadata(claimant_code, concept = "TIME")

claimant_measures <- nomisr::nomis_get_metadata(claimant_code, "MEASURES") %>%
  filter(grepl("value", description.en)) %>%
  pull(id)

claimant_measure <- nomisr::nomis_get_metadata(claimant_code, "MEASURE")

claimant_measure_16_64 <- nomisr::nomis_get_metadata(claimant_code, "MEASURE") %>%
  filter(grepl("proportion of residents", description.en)) %>%
  pull(id)

claimant_measure_wap <- nomisr::nomis_get_metadata(claimant_code, "MEASURE") %>%
  filter(grepl("proportion of the workforce", description.en)) %>%
  pull(id)

claimant_gender <- nomisr::nomis_get_metadata(claimant_code, "GENDER") %>%
  filter(grepl("Total", description.en)) %>%
  pull(id)

#0 and 20
claimant_age <- nomisr::nomis_get_metadata(claimant_code, "AGE")

claimant_freq <- nomisr::nomis_get_metadata(claimant_code, "FREQ") %>%
  filter(grepl("Annual", description.en)) %>%
  pull(id)

claimant_geo_type <- nomisr::nomis_get_metadata(claimant_code, "GEOGRAPHY", type = "type") %>%
  filter(grepl("local authorities: district", description.en)) %>%
  filter(grepl("2021", description.en)) %>%
  pull(id)

claimant_geo_area <- nomisr::nomis_get_metadata(claimant_code, "GEOGRAPHY", type = claimant_geo_type) %>%
  filter(grepl("Aberdeenshire", description.en)) %>%
  pull(parentCode)

claimant_uri <- "https://www.nomisweb.co.uk/api/v01/dataset/NM_162_1.data.csv?geography=2013265931TYPE432&MEASURES=20100&MEASURE=1&FREQ=A&GENDER=A&SEX=7"

