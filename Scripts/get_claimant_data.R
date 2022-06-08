library(httr)

#claimants as a proportion of residents aged 16-64
get_wap_claimant_propo <- httr::GET("https://www.nomisweb.co.uk/api/v01/dataset/NM_162_1.data.csv?geography=2013265931TYPE432&measure=2&measures=20100&gender=0&time=2010,latest&age=0")
wap_claimant_propo <- content(get_wap_claimant_propo, as = "parsed", type = "text/csv") %>%
  as.tibble()

#16-24 claimant count
get_claimant_count_16_24 <- httr::GET("https://www.nomisweb.co.uk/api/v01/dataset/NM_162_1.data.csv?geography=2013265931TYPE432&measure=1&measures=20100&gender=0&time=2010,latest&age=2")
claimant_count_16_24 <- content(get_claimant_count_16_24, as = "parsed", type = "text/csv") %>%
  as.tibble()

#NEXT: obtain mid-year pop estimate for 16-24 >DONE see script 'get_16-24_data'
#THEN: divide 