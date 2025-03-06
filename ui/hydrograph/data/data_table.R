fluidRow(
  sidebarPanel(
    dateRangeInput("tabRng", label = "Date range"),
    br(), actionButton("tabCmplt", "Include all computations"),
    br(), br(), downloadButton("tabCsv", "Download csv.."),
    br(), br(), downloadButton("btnCarea", "Download catchment area"),
    width=2
  ),
  mainPanel(
    DT::dataTableOutput('tabSta'), br(),
    DT::dataTableOutput('tabhyd'),
    width=10
  )
)