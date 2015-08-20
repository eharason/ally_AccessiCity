library(shiny)
library(leaflet)
library(sp)


# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("AccessiCity for Mexico City's General Transit Network"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput("RouteType", label = h3("Select Transit Type"), 
                  choices = list("Subway" = "Subway", "Bus" = "Bus",
                                 "Trolleybus" = "Trolleybus", "Train" = "Train"),
                  selected = "Subway"),
      checkboxInput("WheelchairAccessible", label = "Wheelchair Accessible", 
                    value = FALSE)

    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      leafletOutput("mymap")
    )
  )
))