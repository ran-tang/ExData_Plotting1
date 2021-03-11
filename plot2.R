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


#creating plot 2 and saving it
plot(power$Global_active_power~power$dt, type="l", ylab="Global Active Power (kilowatts)", xlab="")
dev.copy(png,"plot2.png", width=480, height=480)
dev.off()
