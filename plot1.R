# Load necessary packages
library(graphics)
library(grDevices)

#############################################
#          Import and clean data            #
#############################################

# Read in data.
temp <- tempfile()
download.file("http://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip", temp)
con <- unz(temp, "household_power_consumption.txt")
data <- read.table(con, sep = ";", header = T, colClasses = "character")
close.connection(con)
rm(con, temp)

# Create temporary DF for data cleaning.
temp <- data

# Format date and time
temp$Date <- as.Date(temp$Date, format = "%d/%m/%Y")
temp$Time <- format(strptime(temp$Time, format = "%H:%M:%S"), "%H:%M:%S")

# Remove "?" values
temp$Global_active_power[temp$Global_active_power == "?"] <- NA
temp$Global_reactive_power[temp$Global_reactive_power == "?"] <- NA
temp$Voltage[temp$Voltage == "?"] <- NA
temp$Global_intensity[temp$Global_intensity == "?"] <- NA
temp$Sub_metering_1[temp$Sub_metering_1 == "?"] <- NA
temp$Sub_metering_2[temp$Sub_metering_2 == "?"] <- NA
temp$Sub_metering_3[temp$Sub_metering_3 == "?"] <- NA

# Create subset of clean data for use in analysis.
analysis_data <- subset(temp, Date >= "2007-02-01" & Date <= "2007-02-02")

#############################
#         Plot 1            #
#############################

png(filename = "plot1.png", 
    width = 480, 
    height = 480)

hist(as.numeric(analysis_data$Global_active_power), 
     col = "red",
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)")

dev.off()
