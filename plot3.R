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


# Plot 3 Code

with(myData, plot(Time, Sub_metering_1,
                  type = "n",
                  xlab = "",
                  ylab = "Energy sub metering"))
with(myData, points(Time, Sub_metering_1,
                  type = "l",
                  col = "black"))
with(myData, points(Time, Sub_metering_2,
                  type = "l",
                  col ="red"))
with(myData, points(Time, Sub_metering_3,
                  type = "l",
                  col = "blue"))
legend("topright", lwd = 1, legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"))

# Saving to .png with 480 pixels with and heigh

dev.copy(png, "plot3.png", heigh = 480, width = 480)
dev.off()

# Returning locale to default

Sys.setlocale("LC_TIME", original_locale)