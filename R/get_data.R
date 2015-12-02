get_wlevel <- function(station_name, begin_date, end_date, datum){
  
  xml_data <- XML::xmlParse(paste0("http://tidesandcurrents.noaa.gov/api/datagetter?begin_date=", begin_date,"&end_date=", end_date, "&station=", station_name, "&product=monthly_mean&datum=", datum, "&units=metric&time_zone=gmt&application=web_services&format=xml"))
  
  xml_data <- XML::xmlToList(xml_data)
  
  dt <- data.frame(matrix(do.call("c", as.list(xml_data[["observations"]])), ncol = 18, byrow = TRUE), stringsAsFactors = FALSE)
  names(dt) <- names(xml_data[[2]][[1]])  
  
  dt$month <- sapply(dt$month, function(x) {if (nchar(x) < 2){
    paste0("0", x)
  }else{
    x
  }})
  
  dt$date <- as.POSIXct(strptime(paste0(dt$year, "-", dt$month, "-01"), format = "%Y-%m-%d"))
  dt <- dt[, c("date", "MSL")]
  dt$MSL <- as.numeric(dt$MSL)
  
  dt
}

get_data <- function(){  
  vaca <- get_wlevel(station_name = 8723970, begin_date = 19820301, end_date = 20141001, datum = "stnd")
  
  virginia <- get_wlevel(station_name = 8723214, begin_date = 19940101, end_date = 20150101, datum = "mllw")
  
  list(vaca = vaca, virginia = virginia)
}

dt <- get_data()
lapply(names(dt), function(x) write.csv(dt[x], paste0("data/", x, ".csv")))
                                        





  #use difftime to convert dt$date to units of years
  #looking for a trend of:   vaca = 3.8 +- 0.4
  #                      virginia = 3.9 +- 0.8

lapply(dt, head)




