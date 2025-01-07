# Bias correction
# Dec 2024
# Step 3 - Create baseline ESM files (i.e., climatology 1994-2014)
# Calculate anomalies (subtract ESM mean step8 from ESM observations/projections step7) for each model/SSP combo
# This creates three files per ESM:
# (i) a climatology for the historical period, time matching our OISST climatology (1994-2014)
# (ii) anomalies for each month during the SSP245 run from 2015-2100 (using the ESM climatology)
# (iii) anomalies for each month during the SSP585 run from 2015-2100 (using the ESM climatology)


# Dependencies ------------------------------------------------------------

#pth <- "/Users/admin/Documents/GitHub/BMLworkshop"
source(paste0(getwd(), "/__scripts/helpers.R"))

# Create ESM anomalies ----------------------------------------------------

anom_esm_hist <- function(model) {
  
  mean_rr <- rast(paste0(pth, bc_esm_pth, "/_1_climatology/tos_mo_", model, 
                    "_1994-2014_clim_historical.nc"))
    
  # Then substract mean climatology from historical for both EMSs, creating anomalies
  filey <- list.files(paste0(pth, cmip_pth_proc), 
                             pattern = "historical", full.names = T)
  filey <- filey[grep(model, filey)]

  for (i in 1:length(filey)) {
    
    #import raster and calc anomalies
    scen <- rast(filey)
    scen <- scen[[time(scen) > "1994-01-01"]]
    anom <- scen - mean_rr 

    writeCDF(anom, paste0(pth, bc_esm_pth, "/_2_anomalies/tos_mo_", 
                          model, "_1994-2014_anom_historical.nc"),
             overwrite = T)
  }
}


# Run function ------------------------------------------------------------

tic(); anom_esm_hist("ACCESS-CM2"); toc() #Jessie: 0.689 seconds
anom_esm_hist("IPSL-CM6A-LR")

# Test
clim <- rast(paste0(pth, bc_esm_pth, "/_1_climatology/tos_mo_ACCESS-CM2_1994-2014_clim_historical.nc"))
plot(clim, main = "ACCESS-CM2 climatology 1994-2014"); maps::map("world", add = T)

clim <- rast(paste0(pth, bc_esm_pth, "/_1_climatology/tos_mo_IPSL-CM6A-LR_1994-2014_clim_historical.nc"))
plot(clim, main = "ACCESS-CM2 climatology 1994-2014"); maps::map("world", add = T)


# ok. these are projected.
#system(paste0("cdo griddes /Users/admin/Documents/GitHub/BMLworkshop/__data/bias_correct/esm/tos_mo_ACCESS-CM2_2015-2100_anom_ssp245.nc")) 
#system(paste0("cdo griddes /Users/admin/Documents/GitHub/BMLworkshop/__data/bias_correct/esm/tos_mo_ACCESS-CM2_1994-2014_clim_historical.nc")) 
