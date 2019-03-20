# Downloading files

dataURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if (!file.exists("./data")) {
        dir.create("./data")
}
if (!file.exists("./data/household_power_consumption.zip")) {
        download.file(dataURL, "./data/household_power_consumption.zip", mode = "wb")
}
if (!file.exists("./data/household_power_consumption.txt")) {
        unzip("./data/household_power_consumption.zip", exdir = "./data")
}


# Reading files

if(!("sqldf" %in% installed.packages())) {
        install.packages("sqldf")
}
library("sqldf")

myData <- read.csv.sql("./data/household_power_consumption.txt", 
                       sql = "SELECT * FROM file WHERE Date == '1/2/2007' OR Date == '2/2/2007' ", 
                       header = TRUE, sep = ";")

# Correcting datatypes:

myData$Date <- as.Date(myData$Date, "%e/%m/%Y")
myData$Time <- strptime(myData$Time, "%H:%M:%S")

# Plot 1 Code

hist(myData$Global_active_power,
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)",
     col = "red")

# Saving to .png with 480 pixels with and heigh

dev.copy(png, "plot1.png", heigh = 480, width = 480)
dev.off()