library(dplyr, lubridate, reshape2)
# The file is really large, so we want to skip all the data to 2007-02-01, then read 48hrs worth of rows.
# These numbers were calculated using tedios trial and error!
start <- 66636
n <- 2880
columnNames = c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
columnTypes = c("character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric")

data <- read.table("./household_power_consumption.txt",
                      skip = start+1,
                      header=FALSE,
                      nrows = n,
                      sep=";",
                      colClasses = columnTypes,
                      col.names = columnNames,
                      stringsAsFactors=FALSE,
                      na.strings = "?")

data <- data %>% mutate(datetime = as.POSIXct(paste(Date, Time), format="%d/%m/%Y %H:%M:%S"))

#plot1
with(data, {
  png(filename="plot1.png", width=480, height=480)
  hist(Global_active_power, col="red", main=c("Global Active Power"), xlab = "Global Active Power (kilowatts)")
  dev.off()
})
