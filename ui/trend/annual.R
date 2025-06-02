
fluidPage(
  titlePanel('Annual series'),
  column(6, plotOutput('yr.q')),
  column(6, plotOutput('yr.q.rel')), 
  shiny::includeMarkdown("md/rightclick.md"), br(),
  downloadButton("yr.tabCsv", "Download csv.."), br(), br(),
  shiny::includeMarkdown("md/bfannnotes.md") 
)