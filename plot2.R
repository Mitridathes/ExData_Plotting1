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

# Correcting datatypes. Joining Date and Time is important to get this kind of graphic.
# Changing locale to get english language dates:

original_locale <- Sys.getlocale("LC_TIME")
Sys.setlocale("LC_TIME", "English")
Time <- paste(myData$Date, myData$Time)
myData <- myData[, -1]
myData$Time <- Time
myData$Time <- strptime(myData$Time, "%e/%m/%Y %H:%M:%S")


# Plot 2 Code

with(myData, plot(Time, Global_active_power,
                  type = "l",
                  xlab = "",
                  ylab = "Global Active Power (kilowatts))"))

# Saving to .png with 480 pixels with and heigh

dev.copy(png, "plot2.png", heigh = 480, width = 480)
dev.off()

# Returning locale to default

Sys.setlocale("LC_TIME", original_locale)