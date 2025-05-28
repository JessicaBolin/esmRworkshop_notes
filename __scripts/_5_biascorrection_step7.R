# Step 5 - Interpolating ESM anomalies to the OISST grid
# Jessica Bolin, adapted from Dave Schoeman code
# UC Davis/BML ESM R workshop 2025 
# Author/s: Jessica Bolin
# Created: December 2024
# Updated: March 2025
# macOS: OK
# Windows: TBD

# Bilinear interpolation to remap the coarse CMIP data to the spatial extent and 
# resolution of OISST, filling missing cells with nearest neighbour.
# This is  processor intensive

# This creates four files in /esm, with the suffix _remapped.
# Files are SSP anomalies, that have been remapped and interpolated with OISST


# 5.7 Interpolate ESM anomalies to OISST grid -----------------------------


# Dependencies ---------------------------------------------------

source(paste0(getwd(), "/__scripts/helpers.R"))
input_folder <- paste0(pth, bc_pth, "/", bc_pth_anom)
output_folder <- paste0(pth, bc_pth, "/", bc_pth_anom_rm)
msk <- paste0(pth, bc_pth, "/_3_OISST_mask.nc")

# Function to do the regridding -------------------------------------------

do_regrid <- function(f) {
  
  output_file <- basename(f) %>% # Get the input file name
    gsub(".nc", "_remapped.nc", .) %>% # Add "_remapped" to the end of the file name
    paste0(output_folder, "/", .) 
  
  # Step 1 - set grid via nco
  cdo_code <- paste0('ncatted -O -a units,longitude,c,c,"degrees_east" -a units,latitude,c,c,"degrees_north" ',
                     f, " ", paste0(output_folder, "/tmp1.nc"))
  system(cdo_code)
  
  rr <- rast(paste0(output_folder, "/tmp1.nc"))
#  system(paste0("cdo griddes ", output_folder, "/tmp1.nc")) #projection grid
  
  vary <- varnames(rr)
  
  # Step 2 - remove lat/lon attributes
  cdo_code2 <-  paste0('ncatted -O -a grid_mapping,', vary, ',d,, ', 
                       paste0(output_folder, "/tmp1.nc"), ' ', 
                       paste0(output_folder, "/tmp2.nc"))
  system(cdo_code2)
 # system(paste0("cdo griddes ", output_folder, "/tmp2.nc")) #lonlat grid
 # system(paste0("cdo griddes ", msk)) #lonlat grid
  
  
  # Step 3 - remap cmip anomaly file scale mask using bilinear interp, and set missing vals nearest neighbour
  cdo_code3 <- paste0("cdo -s -L -f nc4 -z zip ", # Zip the file up
                      # "-mul ", msk, # Multiply the result of the lines, below by the mask to make land NA again
                      "-setmisstonn ", # Set missing values to the nearest neighbour value
                      "-remapbil,", msk, " ", 
                      paste0(output_folder, "/tmp2.nc"), " ", 
                      paste0(output_folder, "/tmp3.nc")) 
  system(cdo_code3)
  
  # Step 4 - remove mask
  cdo_code <- paste0("cdo -s -L -f nc4 -z zip ", # Zip the file up
                     "-mul ", msk, " ", # Multiply the result of the lines, below by the mask to make land NA
                     paste0(output_folder, "/tmp3.nc"), 
                     " ", output_file) # Mask the remapped the anomaly file and save as output_file
  system(cdo_code)
  
  # Step 5 -remove temporary files 
  system(paste0("rm ", output_folder, "/tmp1.nc", " ", 
                output_folder, "/tmp2.nc ", 
                output_folder, "/tmp3.nc"))
  
}


# Run function ------------------------------------------------------------

files <- list.files(input_folder, pattern = "anom", full.names = TRUE) # The files we want to process
 plan(multisession, workers = 14) # Setting up to run in parallel
 tic(); furrr::future_walk(files, do_regrid); toc() #Jessie: 5.7 seconds
 plan(sequential) # Go back to sequential processing

# For loop version - takes longer!
 # for (f in files) { 
 #   do_regrid(f)
 #   print(f)
 # }
 
 # Check
 par(mfrow=c(1,2))
 rast(paste0(pth, bc_pth, bc_pth_anom, "/tos_mo_ACCESS-CM2_2015-2100_anom_ssp245.nc"))[[1]] %>% 
   plot(main = "ESM anomalies (proj - hist)")
 maps::map("world", add =T)
 rast(paste0(pth, bc_pth, bc_pth_anom_rm, "/tos_mo_ACCESS-CM2_2015-2100_anom_ssp245_remapped.nc"))[[1]] %>% 
   plot(main = "Remapped anomalies (OISST mask)")
 maps::map("world", add =T)
 
 
 