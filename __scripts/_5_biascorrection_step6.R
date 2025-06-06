# Step 8: Adding the OISST climatology for the base period (1994-2014) to the 
# remapped CMIP anomalies (SSPs 2015-2100)
# i.e., bias correction
# UC Davis/BML ESM R workshop 2025 
# Author/s: Jessica Bolin
# Created: December 2024
# Updated: March 2025
# macOS: OK
# Windows: TBD

# Dependencies ------------------------------------------------------------

source(paste0(getwd(), "/__scripts/helpers.R"))
input_folder <- paste0(pth, bc_esm_pth)
obs <- paste0(pth, bc_pth, "/_2_OISST_climatology.nc")


# Function ----------------------------------------------------------------

do_add_clim <- function(f) {
  
  output_file <- basename(f) %>%  
    gsub("_anom_", "_bc_", .) %>% # Replace the anomalies code in the file name with a code for bias corrected (bc)
    paste0(input_folder, "/_4_bias_corrected/", .) # Include the path
  
  cdo_code <- paste0("cdo -s -L -f nc4 -z zip ", # Zip the file up
                     "-add ", f, " ", # To the remapped regridded anomalies, add...
                     obs, " ", output_file) # The observed climatology (map of means)
  system(cdo_code)
}


#  Do the work ------------------------------------------------------------

files <- list.files(paste0(input_folder, "/_3_anomalies_remapped"), 
                    pattern = "remapped", full.names = TRUE) # The files we want to process
tic(); walk(files, do_add_clim); toc() # Jessie: 0.555 seconds


# Demonstration ------------------------------------------------------------

par(mfrow=c(2,2))

rr <- rast(paste0(input_folder, 
                  "/_4_bias_corrected/tos_mo_ACCESS-CM2_2015-2100_bc_ssp245_remapped.nc"))[[1]]
plot(rr, main = "BC OISST SSP245 ACCESS-CM2")
maps::map("world", add = T)
# Raw ESM
tt <- rast(paste0(pth, "/__data/cmip6_processed/tos_Omon_ACCESS-CM2_ssp245_r1i1p1f1_gn_201501-210012.nc"))[[1]]
plot(tt, main = "Raw SSP245 ACCESS-CM2")
maps::map("world", add = T)

rr <- rast(paste0(pth, "/__data/bias_correct/esm/_2_anomalies/tos_mo_ACCESS-CM2_2015-2100_anom_ssp245.nc"))[[1]]
plot(rr, col = viridis::magma(255), main = "Anomalies ESM ACCESS-CM2")
maps::map("world", add = T)

rr <- rast(paste0(pth, "/__data/bias_correct/esm/_3_anomalies_remapped/tos_mo_ACCESS-CM2_2015-2100_anom_ssp245_remapped.nc"))[[1]]  
plot(rr, col = viridis::magma(255), main = "Bias corrected anomalies w/OISST")
maps::map("world", add = T)

par(mfrow=c(2,2))

rr <- rast(paste0(input_folder, "/_4_bias_corrected/tos_mo_IPSL-CM6A-LR_2015-2100_bc_ssp245_remapped.nc"))[[1]]
plot(rr, main = "BC OISST SSP245 IPSL-CM6A")
maps::map("world", add = T)
# Raw ESM
tt <- rast(paste0(pth, "/__data/cmip6_processed/tos_Omon_IPSL-CM6A-LR_ssp245_r1i1p1f1_gn_201501-210012.nc"))[[1]]
plot(tt, main = "Raw SSP245 IPSL-CM6A")
maps::map("world", add = T)

rr <- rast(paste0(pth, "/__data/bias_correct/esm/_2_anomalies/tos_mo_IPSL-CM6A-LR_2015-2100_anom_ssp245.nc"))[[1]]
plot(rr, col = viridis::magma(255), main = "Anomalies ESM IPSL-CM6A")
maps::map("world", add = T)

rr <- rast(paste0(pth, "/__data/bias_correct/esm/_3_anomalies_remapped/tos_mo_IPSL-CM6A-LR_2015-2100_anom_ssp245_remapped.nc"))[[1]]  
plot(rr, col = viridis::magma(255), main = "Bias corrected anomalies w/OISST")
maps::map("world", add = T)

