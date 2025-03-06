fluidRow(
  headerPanel('Data quality by count'),
  htmlOutput("hdr.qual"), br(),
  column(6, h4('count'),
         tableOutput('qaqc.cnt')),
  column(6, h4('average discharge'),
         tableOutput('qaqc.avg'))
)
