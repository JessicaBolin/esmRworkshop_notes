# Step 6: Adding the OISST climatology for the base period (1994-2014) to the 
# remapped CMIP anomalies (SSPs 2015-2100)
# i.e., bias correction
# UC Davis/BML ESM R workshop 2025 
# Created: Dec 2024

# Dependencies ------------------------------------------------------------

#pth <- "/Users/admin/Documents/GitHub/BMLworkshop"
source(paste0(getwd(), "/__scripts/helpers.R"))
input_folder <- paste0(pth, bc_esm_pth, "/__data/bias_correct/esm")
obs <- paste0(pth, bc_pth, "/_2_OISST_climatology.nc")

# Function ----------------------------------------------------------------

do_add_clim <- function(f) {
  
  output_file <- basename(f) %>%  
    gsub("_anom_", "_bc_", .) %>% # Replace the anomalies code in the file name with a code for bias corrected (bc)
    gsub("_ssp245_", "_historical_", .) %>%
    paste0(input_folder, "/_4_bias_corrected/", .) # Include the path
  
  cdo_code <- paste0("cdo -s -L -f nc4 -z zip ", # Zip the file up
                     "-add ", f, " ", # To the remapped regridded anomalies, add...
                     obs, " ", output_file) # The observed climatology (map of means)
  system(cdo_code)
}


#  Do the work ------------------------------------------------------------

files <- list.files(paste0(input_folder, "/_3_anomalies_remapped"), 
                    pattern = "remapped", full.names = TRUE) # The files we want to process
files <- files[grep("1994-2014", files)]

tic(); walk(files, do_add_clim); toc() # Jessie: 0.555 seconds


# Demonstration ------------------------------------------------------------

rr <- rast(paste0(input_folder, "/_4_bias_corrected/tos_mo_IPSL-CM6A-LR_1994-2014_bc_historical_remapped.nc"))[[1]]
plot(rr, main = "BC OISST SSP245 ACCESS-CM2")
maps::map("world", add = T)




