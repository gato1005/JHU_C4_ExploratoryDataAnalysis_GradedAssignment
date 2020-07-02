# load the required library
library(dplyr)
library(ggplot2)

# Download the zip file from Coursera to your working directory 
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
              destfile = "2FNEI_data.zip")

# Unzip the file in the working directory
unzip("2FNEI_data.zip",
      exdir = ".")

# read the required files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# subset the Baltimore, Maryland 
Baltimore<-subset(NEI,fips == "24510")

# store the SSC values for all the entries in SSC$EI.Sector dataFrame
# which have "Vehicle" in their string observations
motor <- SCC[grep("Vehicle", SCC$EI.Sector), "SCC"]

# subset the entries from NEI dataFrame which have their SCC values 
# equal to the values derived from the SCC DataFrame in the previous command
motor.NEI<-subset(NEI,SCC %in% motor)

# make a new DataFrame to store the year-wise PM2.5 emission from 
# motor related sources
yearwise.motor.emission <- ddply(motor.NEI, .(year),
                                 summarise,
                                 TotalEmissions = sum(Emissions))


# store as image(png format)
png(filename = "plot5.png",width = 480,height = 480)

# plot the result
plot(yearwise.motor.emission$year,
     yearwise.motor.emission$TotalEmissions,
     ylim = c(100000,200000),
     type = "b",
     main = " Total Emission from motor sources in 1999-2008",
     xlab = "Year",ylab = expression('Total Emission of PM'[2.5]*"(in tons)"),
     pch=19,lwd=2)

# return to RStudio default window graphics device by closing the png
dev.off()
