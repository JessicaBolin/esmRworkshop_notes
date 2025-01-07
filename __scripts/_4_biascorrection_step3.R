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


# Historical climatology --------------------------------------------------

histclim <- function(model) {

### HISTORICAL 
# This creates a climatology/baseline 1993-2014 file using the ESM's historical run
# Create baseline file 1993-2014 and mean
filey <- list.files(paste0(pth, cmip_pth_proc), 
                    pattern = "historical", full.names = T)
filey <- filey[grep(model, filey)]
rr <- rast(filey)
#time(rr) <- as.Date(time(rr))
rr <- rr[[time(rr) > as.Date("1994-01-01")]]
mean_rr <- mean(rr)
terra::writeCDF(mean_rr, 
                paste0(pth, bc_esm_pth, "/_1_climatology/tos_mo_", model, 
                       "_1994-2014_clim_historical.nc"),
                overwrite = T)

}


histclim("ACCESS-CM2")
histclim("IPSL-CM6A-LR")


# Create ESM anomalies ----------------------------------------------------

anom_esm <- function(model) {
  
  mean_rr <- rast(paste0(pth, bc_esm_pth, "/_1_climatology/tos_mo_", model, 
                    "_1994-2014_clim_historical.nc"))
    
  ### SSPS
  # Then substract mean climatology from 2015-2100 for both EMSs, creating anomalies
  filey <- list.files(paste0(pth, cmip_pth_proc), 
                      pattern = "ssp", full.names = T)
  filey <- filey[grep(model, filey)]
  
  for (i in 1:length(filey)) {
    
    #isolate SSP from string
    ssp_string <- strsplit(filey[i], model, "_")[[1]][2]
    ssp <- strsplit(ssp_string, "_r1i1p1f1")[[1]][1]
    
    #import raster and calc anomalies
    scen <- rast(filey[i])
    anom <- scen - mean_rr 
    writeCDF(anom, paste0(pth, bc_esm_pth, "/_2_anomalies/tos_mo_", 
                          model, "_2015-2100_anom", ssp, ".nc"),
             overwrite = T)
  }
}


# Run function ------------------------------------------------------------


tic(); anom_esm("ACCESS-CM2"); toc() #Jessie: 0.689 seconds
anom_esm("IPSL-CM6A-LR")

# Test
clim <- rast(paste0(pth, bc_esm_pth, "/_1_climatology/tos_mo_ACCESS-CM2_1994-2014_clim_historical.nc"))
plot(clim, main = "ACCESS-CM2 climatology 1994-2014"); maps::map("world", add = T)

rr <- terra::rast(paste0(pth, bc_pth, bc_pth_anom, "/tos_mo_ACCESS-CM2_2015-2100_anom_ssp245.nc"))
plot(rr[[1]], main = "ACCESS-CM2 anomalies SSP245 Jan 2015"); maps::map("world", add = T)

rr <- terra::rast(paste0(pth, bc_pth, bc_pth_anom, "/tos_mo_IPSL-CM6A-LR_2015-2100_anom_ssp245.nc"))
plot(rr[[1]], main = "IPSL-CM6A-LR anomalies SSP245 Jan 2015"); maps::map("world", add = T)


# ok. these are projected.
#system(paste0("cdo griddes /Users/admin/Documents/GitHub/BMLworkshop/__data/bias_correct/esm/tos_mo_ACCESS-CM2_2015-2100_anom_ssp245.nc")) 
#system(paste0("cdo griddes /Users/admin/Documents/GitHub/BMLworkshop/__data/bias_correct/esm/tos_mo_ACCESS-CM2_1994-2014_clim_historical.nc")) 
