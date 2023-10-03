

# A simpler output set to the main hydrographs date selector

output$tabdischarge <- DT::renderDataTable({
    if (!is.null(sta$hyd)){
      return(dRange())
    }
  }, 
  options = list(scrollY='100%', scrollX=TRUE,
            lengthMenu = c(5, 10, 30, 100, 365, 3652),
            pageLength = 10,
            searching=FALSE)
)

output$tabdischargeCsv <- downloadHandler(
  filename <- function() { paste0(sta$name, '.csv') },
  content <- function(file) {
    if (!is.null(sta$hyd)){
      dat.out <- dRange()
      write.csv(dat.out[!is.na(dat.out$Flow),], file, row.names = FALSE)
    }
  }
)