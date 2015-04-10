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

# Plot histogram of Global_active_power and save is as plot2.png.
png(filename='plot2.png', width=504, height=504)
plot(data$Global_active_power ~ data$datetime, type='l', xlab=NA, ylab='Global Active Power (kilowatts)')
dev.off()