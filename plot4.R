# load the required library
library(plyr)
library(ggplot2)

# Download the zip file from Coursera to your working directory 
download.file(url="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
              destfile = "2FNEI_data.zip")

# Unzip the file in the working directory
unzip("2FNEI_data.zip",
      exdir = ".")

# read the required files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# store the SSC values for all the entries in SSC$Short.Name dataFrame
# which have "Comb" and "Coal" in their string obesrvations
Coal <- SCC[grep("Comb.*Coal", SCC$Short.Name), "SCC"]

# subset the entries from NEI dataFrame which have their SCC values 
# equal to the values derived from the SCC DataFrame in the previous command
Coal.NEI<-subset(NEI,SCC %in% Coal)

# make a new DataFrame to store the year-wise PM2.5 emission from 
# coal combustion-related sources
yearwise.coal.emission <- ddply(Coal.NEI, .(year), summarise, TotalEmissions = sum(Emissions))

# store as image(png format)
png(filename = "plot4.png",width = 480,height = 480)

# plot the result
plot(yearwise.coal.emission$year,
     yearwise.coal.emission$TotalEmissions,
     ylim = c(320000,600000),
     type = "b",
     main = " Total Emission from coal combustion sources in 1999-2008",
     xlab = "Year",ylab = expression('Total Emission of PM'[2.5]*"(in tons)"),
     pch=19,lwd=2)

# return to RStudio default window graphics device by closing the png
dev.off()
