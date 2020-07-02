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

# return a dataframe categorised by type of source and aggregrated on the 
# total emissions in year
type.emission<-ddply(Baltimore,
                     .(type, year),
                     summarize,
                     TotalEmissions = sum(Emissions))

# store as image(png format)
png(filename = "plot3.png",width = 600,height = 480)

# plot the result
g<-ggplot(type.emission,
          aes(year,
              TotalEmissions,
              colour = type)) 

g+geom_line(linetype=2, size=1) +ylim(0,2500)+theme_classic()+geom_point(size=3) + labs(title = expression('Total PM'[2.5]*" Emissions in Baltimore City, Maryland from 1999 to 2008"),
                                                               x = "Year",
                                                               y = expression('Total PM'[2.5]*" Emission (in tons)"))


# return to RStudio default window graphics device by closing the png
dev.off()
