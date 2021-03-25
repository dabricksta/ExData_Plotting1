library(dplyr)
library(magrittr)
library(lubridate)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# # Date: Date in format dd/mm/yyyy
# # Time: time in format hh:mm:ss
# # Global_active_power: household global minute-averaged active power (in kilowatt)
# # Global_reactive_power: household global minute-averaged reactive power (in kilowatt)
# # Voltage: minute-averaged voltage (in volt)
# # Global_intensity: household global minute-averaged current intensity (in ampere)
# # Sub_metering_1: energy sub-metering No. 1 (in watt-hour of active energy). It corresponds to the kitchen, containing mainly a dishwasher, an oven and a microwave (hot plates are not electric but gas powered).
# # Sub_metering_2: energy sub-metering No. 2 (in watt-hour of active energy). It corresponds to the laundry room, containing a washing-machine, a tumble-drier, a refrigerator and a light.
# # Sub_metering_3: energy sub-metering No. 3 (in watt-hour of active energy). It corresponds to an electric water-heater and an air-conditioner.
# download.file(url = 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
#               , destfile = 'Electric_power_consumption.zip'
#               , method = 'curl')
# 
# # Unzip and load table
# dir.create("Electric_power_consumption")
zip <- unzip("Electric_power_consumption.zip", exdir = "Electric_power_consumption")
# Peek at data
readLines(zip[1], 2)

# Read in data from the dates 2007-02-01 and 2007-02-02
df <- read.csv(zip[1]
               , header = TRUE
               , sep = ";"
               , stringsAsFactors = FALSE) %>%
  dplyr::filter(., (Date == '1/2/2007' | Date == '2/2/2007'))
df[3:9] %<>% sapply(., as.numeric)

names(df) %<>% tolower()
gsub('?', '', df, fixed = TRUE)

df$date %<>% as.Date('%d/%m/%Y')
# df$time %<>% strptime(format = '%H:%M:%S')
df$datetime <- as.POSIXct(as.character(paste(df$date, df$time)), format = '%Y-%m-%d %H:%M:%S')
# We're not going to use lubridate :/
# df$date %<>% lubridate::dmy()
df$time %<>% lubridate::hms()

png(filename = "plot3.png")
# Plot 3
plot(df$datetime
     , df$sub_metering_1
     , type = "l"
     , xlab = ''
     , ylab = 'Energy sub metering'
     , col = 'dark gray'
)
lines(df$datetime
      , df$sub_metering_2
      , type = "l"
      , xlab = ''
      , ylab = 'Energy sub metering'
      , col = 'red'
)
lines(df$datetime
      , df$sub_metering_3
      , type = "l"
      , xlab = ''
      , ylab = 'Energy sub metering'
      , col = 'blue'
)
legend('topright'
       , legend = c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3')
       , col = c('dark grey', 'red', 'blue')
       , lwd = 1
       , cex = .5
)
dev.off()