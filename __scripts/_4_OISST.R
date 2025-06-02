# Download OISST 1995-2015 for ESM SST bias-correction
# UC Davis/BML ESM R workshop 2025 
# Author/s: Jessica Bolin
# Created: December 2024
# Updated: March 2025
# macOS: OK
# Windows: TBD

# Script to loop through OISST HTML pages and download the data 
# Note - takes ~2 hours to download twenty years' worth. 
# Files are 1.7MB each. Resolution is 0.2˚.


# 4.1 Download OISST ------------------------------------------------------


# Dependencies ------------------------------------------------------------

source(paste0(getwd(), "/__scripts/helpers.R"))
#oFold <- paste0(pth, oisst_pth, "/") # Set destination folder where raw OISST will be stored
oFold <- "/Users/admin/Desktop/test/oisstraw/"
url <- "https://www.ncei.noaa.gov/data/sea-surface-temperature-optimum-interpolation/v2.1/access/avhrr" # Set base URL

# Scrape file names from HTML ---------------------------------------------

# Get the links that appear there as yyyymm dates
pg <- read_html(url) # Read the HTML (takes a while)
pg
sFld <- html_attr(html_nodes(pg, "a"), "href") %>%  # Extract the links
  grep("\\d\\d\\d\\d\\d\\d", ., value = TRUE) # Just the folders with 6 digits (i.e., one per month)
sFld

# Check what files might already be in the output folder
f <- dir(oFold, pattern = ".nc")
f

# Extract identifiers from the file names - works at level of month
ncs <- gsub("oisst-avhrr-v02r01.", "", f) %>%
  gsub("\\d\\d\\.nc", "", .) %>% 
  unique() %>% 
  paste0(., "/")
ncs

# Exclude files (months) that are already downlaoded
sFld <- sFld[!sFld %in% ncs]
sFld

# Function to download OISST ----------------------------------------------

#yrstrt = 1995
#yrend = 1996
#i = sFld[1]

download_oisst <- function(yrstrt, yrend) {
  
  # Subset sFld to only include time period of interest
  ind1 <- grep(yrstrt, sFld) %>% min #index of first year in html parsed vector
  ind2 <- grep(yrend, sFld) %>% max
  sFld <- sFld[ind1:ind2] 
  length(sFld) #number of months  
  
  for(i in sFld) { #for each year-month combo, read in the links
    urli <- paste0(url, "/", i)
    pgi <- read_html(urli) # Read the HTML, can take a while
    sFldi <- html_attr(html_nodes(pgi, "a"), "href") %>%  # Extract the links
      grep(".nc", ., value = TRUE) # Just the netCDFs
    for(j in sFldi) { #download each daily netCDF
      download.file(paste0(urli, j), paste0(oFold, j))
    }
  }
}

#tic(); download_oisst(yrstrt = 1995, yrend = 2014); toc()
tic(); download_oisst(yrstrt = 1995, yrend = 1996); toc()

# 4.2 Preprocess OISST (i.e., remap) ------------------------------------------------



oisst_mr <- function(yr,
                     infile = paste0(pth, oisst_pth),
                     outfile = paste0(pth, oisst_pth_proc),
                     xmin = -126, xmax = -115, ymin = 32, ymax = 43,
                     cell_res = 0.25) {
  
  
  # Combine all daily files for X year into one file
  merged_1yr <- paste0("cdo -mergetime ", 
                       infile, "/", "oisst-avhrr-v02r01.", yr, "*.nc ", 
                       outfile, "/", "oisst-avhrr-merged_", yr, ".nc")
  system(merged_1yr) # takes a few seconds
  
  
  # Calculate monthly means for X year
  mthmeans <- paste0("cdo -L monmean ", 
                     outfile, "/oisst-avhrr-merged_", yr, ".nc ",
                     outfile, "/mean_", yr, ".nc")
  system(mthmeans)
  
  # Select SST, crop and remap 
  oisst_regrid <- paste0("cdo -L -select,name=,sst ", 
                         "-sellonlatbox,", xmin, ",", xmax, ",", ymin, ",", ymax,  
                         " -remapbil,r", 360*(1/cell_res), "x", 180*(1/cell_res), 
                         " ", outfile, "/mean_", yr, ".nc", 
                         " ", outfile, "/mean_remap_", yr, ".nc")
  system(oisst_regrid)
  
  # Remove temporary files 
  system(paste0("rm ", outfile, "/", "oisst-avhrr-merged_", yr, ".nc"))
  system(paste0("rm ", outfile, "/mean_", yr, ".nc"))
  
}

# Run function ------------------------------------------------------------

# Vector of years to process
years <- 1995:2014  # Modify as needed

plan(multisession, workers = 14)  # Change workers to suit your machine
tic(); future_map(years, ~ oisst_mr(.x)); toc()
plan(sequential) # Return to sequential processing
# Takes ~1 minute for Jessie! Nice. 

# Or, for loop version
# for (i in years) {
#   oisst_mr(i)
# }

list.files(paste0(pth, oisst_pth_proc))

# 4.3 Visualise ---------------------------------------------------------------

oisst <- terra::rast(paste0(pth, oisst_pth_proc, 
                            "/mean_remap_1995.nc"))[[1]]
esm <- terra::rast(paste0(pth, cmip_pth_proc, 
                          "/tos_Omon_ACCESS-CM2_historical_r1i1p1f1_gn_185001-201412.nc"))[[1]]
terra::plot(oisst, main = "OISST Jan 1995")
maps::map("state", add = T)
terra::plot(esm, main = "ESM Jan 1850")
maps::map("state", add = T)
