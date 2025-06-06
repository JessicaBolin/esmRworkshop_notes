# Bias correction - HISTORICAL
# Author/s: Jessica Bolin
# Created: December 2024
# Updated: March 2025
# macOS: OK
# Windows: TBD

# Step 35- Create baseline ESM files (i.e., climatology 1995-2014)
# Calculate anomalies (subtract ESM mean step8 from ESM observations/projections step7) for each model/SSP combo
# This creates three files per ESM:
# (i) a climatology for the historical period, time matching our OISST climatology (1995-2014)
# (ii) anomalies for each month during the SSP245 run from 2015-2100 (using the ESM climatology)
# (iii) anomalies for each month during the SSP585 run from 2015-2100 (using the ESM climatology)


# Dependencies ------------------------------------------------------------

source(paste0(getwd(), "/__scripts/helpers.R"))

# Create ESM anomalies ----------------------------------------------------

anom_esm_hist <- function(model) {
  
  mean_rr <- rast(paste0(pth, bc_esm_pth, "/_1_climatology/tos_mo_", model, 
                    "_1995-2014_clim_historical.nc"))
    
  # Then substract mean climatology from historical for both EMSs, creating anomalies
  filey <- list.files(paste0(pth, cmip_pth_proc), 
                             pattern = "historical", full.names = T)
  filey <- filey[grep(model, filey)]

  for (i in 1:length(filey)) {
    
    #import raster and calc anomalies
    scen <- rast(filey)
    scen <- scen[[time(scen) > "1995-01-01"]]
    anom <- scen - mean_rr 

    writeCDF(anom, paste0(pth, bc_esm_pth, "/_2_anomalies/tos_mo_", 
                          model, "_1995-2014_anom_historical.nc"),
             overwrite = T)
  }
}


# Run function ------------------------------------------------------------

tic(); anom_esm_hist("ACCESS-CM2"); toc() #Jessie: 0.689 seconds
anom_esm_hist("IPSL-CM6A-LR")

# Test
clim <- rast(paste0(pth, bc_esm_pth, "/_1_climatology/tos_mo_ACCESS-CM2_1995-2014_clim_historical.nc"))
plot(clim, main = "ACCESS-CM2 climatology 1994-2014"); maps::map("world", add = T)

clim <- rast(paste0(pth, bc_esm_pth, "/_1_climatology/tos_mo_IPSL-CM6A-LR_1995-2014_clim_historical.nc"))
plot(clim, main = "IPSL-CM6A climatology 1994-2014"); maps::map("world", add = T)

