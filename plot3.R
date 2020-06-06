## Load the 'lubridate' package
library(lubridate)

## Check and download the data if not yet downloaded
if(!file.exists("./data")) {dir.create("data")}                         # Check to see if the directory exists
if(!file.exists("./data/household_power_consumption.zip")) {
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(url, destfile = "./data/household_power_consumption.zip")
}

## Unzip the dataset and store in 'data' directory
if(!file.exists("./data/household_power_consumption.txt")) {
  unzip(zipfile = "./data/household_power_consumption.zip", exdir = "./data")
}

## Read the household data for the dates- 2007-02-01 and 2007-02-02
conn <- file("./data/household_power_consumption.txt", open = "r")
col_names <- readLines(conn, 1)                                         # Extract the column names
lines <- c()
while(TRUE) {
  line = readLines(conn, 1)
  if(length(line) == 0) {break}
  else if(grepl("^1\\/2\\/2007", line) || grepl("^2\\/2\\/2007", line)) {lines <- c(lines, line)}
}
close(conn)                                                             # Remember to close the file

## Convert the data into a dataframe
household_data <- read.table(text = lines, header = FALSE, sep = ";", na.strings = "?", stringsAsFactors = FALSE)
colnames(household_data) <- strsplit(col_names, ";")[[1]]

## Format the Date and Time values
household_data$Date <- dmy(household_data$Date)
tm <- paste(as.character(household_data$Date), household_data$Time)     # Add the Date to the Time column
household_data$Time <- strptime(tm, "%Y-%m-%d %H:%M:%S")

## Create the 'plot3.png'
png(file = "plot3.png", width = 480, height = 480, units = "px")        # Open the PNG device
x <- household_data$Time
y1 <- household_data$Sub_metering_1
y2 <- household_data$Sub_metering_2
y3 <- household_data$Sub_metering_3
plot(x, y1, xlab = "", ylab = "Energy sub metering", type = "n")
lines(x, y1, col = "black")
lines(x, y2, col = "red")
lines(x, y3, col = "blue")
legend("topright", lty = 1, col = c("black", "red", "blue"),            # Add the legend
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

dev.off()                                                               # Close the PNG device

## END