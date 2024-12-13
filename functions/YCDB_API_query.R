##########################################################
#################### YCDB querying ####################### 
##########################################################
# By M. Marchildon
#
# Nov, 2019
##########################################################



###########################################################################################
## sources
###########################################################################################
source("functions/owrc-api.R", local = TRUE)


###########################################################################################
## API addresses
###########################################################################################
ldbc <- 'http://data.oakridgeswater.ca:8080/locsw' 
idbc <- 'http://data.oakridgeswater.ca:8080/intgen/2/'


###########################################################################################
## collect locations
###########################################################################################
qStaLoc <- function(API){
  print(API)
  tblSta <- fromJSON(API)
  # colnames(tblSta)[2] <- "sID"    # INT_ID (IID)
  # colnames(tblSta)[3] <- "sName"  # LOC_NAME (NAM1)
  # colnames(tblSta)[4] <- "sName2" # LOC_NAME_ALT1 (NAM2)
  tblSta$DTb <- as.POSIXct(tblSta$DTb, format="%Y-%m-%dT%H:%M:%SZ")
  tblSta$DTe <- as.POSIXct(tblSta$DTe, format="%Y-%m-%dT%H:%M:%SZ")
  return(tblSta)
}


###########################################################################################
## collect location info
###########################################################################################
qStaCarea <- function(API,LOC_ID){
  t1 <- qStaLoc(API)
  return(t1[t1$LOC_ID==LOC_ID,]$DA)
}


qStaInfo <- function(API,LOC_ID){
  t1 <- qStaLoc(API)
  o1 <- t1[t1$LOC_ID %in% qStaAgg(t1[!is.na(t1$LOC_MASTER_LOC_ID),],LOC_ID),]
  if (empty(o1)) showNotification(paste0("Error INT_ID for LOC_ID: ",LOC_ID," not found."))
  return(o1)
}
qStaAgg <- function(df,LOC_ID) {
  df2 <- df[df$LOC_MASTER_LOC_ID==LOC_ID,]
  if ( empty(df2) ) return(LOC_ID)
  df2$LOC_ID
}


###########################################################################################
## YCDB temporal Query
###########################################################################################
qTemporal <- function(API,INT_ID){
  print(paste0('qTemporal, querying: ',INT_ID))
  if (length(INT_ID)>1) {
    # aggregate stations
    qAll <- INT_ID %>% map_df(~fromJSON(paste0(API, .), flatten = TRUE))
  } else {
    url <- paste0(API,INT_ID)
    print(url)
    qAll <- fromJSON(url) 
  }
  qFlow <- qAll[qAll$RDNC == 1001,]
  Date <- zoo::as.Date(qFlow$Date)
  Flow <- as.numeric(qFlow$Val)
  Flag <- as.character(qFlow$RDTC)
  
  if (length(Flag)==0) {
    Flag <- rep("", length(Date))
  } else {
    Flag[is.na(Flag)] <- ""
    Flag[Flag == -1] <- ""
    Flag[Flag == 24] <- "ice_conditions"
    Flag[Flag == 78] <- "estimate"
    Flag[Flag == 47] <- "partial"
    Flag[Flag == 34] <- "dry_conditions"
    Flag[Flag == 113] <- "revised"
    Flag[Flag == 114] <- "realtime_uncorrected"
    Flag[Flag == 116] <- "modelled"   
  }
  
  data.frame(Date,Flow,Flag)
}

qTemporal_byLOC_ID <- function(lAPI,iAPI,LOC_ID){
  t1 <- qStaLoc(lAPI)
  return(qTemporal(iAPI,t1[t1$LOC_ID==LOC_ID,]$IID))
}


###########################################################################################
## load temporal Query as .csv
###########################################################################################
qTemporal_csv <- function(fp) {
  df <- read.csv(fp)
  Flow <- as.numeric(df$Flow)
  Flag <- as.character(df$Flag)
  Flag[is.na(Flag)] <- ""
  Flag[Flag == "B"] <- "ice_conditions"
  Flag[Flag == "E"] <- "estimate"
  Flag[Flag == "A"] <- "partial"
  Flag[Flag == "D"] <- "dry_conditions"
  Flag[Flag == "R"] <- "revised"
  Flag[Flag == "raw"] <- "realtime_uncorrected"
  
  Date <- zoo::as.Date(df$Date)
  return(data.frame(Date,Flow,Flag))
} 


get.supplimental <- function(info) {
  owrc.api(info[['LAT']][1],info[['LONG']][1])
}


observe({
  sta$lnk <- paste0('<a href="https://owrc.shinyapps.io/shydrograph/?t=5&i=',sta$iid,'" target="_blank" rel="noopener noreferrer">open in general timeseries analysis tool</a>')
})