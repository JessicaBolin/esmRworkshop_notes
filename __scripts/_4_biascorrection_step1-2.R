# Bias correction
# UC Davis/BML ESM R workshop 2025 
# Created: Dec 2024

# Step 1 - merge all OISST files used to define climatology (1994-2014) into one file
# Step 2 - calculate OISST climatology (i.e., mean of all OISST monthly files from 1994-2014) 

# Dependencies ------------------------------------------------------------

#pth <- "/Users/admin/Documents/GitHub/BMLworkshop"
source(paste0(getwd(), "/__scripts/helpers.R"))

# Step 1: Merge all days  ----------------------------------------------------------------

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
r <- terra::rast(paste0(pth, bc_pth, "/_1_OISST_baseline_combined.nc"))
r
terra::plot(r[[1]])
system(paste0("cdo griddes ", pth, bc_pth, "/_1_OISST_baseline_combined.nc")) #Lonlat grid


# Step 2: OISST climatology -----------------------------------------------

input_file <- paste0(pth, bc_pth, "/_1_OISST_baseline_combined.nc")
output_file <- paste0(pth, bc_pth, "/_2_OISST_climatology.nc")

# Calculate the mean in each grid cell (across all years in the time period)
cdo_code <- paste0("cdo timmean ", input_file, " ", output_file )
system(cdo_code)

# Check 
r <- terra::rast(output_file)
r #ignore 'time' field
plot(r, main = "OISST climatology 1994-2014") #smoothed over
maps::map("world", add = T)
system(paste0("cdo griddes ", output_file)) #Lonlat grid


