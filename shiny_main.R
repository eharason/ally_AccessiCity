### main file to run AccessiCity ShiyApp

rm(list=ls())
 
# Set working directory
setwd("~/Documents/Muenster/Praktikum/ally")

source('ShinyApp/getData.R')
data.AccessiCity <- getData()

# Save dataframe to file, save on processing time
save(data.AccessiCity, file = "ShinyApp/data.AccessiCity.RData")

library(shinyapps)
shinyapps::deployApp('ShinyApp')