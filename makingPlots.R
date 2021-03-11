library(dplyr)
library(lubridate)

#initiate download from url and check for file existence

fname <- "Electric_power_consumption.zip"
furl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

if (!file.exists(fname)){
  download.file(furl, fname, method="curl")
}

if (!file.exists("Electric_power_consumption")) { 
  unzip(fname) 
}

#store data into table within R
power <- read.table("household_power_consumption.txt", header = TRUE , sep = ";", na.strings = "?", 
                               colClasses = c('character','character','numeric','numeric','numeric','numeric','numeric','numeric','numeric'))

#date/time conversion using lubridate
power$Date <- dmy(power$Date)
power$Time <- hms(power$Time)
power$dt <- power$Date + power$Time


#trim to the relevant data (from the 2 days we want)
t1 <- ymd("2007-02-01")
t2 <- ymd("2007-02-02")
power <- subset(power, power$Date >= t1 & power$Date <= t2)

dev.off()


#creating plot 1 and saving it
hist(power$Global_active_power, main="Global Active Power", xlab = "Global Active Power (kilowatts)", col="red")
dev.copy(png,"plot1.png", width=480, height=480)
dev.off()


#creating plot 2 and saving it
plot(power$Global_active_power~power$dt, type="l", ylab="Global Active Power (kilowatts)", xlab="")
dev.copy(png,"plot2.png", width=480, height=480)
dev.off()

#creating plot 3 and saving it
with(power, {
  plot(Sub_metering_1~dt, type="l", ylab="Global Active Power (kilowatts)", xlab="")
  lines(Sub_metering_2~dt,col='Red')
  lines(Sub_metering_3~dt,col='Blue')
})
legend("topright", col=c("black", "red", "blue"), lwd=c(1,1,1), c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.copy(png,"plot3.png", width=480, height=480)
dev.off()

#creating plot 4 and saving it
par(mfrow=c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0)) #set up 2x2 grid
with(power, {
  plot(Global_active_power~dt, type="l", #plot1
       ylab="Global Active Power (kilowatts)", xlab="")
  plot(Voltage~dt, type="l", #plot2
       ylab="Voltage (volt)", xlab="")
  plot(Sub_metering_1~dt, type="l", #plot3
       ylab="Global Active Power (kilowatts)", xlab="")
  lines(Sub_metering_2~dt,col='Red')
  lines(Sub_metering_3~dt,col='Blue')
  legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty = "n")
  plot(Global_reactive_power~dt, type="l", #plot4 
       ylab="Global Rective Power (kilowatts)",xlab="")
})
dev.copy(png,"plot4.png", width=480, height=480)
dev.off()
