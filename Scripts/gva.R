library(opendatascot)
library(httr)
library(jsonlite)

datasets <- opendatascot::ods_all_datasets()

school_leaver_destinations <- opendatascot::ods_dataset("school-leaver-destinations")

positive_destinations <- opendatascot::ods_structure("positive-destinations")

library(onsr)

all <- httr:: GET("https://api.beta.ons.gov.uk/v1/datasets", limit=1000)
resp <- httr::content(all, as = "text") %>% fromJSON()
datasets <- resp$items

dataset_onsr <- onsr::ons_ids() %>% as_tibble()

gva <- onsr::ons_get(	"gva-by-industry-by-local-authority")
scotland_geographies <- gva$`administrative-geography`[grep("s", gva$`administrative-geography`, ignore.case = T)] %>% unique()

gva_str <- onsr::ons_dim("gva-by-industry-by-local-authority")

gva_extract <- gva %>%
  filter(`administrative-geography` %in% scotland_geographies) %>%
  filter(UnofficialStandardIndustrialClassification == "Total") %>%
  filter(Time > 2007) %>%
  select(Geography, Time, v4_1)
