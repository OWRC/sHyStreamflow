
met.api <- 'http://fews.oakridgeswater.ca:8080/dymetc/'
capi <- "http://golang.oakridgeswater.ca:8080/carea/"
cidapi <- "http://golang.oakridgeswater.ca:8080/careacid/"

getCDS <- function(url){
  out <- tryCatch(
    {
      jsonlite::fromJSON(url)
    },
    error=function(cond) {
      return(NULL)
    },
    warning=function(cond) {
      return(NULL)
    },
    finally={}
  )
  out[out==-999] <- NA
  return(out)
}

owrc.api <- function(lat,lng) {
  # collect interpolated data
  df <- getCDS(paste0(met.api,lat,'/',lng))
  if ( length(df)==0 ) return(NULL)
  if ( length(df)==1 && df=="NA" ) return(NULL)
  df[df == -999] <- NA # do this before converting date
  df$Date = as.Date(df$Date)
  # df$Pa = df$Pa/1000 # to kPa
  return(df)  
}

getCarea <- function(url){
  out <- tryCatch(
    {
      readLines(url)
    },
    error=function(cond) {
      return(NULL)
    },
    warning=function(cond) {
      return(NULL)
    },
    finally={}
  )
  return(out)
}

owrc.carea <- function(lat, lng) {
  url <- paste0(capi,lat,"/",lng)
  print(url)
  g <- getCarea(url)
  if ( length(g)==0 ) return(NULL)
  if ( length(g)==1 && g=="NA" ) return(NULL)  
  return(g %>% paste(collapse = "\n"))
}

owrc.carea.cid <- function(cid) {
  url <- paste0(cidapi,cid)
  print(url)
  g <- getCarea(url)
  if ( length(g)==0 ) return(NULL)
  if ( length(g)==1 && g=="NA" ) return(NULL)  
  return(g %>% paste(collapse = "\n"))
}