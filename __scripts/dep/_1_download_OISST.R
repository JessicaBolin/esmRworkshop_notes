# Download OISST 1993-2015 for ESM SST bias-correction
# Script to loop through OISST HTML pages and download the data 
# Written by Dave Schoeman (david.schoeman@gmail.com)
# Amended by Jessica Bolin 
# Link: https://www.ncei.noaa.gov/data/sea-surface-temperature-optimum-interpolation/v2.1/access/avhrr/ 

#Note - takes maybe an hour or two to download twenty years. Files are 1.7MB each. Resolution is 0.2.

# Dependencies ------------------------------------------------------------

library(RCurl)
library(xml2)
library(rvest)
library(tidyverse)
library(doMC)

# Set destination folder
oFold <- "/Users/admin/Desktop/oisst/"
#oFold <- "/Volumes/OWC_STX_HDD/Volumes/oisst/"

# Set base URL
url <- "https://www.ncei.noaa.gov/data/sea-surface-temperature-optimum-interpolation/v2.1/access/avhrr"

# Get the links that appear there as yyyymm dates
pg <- read_html(url) # Read the HTML
sFld <- html_attr(html_nodes(pg, "a"), "href") %>%  # Extract the links
  grep("\\d\\d\\d\\d\\d\\d", ., value = TRUE) # Just the folders with 6 digits (i.e., one per month)

# Check what files might already be in the folder
f <- dir(oFold, pattern = ".nc")
ncs <- gsub("oisst-avhrr-v02r01.", "", f) %>% # Exract identifiers from the file names - works at level of month
  gsub("\\d\\d\\.nc", "", .) %>% 
  unique() %>% 
  paste0(., "/")

# Exclude files (months) that are already downlaoded
sFld <- sFld[!sFld %in% ncs]

# i = "200001/"
# j = "oisst-avhrr-v02r01.20000101.nc"


download_oisst <- function(yrstrt, yrend) {
  
  # Subset sFld to only include time period of interest
  ind1 <- grep(yrstrt, sFld) %>% min 
  ind2 <- grep(yrend, sFld) %>% max
  sFld <- sFld[ind1:ind2] 
  length(sFld) #downloading 372 files for 30 yrs
  
  for(i in sFld) {
    urli <- paste0(url, "/", i)
    pgi <- read_html(urli) # Read the HTML
    sFldi <- html_attr(html_nodes(pgi, "a"), "href") %>%  # Extract the links
      grep(".nc", ., value = TRUE) # Just the netCDFs
    for(j in sFldi) {
      download.file(paste0(urli, j), paste0(oFold, j))
      #Sys.sleep(0.1)
    }
  }
}

library(tictoc)
tic(); download_oisst(yrstrt = 1994, yrend = 2014); toc()
