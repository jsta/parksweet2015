#Park and Sweet found trends of:   vaca = 3.8 +- 0.4
#                              virginia = 3.9 +- 0.8

dt <-  list(vaca = read.csv("data/vaca.csv", stringsAsFactors = FALSE), virginia = read.csv("data/virginia.csv", stringsAsFactors = FALSE))

calc_trend <- function(x){
  names(x) <- c("date", "MSL")
  x$date <- as.POSIXct(x$date)
  x$diffdate <- as.numeric(julian(x$date, x$date[1])/365.25)
  x$MSL <- x$MSL * 1000 #m to mm
  
  fit <- lm(MSL ~ diffdate, data = x)
  c(coef(fit)[2], summary(fit)$coefficients[,2][2])
}

dt <- lapply(dt, calc_trend)
dt <- data.frame(matrix(unlist(dt), ncol = 2, byrow = TRUE))
names(dt) <- c("Trend (mm yr-1)", "Uncertainty (se)")
dt$Station <- c("Vaca Key", "Virginia Key")
dt <- dt[,c(3,1,2)]
write.csv(dt, "data/wlevel_trend.csv", row.names = FALSE)
