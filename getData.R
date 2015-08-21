library(RCurl)
library(foreign)
library(plyr)

getData <- function(){

# Get Data from Github
url.Fix <- "https://raw.githubusercontent.com/allyapp/GTFS-viz/master/data/"

agency <- read.delim(textConnection(getURL(paste(url.Fix, "agency.txt", sep=""))), sep = ",")
calendar <- read.delim(textConnection(getURL(paste(url.Fix, "calendar.txt", sep=""))), sep = ",")
feed_info <- read.delim(textConnection(getURL(paste(url.Fix, "feed_info.txt", sep=""))), sep = ",")
frequencies <- read.delim(textConnection(getURL(paste(url.Fix, "frequencies.txt", sep=""))), sep = ",")
routes <- read.delim(textConnection(getURL(paste(url.Fix, "routes.txt", sep=""))), sep = ",")
shapes  <- read.delim(textConnection(getURL(paste(url.Fix, "shapes.txt", sep=""))), sep = ",")
stop_times <- read.delim(textConnection(getURL(paste(url.Fix, "stop_times.txt", sep=""))), sep = ",")
stops <- read.delim(textConnection(getURL(paste(url.Fix, "stops.txt", sep=""))), sep = ",")
transfers <- read.delim(textConnection(getURL(paste(url.Fix, "transfers.txt", sep=""))), sep = ",")
trips <- read.delim(textConnection(getURL(paste(url.Fix, "trips.txt", sep=""))), sep = ",")

# Join dataframes "stops", "stop_times", "trips", & "routes" by common ids. 
data.AccessiCity <- join(stops, stop_times, by="stop_id", match = "first")
data.AccessiCity <- join(data.AccessiCity, trips, by="trip_id")
data.AccessiCity <- join(data.AccessiCity, routes, by="route_id")

# View only relevant columns
selectedColumns <- c("stop_id", "stop_desc", "stop_lat", "stop_lon", 
                     "stop_name", "wheelchair_boarding","route_type" )

# Shrink dataset to what is used for task
data.AccessiCity <- data.AccessiCity[, colnames(data.AccessiCity) %in% 
                                       selectedColumns]

# Omit NA values
data.AccessiCity <- na.omit(data.AccessiCity)

# Declare route types by number, assign string
setRouteType <- function(route_type){
  if(route_type==0) route_type= "Light rail"
  else if(route_type==1) route_type= "Subway"
  else if(route_type==2) route_type= "Train"
  else if(route_type==3) route_type= "Bus"
  else if(route_type==4) route_type= "Ferry"
  else if(route_type==5) route_type= "Cable car"
  else if(route_type==6) route_type= "Gondola"
  else if(route_type==7) route_type= "Funicular"
  else if(route_type==800) route_type= "Trolleybus"
  else route_type=NA
  route_type
}

# Vectorize to apply function to all route_types, not just first 
setRouteType.V <- Vectorize(setRouteType)

# Attach to dataset
data.AccessiCity$route_type <- setRouteType.V(data.AccessiCity$route_type)

# Final dataset for AccessiCity
data.AccessiCity

}