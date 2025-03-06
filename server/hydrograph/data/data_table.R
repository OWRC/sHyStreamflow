
#### data tables
output$tabSta <- DT::renderDataTable({
  if (!is.null(sta$info)){
    drop <- c("LOC_ID","INT_ID","LOC_COORD_EASTING","LOC_COORD_NORTHING","LOC_MASTER_LOC_ID","DA2023","cellID")
    df <- sta$info[,!(names(sta$info) %in% drop)] %>% 
      mutate(DTb=year(DTb), DTe=year(DTe)) %>%
      dplyr::rename(StationID=LOC_NAME, StationName=LOC_NAME_ALT1, Latitude=LAT, Longitude=LONG, Elevation=GRND_ELEV, DrainageArea=SW_DRAINAGE_AREA_KM2, nData=CNT, YearBegin=DTb, YearEnd=DTe) %>% 
      relocate(any_of(c("StationID", "StationName", "Latitude", "Longitude", "Elevation", "DrainageArea", "YearBegin", "YearEnd", "nData")))
    DT::datatable(df, rownames = FALSE) %>%
      # formatPercentage('Quality', 0) %>%
      formatRound(c('Latitude', 'Longitude','Elevation','p16','p84'), 3) %>%
      formatRound('DrainageArea',1)
  }
})

output$tabhyd <- DT::renderDataTable({
    if (!is.null(sta$hyd)){
      df <- sta$hyd[sta$hyd$Date >= input$tabRng[1] & sta$hyd$Date <= input$tabRng[2],]
      if (!is.null(df$qtyp)){
        df$qtyp <- as.character(df$qtyp)
        df$qtyp[df$qtyp=="1"] <- "Rising Limb"
        df$qtyp[df$qtyp=="2"] <- "Falling Limb"
        df$qtyp[df$qtyp=="3"] <- "Flow Recession"
      }
      # if (ncol(df) > 3 + 6) {
      #   df %>% select(-c('BF.min','BF.max'))
      # } else {
      #   df
      # }
      # return(df)
      DT::datatable(df) %>%
        formatRound('Flow',3) %>%
        formatRound(c('Tx', 'Tn', 'Rf', 'Sf', 'Sm'), 1)
    }
  }, 
  options = list(scrollY='100%', scrollX=TRUE,
            lengthMenu = c(5, 30, 100, 365, 3652),
            pageLength = 100,
            searching=FALSE)
)

observe(updateDateRangeInput(session, "tabRng", start = sta$DTb, end = sta$DTe, min = sta$DTb, max = sta$DTe))

observeEvent(input$tabCmplt, {
  if (!sta$BFbuilt) separateHydrograph()
  if (is.null(sta$hyd$qtyp)) {
    sta$hyd <- parse_hydrograph(sta$hyd,sta$k)
    # if(!is.null(sta$carea) && is.null(sta$hyd$evnt)) sta$hyd <- discretize_hydrograph(sta$hyd,sta$carea,sta$k)
    if ( is.null(sta$hyd$evnt) ) sta$hyd <- discretize_hydrograph(sta$hyd,sta$carea,sta$k)
  }
})

output$tabCsv <- downloadHandler(
  filename <- function() { paste0(sta$name, '.csv') },
  content <- function(file) {
    if (!is.null(sta$hyd)){
      dat.out <- sta$hyd[sta$hyd$Date >= input$tabRng[1] & sta$hyd$Date <= input$tabRng[2],]
      write.csv(dat.out[!is.na(dat.out$Flow),], file, row.names = FALSE)
    }
  }
)

output$btnCarea <- downloadHandler(
  filename <- function() { paste0(sta$name, '.geojson') },
  content <- function(file) {
    if (!is.null(sta$geojson)) write(sta$geojson, file)
  }
)
