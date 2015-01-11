## This script will plot the Global Active Power by timestamp over the 
## required 2 days.  It does so by:
## - loading the text file
## - extracting the required days
## - conditioning the needed columns
## - building a working data frame
## - setting the graphic device to png
## - plotting the graph to the file
## - closing the device

## set the working directory
setwd("~/R/EDA")

## identify the textfile containing the data
textFile <- "./data/household_power_consumption.txt"

## read in the file as semicolon delimited, with headers, without factors
textDF <- read.table(file = textFile, 
                      header = TRUE, 
                      sep = ";", 
                      stringsAsFactors = FALSE)

## Create an intermediate file with just the two dates
## No missing values were found in this segement
targetDF <- textDF[(textDF$Date == "1/2/2007" | textDF$Date == "2/2/2007"),]
## Convert the date and time fields into a timestamp, add column to the dataframe
targetDF$ts <- strptime(paste(targetDF$Date, targetDF$Time), "%d/%m/%Y %H:%M:%S")
## Convert the active power column to numeric and add it to the dataframe
targetDF$apwr <- as.numeric(targetDF$Global_active_power)
## Create a working dataframe from the needed columns, just for speed and tidyness
wrkDF <- data.frame(ts=targetDF$ts, 
                   apwr=targetDF$apwr, 
                   stringsAsFactors = FALSE)

## Create the line graph for plot 2 and save it to a png file using default 480x480
png("plot2.png")
plot(wrkDF$ts, # use the tmestamp column of the working dataframe as the x axis
     wrkDF$apwr, # use the power column of the working dataframe as the y axis
     type="n", # draw graph without plotting points
     ylab="Global Active Power (killowatts)", # create y axis label
     xlab="") # remove x axis label
lines(wrkDF$ts, wrkDF$apwr, type="l") # now draw the x and y points
dev.off()
