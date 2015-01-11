## This script will create 4 sub-plots covering most of the data in the househole
## power consumption by timestamp over the required 2 days.  It does so by:
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
## Convert the 3 sub-metering columns to numeric and add them to the dataframe
targetDF$sub1 = as.numeric(targetDF$Sub_metering_1)
targetDF$sub2 = as.numeric(targetDF$Sub_metering_2)
targetDF$sub3 = as.numeric(targetDF$Sub_metering_3)
## Convert the voltage column to numeric and add it to the dataframe
targetDF$volt = as.numeric(targetDF$Voltage)
## Convert the reactive power column to numeric and add it to the dataframe
targetDF$rpwr = as.numeric(targetDF$Global_reactive_power)
## Create a working dataframe from the needed columns, just for speed and tidyness
wrkDF <- data.frame(ts=targetDF$ts, 
                    apwr=targetDF$apwr, 
                    sub1=targetDF$sub1,
                    sub2=targetDF$sub2,
                    sub3=targetDF$sub3,
                    volt=targetDF$volt,
                    rpwr=targetDF$rpwr,
                    stringsAsFactors = FALSE)

## Create the subplots for plot 4 and save it to a png file using default 480x480
png("plot4.png")
par(mfrow= c(2,2))

## upper left
plot(wrkDF$ts, # use the tmestamp column of the working dataframe as the x axis
     wrkDF$apwr, # use the power column of the working dataframe as the y axis
     type="n", # draw graph without plotting points
     ylab="Global Active Power", # create y axis label
     xlab="") # remove x axis label
lines(wrkDF$ts, wrkDF$apwr, type="l") # now draw the x and y points

## upper right
plot(x=wrkDF$ts, # use the tmestamp column of the working dataframe as the x axis
     y=wrkDF$volt, # use the voltage column of the working dataframe as the y axis
     type="n", # draw graph without plotting points
     ylab="Voltage",  # create y axis label
     xlab="datetime")  # create x axis label
lines(wrkDF$ts, wrkDF$volt, type="l") # now draw the x and y points

## lower left
## Determine the maximum value of the 3 sub-metering columns
ymax = max(c(max(wrkDF$sub1), max(wrkDF$sub2), max(wrkDF$sub3)))
#ymax = round(ymax,digits=-1)
plot(wrkDF$ts, # use the tmestamp column of the working dataframe as the x axis
     wrkDF$sub1, # use sub-metering 1 to hold the y axis
     type="n", # draw graph without plotting points
     ylab="Energy sub metering", # create y axis label
     xlab="", # remove x axis label
     ylim=c(0,ymax)) # set the y range to the maximum value
lines(wrkDF$ts, wrkDF$sub1, type="l", col="black") # plot sub-metering 1
lines(wrkDF$ts, wrkDF$sub2, type="l", col="red") # plot sub-metering 2
lines(wrkDF$ts, wrkDF$sub3, type="l", col="blue") # plot sub-metering 3
legend("topright", # create legend in top right corner
       cex=0.9, # reduce legend size for smaller graph
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), # make legend labels
       lty=c(1,1,1), # set the lines for the legend
       col=c("black", "red", "blue"), # set the legend line colors
       bty="n") # remove the border from the legend

## lower right
plot(x=wrkDF$ts, # use the tmestamp column of the working dataframe as the x axis
     y=wrkDF$rpwr, # use the  reactive power column of the working dataframe as the y axis
     type='n', # draw graph without plotting points
     ylab='Global_reactive_power', # create y axis label
     xlab='datetime') # create x axis label
lines(wrkDF$ts, wrkDF$rpwr, type='l') # now draw the x and y points

dev.off()
