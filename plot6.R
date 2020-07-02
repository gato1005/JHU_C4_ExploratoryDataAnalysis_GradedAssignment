# load the required library
library(plyr)
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

# subset the Baltimore City, Maryland 
Baltimore<-subset(NEI,fips == "24510")

# subset the Los Angeles County, California
LA<-subset(NEI,fips == "06037")

# store the SSC values for all the entries in SSC$EI.Sector dataFrame
# which have "Vehicle" in their string observations
motor <- SCC[grep("Vehicle", SCC$EI.Sector), "SCC"]

# subset the entries from NEI dataFrame which have their SCC values 
# equal to the values derived from the SCC DataFrame in the previous command
motor.Baltimore<-subset(Baltimore,SCC %in% motor)
motor.LA<-subset(LA,SCC %in% motor)

# make a new DataFrame to store the year-wise PM2.5 emission from 
# motor related sources
yearwise.motor.emission.Bltm <- ddply(motor.Baltimore, .(year),
                                 summarise,
                                 TotalEmissions = sum(Emissions))
yearwise.motor.emission.LA <- ddply(motor.LA, .(year),
                                 summarise,
                                 TotalEmissions = sum(Emissions))

# adding the county names
yearwise.motor.emission.LA$County<-"Los Angeles"
yearwise.motor.emission.Bltm$County<-"Baltimore"

# utility function
func <- function(){
  f <- function(x) as.character(round(x,2))
  f
}

# making a new dataframe
Data <- rbind(yearwise.motor.emission.Bltm, yearwise.motor.emission.LA)

# storing the change in emission over the years
Data["change"]<-c(Data$TotalEmissions[1]-Data$TotalEmissions[2],
                  Data$TotalEmissions[2]-Data$TotalEmissions[3],
                  Data$TotalEmissions[3]-Data$TotalEmissions[4],
                  NA,
                  Data$TotalEmissions[5]-Data$TotalEmissions[6],
                  Data$TotalEmissions[6]-Data$TotalEmissions[7],
                  Data$TotalEmissions[7]-Data$TotalEmissions[8],
                  NA)


# store as image(png format)
png(filename = "plot6.png",width = 480,height = 480)

# plot the result
ggplot(Data,aes(x=factor(year), y=change, fill=County)) + geom_bar(aes(fill = County), position = "dodge", stat="identity") + labs(x = "Year") + labs(y = expression("Change in Total Emissions (in log scale) of PM"[2.5])) + xlab("year") + ggtitle(expression("Change in Motor vehicle emission in Baltimore and Los Angeles")) + scale_y_continuous( labels = func())

# return to RStudio default window graphics device by closing the png
dev.off()




