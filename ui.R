library(shiny)

fluidPage(
  titlePanel("Storm Data Analysis"),
  
  sidebarLayout(
    sidebarPanel(
      radioButtons("pType", "Choose plot type:", list("TOP_FATALITIES", "TOP_INJURIES", "TOP_ECONOMIC_CONSEQUENCES"))
    ),
    
    mainPanel(
      textOutput("text"),
      br(),
      textOutput("text1"),
      br(),
      textOutput("message"),
      br(),
      plotOutput("plots")
    )
  )
)