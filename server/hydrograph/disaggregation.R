

output$hydgrph.prse <- renderDygraph({isolate(
  if (!is.null(sta$hyd)){
    withProgress(message = 'parsing hydrograph..', value = 0.1, {
      if(is.null(sta$hyd$qtyp)) sta$hyd <- parse_hydrograph(sta$hyd,sta$k)
      # if(!is.null(sta$carea) && is.null(sta$hyd$evnt) ){sta$hyd <- discretize_hydrograph(sta$hyd, sta$carea, sta$k)}else{inclEV <<- FALSE}
      if( is.null(sta$hyd$evnt) ){sta$hyd <- discretize_hydrograph(sta$hyd, sta$carea, sta$k)}
    })
    withProgress(message = 'rendering plot..', value = 0.1, {
      flow_hydrograph_parsed(sta$hyd,TRUE)
    })
  }
)})



output$hydgrph.prse.scatter <- renderPlot({
  if (!is.null(sta$hyd$qtyp)){
    sta$hyd %>%
      mutate(new = ifelse(evnt > 0, 1, 0)) %>%
      mutate(new2 = cumsum(new)) %>%
      group_by(new2) %>%
      mutate(pevnt=sum(Rf+Sm, na.rm = TRUE)) %>%
      ungroup() %>%
      filter(new==1) %>%
      ggplot(aes(pevnt,evnt)) +
        theme_bw() + 
        geom_abline(slope=1,intercept=0, alpha=.5, linetype='dashed') +
        geom_point() + 
        labs(title=sta$label,x="Atmospheric yield (mm)", y="Event (discharge) yield (mm)") +
        coord_fixed()
  }
}, res=ggres)
