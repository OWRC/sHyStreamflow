##########################################################
#################### sHyStreamflow ####################### 
#### A Shiny-Leaflet interface to the YPDT database.  ####
##########################################################
# Hydrological streamflow analysis tools
#
# By M.Marchildon
# v.1.9.2
# May, 2025
##########################################################


source("pkg/packages.R", local = TRUE)


sta.id <- '02EC009' # 149116 # NULL # -1118703211 # 731100015 # 731400017 # 731400010 # 731400011 # 149203 # 149203 # 731100016 # '149343' # '149130' # 149118 # 2147456340 # 


shinyApp(
  ui <- fluidPage(
    useShinyjs(),
    tags$head(includeCSS("pkg/styles.css")),
    tags$head(tags$script(HTML(jscode.mup))),
    inlineCSS(appLoad),

    # Loading message
    div(
      id = "loading-content",
      div(class='space300'),
      h2("Loading..."),
      div(img(src='ORMGP_logo_no_text_bw_small.png')), br(),
      shiny::img(src='loading_bar_rev.gif')
    ),

    # The main app
    hidden(
      div(
        id = "app-content",
        list(tags$head(HTML('<link rel="icon", href="favicon.png",type="image/png" />'))),
        div(style="padding: 1px 0px; height: 0px", titlePanel(title="", windowTitle="sHyStreamflow")), # height: 0px
        navbarPage(
          title=div(img(src="ORMGP_logo_no_text_short.png", height=11), "sHyStreamflow v1.9.2"),
          source(file.path("ui", "hydrograph.R"), local = TRUE)$value,
          source(file.path("ui", "trends.R"), local = TRUE)$value,
          source(file.path("ui", "stats.R"), local = TRUE)$value,
          source(file.path("ui", "about.R"), local = TRUE)$value,
          source(file.path("ui", "references.R"), local = TRUE)$value
        )
      )
    )
  ),
  
  server <- function(input, output, session){
    ###################
    ### Parameters & methods:
    source("pkg/app_members.R", local = TRUE)$value
    source("pkg/sources.R", local = TRUE)
    ggres <<- 128 # ggplot resolution (default=72)
    
    ###################
    ### (hard-coded) Load station ID:
    if(!is.null(sta.id)) collect_hydrograph(sta.id) # for hard-coded station selection
    hide('chk.yld')
    ### Load from URL:
    observe({
      query <- parseQueryString(session$clientData$url_search)
      if (!is.null(query[['sID']])) {
        collect_hydrograph(query[['sID']])
      } else {
        if(is.null(sta.id)) showNotification(paste0("Error: URL invalid."))
      }
    })

    
    ### load external code:
    source("server/server_sources.R", local = TRUE)$value
    
    session$onSessionEnded(stopApp)
  }
)
