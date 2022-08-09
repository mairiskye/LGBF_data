library(magrittr)
library(httr)


get_hourly_pay <- httr::GET("https://www.nomisweb.co.uk/api/v01/dataset/NM_30_1.data.csv?geography=2013265931TYPE432&MEASURES=20100&SEX=7&PAY=6")
hourly_pay <- content(get_hourly_pay, as = "parsed", type = "text/csv") %>%
  as_tibble() 