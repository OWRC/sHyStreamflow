
# output$selected_var <- renderText({ 
#   if (!is.null(sta$hyd)) {
#     if (!sta$BFbuilt) separateHydrograph()
#     # df <- sta$hyd[sta$hyd$Date >= input$tabRng[1] & sta$hyd$Date <= input$tabRng[2],]
#     df <- sta$hyd
#     if (ncol(df) > 4) {
#       nl <- df %>% summarise_each(funs(mean(., na.rm = TRUE)))
#       # print(nl)
#       # paste(summarise_each(df, funs(mean)), collapse='\n' )
#       paste(sta$name,paste(names(nl),nl,sep="\t",collapse="\n"),sep="\n")
#     } else {
#       "best to have all computed.."
#     }
#   }
#   #paste("You have selected", input$var)
# })


output$dat.sum.tbl <- renderFormattable({ 
  req(mnt.sel <- input$dat.sum.mnt)
  if (!is.null(sta$hyd)) {
    if (!sta$BFbuilt) separateHydrograph()
    # df <- sta$hyd[sta$hyd$Date >= input$dat.sum.rng[1] & sta$hyd$Date <= input$dat.sum.rng[2],]
    df <- sta$hyd
    if (ncol(df) > 4) {
      
      if (mnt.sel!="All Year") {
        df <- df %>% 
          mutate(mnt=month.name[lubridate::month(Date)]) %>%
          dplyr::filter(mnt==mnt.sel) %>% 
          dplyr::select(-c('mnt','Date', 'Flag'))
      } else {
        df <- df %>% dplyr::select(-c('Date', 'Flag'))
      }
      
      mn <- df %>% summarise_each(funs(mean(., na.rm = TRUE)))
      md <- df %>% summarise_each(funs(median(., na.rm = TRUE)))
      p5 <- df %>% summarise_each(funs(quantile(.,.05, na.rm = TRUE)))
      p16 <- df %>% summarise_each(funs(quantile(.,.158, na.rm = TRUE)))
      p84 <- df %>% summarise_each(funs(quantile(.,.842, na.rm = TRUE)))
      p95 <- df %>% summarise_each(funs(quantile(.,.95, na.rm = TRUE)))
      as.data.frame(t(rbind(mn, md, p5, p16, p84, p95))) %>% 
        dplyr::rename("mean"=V1, "median"=V2,"p5"=V3,"p16"=V4,"p84"=V5,"p95"=V6) %>% 
        formattable(digits=3)
    } else {
      "best to have all computed.."
    }
  }
  #paste("You have selected", input$var)
})