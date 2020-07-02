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

# make a separate data frame to plot the required ans
# this dataframe has year-wise total PM2.5 pollution 
# of the years 1999, 2002, 2005 and 2008 in Baltimore City, Maryland
baltimore.yearwise<-data.frame(year=c(1999,2002,2005,2008))
baltimore.yearwise["emission"]<-c(tapply(Baltimore$Emissions,Baltimore$year,sum)[[1]],
                         tapply(Baltimore$Emissions,Baltimore$year,sum)[[2]],
                         tapply(Baltimore$Emissions,Baltimore$year,sum)[[3]],
                         tapply(Baltimore$Emissions,Baltimore$year,sum)[[4]])

# store as image(png format)
png(filename = "plot2.png",width = 480,height = 480)

# plot the result
plot(baltimore.yearwise$year,
     baltimore.yearwise$emission,
     type="b",
     xlab = "Year",
     ylab = expression('Total Emission of PM'[2.5]*  "(in tons)"),
     ylim = c(1800,3500),
     main = expression('Total PM'[2.5]*" Emissions in Baltimore City, Maryland from 1999 to 2008"),
     lwd=3)

# return to RStudio default window graphics device by closing the png
dev.off()
