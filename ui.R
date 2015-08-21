library(shiny)
library(leaflet)
library(sp)


# Define UI for AccessiCity that draws a map
shinyUI(fluidPage(
  
  # Application title
  titlePanel("AccessiCity for Mexico City's General Transit Network"),
  
  # Sidebar with a checkbox and drop-down menu
  sidebarLayout(
    sidebarPanel(
      selectInput("RouteType", label = h3("Select Transit Type"), 
                  choices = list("Subway" = "Subway", "Bus" = "Bus",
                                 "Trolleybus" = "Trolleybus", "Train" = "Train"),
                  selected = "Subway"),
      checkboxInput("WheelchairAccessible", label = "Wheelchair Accessible", 
                    value = FALSE)
    ),
    
    # View map on right side of the page
    mainPanel(
      leafletOutput("mymap")
    )
  )
))