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

with(data, {
  png(filename="plot4.png", width=480, height=480)
  par(mfrow = c(2,2), mar = c(4, 4, 2, 1), oma = c(0, 0, 0, 0))

  # plot2 in the top-left.
  plot(datetime, Global_active_power, type="n", ylab = "Global Active Power (kilowatts)", xlab="")
  lines(datetime, Global_active_power)

  # voltage in top-right
  plot(datetime, Voltage, type="n")
  dv <- dev.cur()
  lines(datetime, Voltage)

  # plot3 in the bottom-left, but legend has no border box
  plot(datetime, Sub_metering_1, type="n", ylab = "Energy sub-metering")
  lines(datetime, Sub_metering_1)
  lines(datetime, Sub_metering_2, col="red")
  lines(datetime, Sub_metering_3, col="blue")
  legend("topright",
         col = c("black", "blue", "red"),
         text.col = c("black", "blue", "red"),
         lwd=1,
         bty="n",
         legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

  # reactive power in the bottom-right
  plot(datetime, Global_reactive_power, type="n")
  lines(datetime, Global_reactive_power)

  dev.off()
})
