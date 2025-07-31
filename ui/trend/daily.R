
fluidPage(
  titlePanel('Distributions of mean-daily discharge'),
  fluidRow(
    sidebarPanel(
     h4("select date range:"),
     dygraphOutput("rng.mdd"), br(),
     shiny::includeMarkdown("md/dtrng.md"),
     br(), downloadButton("mdd.tabCsv", "Download as csv..")
    ),
    mainPanel(
     shiny::includeMarkdown("md/doy.md"),
     plotOutput('dy.q'),
     plotOutput('dy.qmmm'),
     # plotOutput('dy.qbox'),
     br(), shiny::includeMarkdown("md/rightclick.md")
   )
  )  
)

