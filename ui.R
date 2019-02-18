library(shiny)

fluidPage(
  titlePanel("Storm Data Analysis"),
  
  sidebarLayout(
    sidebarPanel(
      radioButtons("pType", "Choose plot type:", list("TOP_FATALITIES", "TOP_INJURIES", "TOP_ECONOMIC_CONSEQUENCES"))
    ),
    
    mainPanel(
        
      plotOutput("plots")
    )
  )
)