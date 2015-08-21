rm(list=ls())

library(shiny)
library(leaflet)
library(sp)

load(file = "data.AccessiCity.RData")

# Define server logic required to draw AccessiCity map
shinyServer(function(input, output) {
  
  # Expression that generates a map. The expression is
  # wrapped in a call to renderLeaflet to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a leaflet map
  
  output$mymap <- renderLeaflet({
    # output returns all existing stops or, if input is WheelchairAccessible, only stops with wheelchair accessibility
    if(input$WheelchairAccessible){
      data.Map <- subset(data.AccessiCity, wheelchair_boarding == 1)
    }
    else{
      data.Map <- data.AccessiCity
    }
    # Transportation selectable by mode
    data.Map <- subset(data.Map, route_type == input$RouteType)
    
    # If one of the transit modes (Subway) does not provide any support for wheelchair boarding, keep the map as it is, and don't throw an error only because no points exist
    if(nrow(data.Map)==0){
      data.Map <- subset(data.AccessiCity, route_type == input$RouteType)
      Circle.fillOpacity = 0
      Polygon.fillOpacity = 0
      }
    else{
      Circle.fillOpacity = 1
      Polygon.fillOpacity = 0.5
      }
    
#     Idea: Compute "Convex Hull of a Set of Points" to draw a polygon displaying transit coverage
#     "Chull" computes the subset of points which lie on the convex hull of the set of points specified.
    ConvexHull.Index <- chull(data.Map$stop_lon, 
                              data.Map$stop_lat)
    
    Polygon.coords <- cbind(data.Map$stop_lon[ConvexHull.Index],
                            data.Map$stop_lat[ConvexHull.Index])
    # Necessary "An integer vector giving the indicies of the unique points lying on the convex hull... The first will be returned for duplicate points."
    Polygon.coords <- rbind(Polygon.coords, Polygon.coords[1, ])
    
    # create objects of class SpatialPolygons
    Polygon.Map <- Polygon(Polygon.coords)
    
    # draw map, specify popup
    leaflet(data = data.Map) %>%
              addProviderTiles("Stamen.TonerLite",
                               options = providerTileOptions(noWrap = TRUE)
              ) %>%
    addPolygons(data = Polygon.Map,
      stroke = FALSE, fillOpacity = Polygon.fillOpacity, smoothFactor = 0.5,
      color = "#9ecae1"
    )  %>%
    addCircleMarkers(radius = 5, 
                     stroke = FALSE, fillOpacity = Circle.fillOpacity,
                     ~stop_lon, ~stop_lat,
                     popup = ~stop_name,
                     fillColor = "#3182bd")
  })
})