#!/usr/bin/Rscript

# Read in data (Warning: still pretty slow. Unfortunately data.table's `fread()`
# is currently failing to parse correctly with `na.strings` set, so read.table 
# is still simplest for now.)
data <- read.table('household_power_consumption.txt', header=TRUE, sep=';', 
                   na.strings='?', nrows=2075259)

# Chop dataset down to days we care about. Zippy from here on out.
data <- data[data$Date=='1/2/2007' | data$Date=='2/2/2007',]

# Turn Date column into POSIXlt date.
data$Date <- as.Date(data$Date, format='%d/%m/%Y')

# Construct combined date and time column.
datetime <- strptime(paste(data$Date, data$Time), format='%F %T')
data <- cbind(data, datetime)

# Plot histogram of Global_active_power and save is as plot4.png.
png(filename='plot4.png', width=504, height=504)
par(mfrow = c(2,2))
# Plot 1
plot(data$Global_active_power ~ data$datetime, type='l', xlab=NA, ylab='Global Active Power')
# Plot 2
with(data, plot(Voltage ~ datetime, type='l'))
# Plot 3
plot(data$Sub_metering_1 ~ data$datetime, xlab=NA, ylab='Energy sub metering',type='n')
lines(data$Sub_metering_1 ~ data$datetime)
lines(data$Sub_metering_2 ~ data$datetime, col='red')
lines(data$Sub_metering_3 ~ data$datetime, col='blue')
legend('topright', legend = names(data[,7:9]), lty = 1, 
       col = c('black', 'red', 'blue'), bty='n')
# Plot 4
with(data, plot(Global_reactive_power ~ datetime, type='l'))
dev.off()