# download, save and unzip file
filename <- "exdata_data_household_power_consumption.zip"

if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileURL, filename, method="curl")
}  

if (!file.exists("household_power_consumption")) { 
  unzip(filename) 
}

# table with Na value = ?, sep = ;
consumption <- read.table("household_power_consumption.txt", header=TRUE, sep=";", na.strings = "?", colClasses = c('character','character','numeric','numeric','numeric','numeric','numeric','numeric','numeric'))

# Date: Date in format dd/mm/yyyy
consumption$Date <- as.Date(consumption$Date, "%d/%m/%Y")

# data from the dates 2007-02-01 and 2007-02-02
consumption <- subset(consumption,Date >= as.Date("2007-2-1") & Date <= as.Date("2007-2-2"))

# only complete cases
consumption <- consumption[complete.cases(consumption),]

# time combining 
dateTime <- paste(consumption$Date, consumption$Time)

# creating vector date with time
dateTime2 <- setNames(dateTime, "DateTime")

# time standardization
consumption <- consumption[ ,!(names(consumption) %in% c("Date","Time"))]
consumption <- cbind(dateTime2, consumption)
consumption$dateTime2 <- as.POSIXct(dateTime2)

## plot 3
with(consumption, {
  plot(Sub_metering_1~dateTime2, type="l", ylab="Energy sub metering", xlab="")
  lines(Sub_metering_2~dateTime2,col='Red')
  lines(Sub_metering_3~dateTime2,col='Blue')
})
legend("topright", col=c("black", "red", "blue"), lwd=c(1,1,1), c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# saving as PNG
dev.copy(png, file="plot3.png", height=480, width=480)
dev.off()
