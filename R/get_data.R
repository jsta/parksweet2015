library(rnoaa)

get_wlevel <- function(station_name, begin_date, end_date, datum){
  
  dt <- rnoaa::coops_search(station_name = station_name, begin_date = begin_date, end_date = end_date, datum = datum, product = "monthly_mean")$data
  
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
lapply(names(dt), function(x) write.csv(dt[x], paste0("data/", x, ".csv"), row.names = FALSE))
