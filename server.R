# ---- app4-server ----

library(shiny)
#setwd("C:/Users/kaazal/Documents/Reproducible Research/Stormdata")
fileUrl <- ("https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2")
download.file(fileUrl,destfile = "file.csv")
storm <- read.csv("file.csv",header = TRUE)
library(dplyr)
library(ggplot2)

Stormdata <- subset(storm[c ("EVTYPE","FATALITIES","INJURIES","PROPDMG","PROPDMGEXP","CROPDMG","CROPDMGEXP")])

TotalFATALITIES <- aggregate(FATALITIES ~ EVTYPE, storm,sum)
TopFATALITIES <- TotalFATALITIES[order(TotalFATALITIES$FATALITIES,decreasing=TRUE), ]
Top10FATALITIES <- head(arrange(TopFATALITIES,desc(FATALITIES)), n = 10)
Top10FATALITIES <- mutate(Top10FATALITIES,Rank = seq(1:10))
FATALITIES_g <- ggplot(Top10FATALITIES,aes(EVTYPE,FATALITIES,fill=EVTYPE))
FATALITIES_g <- FATALITIES_g+geom_bar(stat="identity") +xlab("EVTYPE") + ylab("FATALITIES") +ggtitle('TOP FATALITIES')+coord_cartesian(xlim = c(0, 10))

TotalINJURIES <- aggregate(INJURIES ~ EVTYPE,storm,sum)
TopINJURIES <- TotalINJURIES[order(TotalINJURIES$INJURIES,decreasing = TRUE), ]
Top10INJURIES <- head(arrange(TopINJURIES,desc(INJURIES)), n = 10)
Top10INJURIES <- mutate(Top10INJURIES,Rank = seq(1:10))
INJURIES_g <- ggplot(Top10INJURIES,aes(EVTYPE,INJURIES,fill=EVTYPE))
INJURIES_g <- INJURIES_g+geom_bar(stat="identity") +xlab("EVTYPE") + ylab("INJURIES") +ggtitle('TOP INJURIES')

Stormdata$PROPEXP[Stormdata$PROPDMGEXP == "H"] <- 100
Stormdata$PROPEXP[Stormdata$PROPDMGEXP == "K"] <- 1000
Stormdata$PROPEXP[Stormdata$PROPDMGEXP == "M"] <- 1000000
Stormdata$PROPEXP[Stormdata$PROPDMGEXP == "B"] <- 1000000000
Stormdata$PROPDMGEXPCONSEQ <-Stormdata$PROPDMG * Stormdata$PROPEXP
TotalECONOMICCONSEQ <- aggregate(PROPDMGEXPCONSEQ ~ EVTYPE, Stormdata,sum)
TopECONOMICCONSEQ <- TotalECONOMICCONSEQ[order(TotalECONOMICCONSEQ$PROPDMG,decreasing=TRUE), ]
Top10ECONOMICCONSEQ <- head(arrange(TopECONOMICCONSEQ,desc(PROPDMGEXPCONSEQ)), n = 10)
Top10ECONOMICCONSEQ <- mutate(Top10ECONOMICCONSEQ,Rank = seq(1:10))
ECONOMIC_g <- ggplot(Top10ECONOMICCONSEQ,aes(EVTYPE,PROPDMGEXPCONSEQ,fill=EVTYPE))
ECONOMIC_g <- ECONOMIC_g+geom_bar(stat="identity") +xlab("EVTYPE") + ylab("PROPDMG") +ggtitle('TOP ECONOMIC CONSEQUENCES')+coord_cartesian(xlim = c(0, 10))


plotType <- function(Stormdata, type) {
  switch(type,
         TOP_FATALITIES = FATALITIES(Stormdata),
         TOP_INJURIES = INJURIES(Stormdata),
         TOP_ECONOMIC_CONSEQUENCES = ECONOMIC(Stormdata))
}

FATALITIES <- function(Stormdata){
    FATALITIES_g
}

INJURIES <- function(Stormdata){
    INJURIES_g
}

ECONOMIC <- function(Stormdata){
    ECONOMIC_g
  
}

function(input, output) {
  
  output$text <- renderText("This app uses filtered and analysed data from the dataset of US NOAA (National Oceanic and Atmospheric Administration).
                            The plots presented in this shiny app displays the most harmful weather events with the top ten fatalities,injuries and the greatest economic consequences with respect to population health events.")
  
  output$text1 <- renderText("Select the option on the left side to display respective plot.")
 
  output$message <- renderText(
    
    if(input$pType == "TOP_FATALITIES"){
        paste0("Types of events that are most harmful with respect to population health Events with highest Fatalities.")
    } else if(input$pType == "TOP_INJURIES"){
        paste0("Types of Events that are most harmful with respect to population health Events with highest Injuries." )
    } else if(input$pType == "TOP_ECONOMIC_CONSEQUENCES"){
        paste0("Types of Events that have the Greatest Economic Consequences, Events with highest Property damages." )
    }
  
    )
  
  output$plots <- renderPlot({
          plotType(Stormdata, input$pType)
    })

}
