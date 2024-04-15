
fluidPage(
  titlePanel("Aggregated summary"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create and copy summaries of queried data."),
      
      selectInput("dat.sum.mnt", 
                  label = "Choose Time of Year",
                  choices = c("All Year", 
                              "January",
                              "February",
                              "March",
                              "April",
                              "May",
                              "June",
                              "July",
                              "August",
                              "September",
                              "October",
                              "November",
                              "December"
                  ),
                  selected = "All Year"),
      
      sliderInput("dat.sum.rng", 
                  label = "Range of interest:",
                  min = 0, max = 100, value = c(0, 100)),
      width=2
      ),
    
    mainPanel(
      fluidRow(
        formattableOutput('dat.sum.tbl')
      ),
      width=10
    )
  )
  )