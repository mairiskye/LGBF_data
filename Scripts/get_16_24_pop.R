

search_16_24 <- httr::GET("https://www.nomisweb.co.uk/api/v01/dataset/NM_2002_1.data.csv?geography=2013265931TYPE432&time=2010,latest&c_age=250&gender=0&measures=20100&select=date,geography_name,obs_value")
pop_16_24_data <- content(search_16_24, as = "parsed")

#use nomisr get_metadata() to find the code parameters
pop_est_by_single_year_meta <- nomisr::nomis_get_metadata("NM_2002_1")


