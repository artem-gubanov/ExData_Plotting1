### Exploratory data analysis course (Coursera)
### Assignment 1
### R code file 3: plot3.R
### Created by Artem on March 9, 2017

### The code reads the energy usage dataover a 2-day period in February, 2007,
### constructs the plot, and saves 480 pixels by 480 pixels PNG file
### Plot/file name: plot1.png

### Original data can be downloaded and unpacked using following commands (working directory):
## download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile = "household_power_consumption.zip")
## unzip(zipfile = "household_power_consumption.zip")



## clean all objects from workspace
rm(list=ls())

## read data
data_filename = "household_power_consumption.txt"
# dataset has 2,075,259 rows and 9 columns
# electric power consumption, one-minute sampling rate, over a period of almost 4 years
# contains 2075259 measurements gathered between December 2006 and November 2010 (47 months)
# all calendar timestamps are present in the dataset
# for some timestamps, the measurement values are missing
# original sourse: missing value is absence of value between two consecutive semi-colon separators
# course: missing values are coded as ?
# column 1 is "Date" in format dd/mm/yyyy), removing head trailing zeros
# for example, 2007-02-01 is presented as 1/2/2007
# read top head line with names
header <- read.table(data_filename,
                     header = FALSE, sep = ";", skip = 0, nrows = 1, stringsAsFactors = FALSE)
# reading data from 2 days on dates 2007-02-01 and 2007-02-02
# define line number where "1/2/2007" is used first time (shift it by 1 to get nubmer of lines to skip)
start_line <- head(grep("^1/2/2007", readLines(data_filename)), 1) - 1
# define line number where "2/2/2007" is used last time
end_line <- tail(grep("^2/2/2007", readLines(data_filename)), 1)
# read only required data subset (missing values are coded as ?)
data_subset <- read.table(data_filename, header = FALSE, sep = ";",
                          stringsAsFactors = FALSE, na.strings = c("?", "", " "),
                          skip = start_line, nrows = end_line - start_line)
# set proper names to data subset
colnames(data_subset) <- unlist(header)


## process data
# clean up data: keep complete data rows, ignore data rows with NA
complete_rows <- complete.cases(data_subset)
if(any(!complete_rows)) {
  warning(paste("Rows", paste(which(!complete_rows), collapse = " "), "have NA values and ignored"))
  data_subset <- data_subset[complete_rows,]
} else {
  message("Data subset is complete, no NA values")
}
# concatenate Date and Time into one variable (example, 1/2/2007 23:42:00)
DateTime_str <- paste(data_subset$Date, data_subset$Time)
# convert string Date-Time into calendar date-time object and keep it as additional column to data subset
data_subset$DateTime <- strptime(DateTime_str, format = "%d/%m/%Y %H:%M:%S")


## plot data, set appropriate labels, save it as png file
# use png device
png(filename = "plot3.png", width = 480, height = 480, units = "px", bg = "transparent")
# define parameters
cols = c("black", "red", "blue")
ltypes = c(1, 1, 1)
nlabs <- names(data_subset)[7:9]
# plot data one by one
# plot empty frame with proper labels and ranges (ranges are taken from Sub_metering_1)
plot(data_subset$DateTime, data_subset$Sub_metering_1,
     type = 'n', xlab = '', ylab = "Energy sub metering")
lines(data_subset$DateTime, data_subset$Sub_metering_1, lty = ltypes[1], col = cols[1])
lines(data_subset$DateTime, data_subset$Sub_metering_2, lty = ltypes[2], col = cols[2])
lines(data_subset$DateTime, data_subset$Sub_metering_3, lty = ltypes[3], col = cols[3])
# add legend
legend("topright", legend = nlabs, col = cols, lty = ltypes)
# close png device
dev.off()

