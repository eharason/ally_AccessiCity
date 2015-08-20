rm(list=ls())

setwd("~/Documents/Muenster/Praktikum/ally")

source('ShinyApp/getData.R')

data.AccessiCity <- getData()

save(data.AccessiCity, file = "ShinyApp/data.AccessiCity.RData")

library(shinyapps)
shinyapps::deployApp('ShinyApp')


runApp("ShinyApp")




