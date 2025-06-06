# Bias correction
# UC Davis/BML ESM R workshop 2025 
# Author/s: Jessica Bolin
# Created: December 2024
# Updated: March 2025
# macOS: OK
# Windows: TBD

# Step 1 - calculate OISST climatology (i.e., mean of all OISST monthly files from 1994-2014) 

# Dependencies ------------------------------------------------------------

source(paste0(getwd(), "/__scripts/helpers.R"))


# 5.1 Step 3: OISST climatology -----------------------------------------------

input_file <-  paste0(pth, "/__data/oisst_processed/sst.mon.mean_remap.nc")
output_file <- paste0(pth, bc_pth, "/_2_OISST_climatology.nc")

# Calculate the mean in each grid cell (across all years in the time period)
cdo_code <- paste0("cdo timmean ", input_file, " ", output_file )
system(cdo_code)

# Check 
r <- terra::rast(output_file)
r #ignore 'time' field
plot(r, main = "OISST climatology 1995-2014") #smoothed over
maps::map("world", add = T)
system(paste0("cdo griddes ", output_file)) #Lonlat grid


