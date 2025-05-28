# Bias correction
# UC Davis/BML ESM R workshop 2025 
# Author/s: Jessica Bolin
# Created: December 2024
# Updated: March 2025
# macOS: OK
# Windows: TBD

# Step 1 - merge all OISST files used to define climatology (1994-2014) into one file
# Step 2 - calculate OISST climatology (i.e., mean of all OISST monthly files from 1994-2014) 

# Dependencies ------------------------------------------------------------

source(paste0(getwd(), "/__scripts/helpers.R"))

# 5.1 Step 1: Merge daily OISST files ------------------------------------------

# List all processed OISST files
day_ncs <- dir(paste0(pth, oisst_pth_proc), full.names = TRUE) %>% 
  paste0(., collapse = " ") 

cdo_code <- paste0("cdo -s -L -f nc4 -z zip ",
                   "-mergetime ", # Merge CDO function
                   day_ncs, # The names of the input files
                   " ", 
                   paste0(pth, bc_pth, "/_1_OISST_baseline_combined.nc"))

tic(); system(cdo_code); toc() #0.186 seconds

# Check it worked
rr <- terra::rast(paste0(pth, bc_pth, "/_1_OISST_baseline_combined.nc"))
rr
terra::plot(rr[[1]])
system(paste0("cdo griddes ", pth, bc_pth, "/_1_OISST_baseline_combined.nc")) #Lonlat grid


# 5.3 Step 3: OISST climatology -----------------------------------------------

input_file <- paste0(pth, bc_pth, "/_1_OISST_baseline_combined.nc")
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


