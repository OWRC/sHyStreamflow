
met.api <- 'http://fews.oakridgeswater.ca:8080/dymetc/'
capi <- "http://golang.oakridgeswater.ca:8080/carea/"
cidapi <- "http://golang.oakridgeswater.ca:8080/careacid/"

owrc.api <- function(lat,lng) {
  # collect interpolated data
  df <- jsonlite::fromJSON(paste0(met.api,lat,'/',lng))
  if ( length(df)==1 && df=="NA" ) return(NULL)
  df[df == -999] <- NA # do this before converting date
  df$Date = as.Date(df$Date)
  # df$Pa = df$Pa/1000 # to kPa
  return(df)  
}

owrc.carea <- function(lat, lng) {
  url <- paste0(capi,lat,"/",lng)
  print(url)
  return(g <- readLines(url) %>% paste(collapse = "\n"))
}

owrc.carea.cid <- function(cid) {
  url <- paste0(cidapi,cid)
  print(url)
  return(readLines(url) %>% paste(collapse = "\n"))
}