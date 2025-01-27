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
#         Plot 4            #
#############################

png(filename = "plot4.png", 
    width = 480, 
    height = 480)

par(mfcol = c(2,2))

# Top-left plot
plot(as.POSIXct(paste0(analysis_data$Date, " ", analysis_data$Time)), 
     as.numeric(analysis_data$Global_active_power),
     ylab = "Global Active Power (kilowatts)",
     xlab = "",
     type = "l")

# Bottom-left plot
plot(as.POSIXct(paste0(analysis_data$Date, " ", analysis_data$Time)), 
     as.numeric(analysis_data$Sub_metering_1),
     ylab = "Energy sub metering",
     type = "l",
     col = "black",
     xlab = "")

points(as.POSIXct(paste0(analysis_data$Date, " ", analysis_data$Time)), 
       as.numeric(analysis_data$Sub_metering_2),
       ylab = "Energy sub metering",
       type = "l",
       col = "red")

points(as.POSIXct(paste0(analysis_data$Date, " ", analysis_data$Time)), 
       as.numeric(analysis_data$Sub_metering_3),
       ylab = "Energy sub metering",
       type = "l",
       col = "blue")

legend("topright", 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"),
       lwd = 1)

# Top-right plot
plot(as.POSIXct(paste0(analysis_data$Date, " ", analysis_data$Time)),
     analysis_data$Voltage,
     type = "l",
     xlab = "datetime",
     ylab = "Voltage")

# Bottom-right plot
plot(as.POSIXct(paste0(analysis_data$Date, " ", analysis_data$Time)),
     analysis_data$Global_reactive_power,
     type = "l",
     xlab = "datetime",
     ylab = "Global_reactive_power")

dev.off()
