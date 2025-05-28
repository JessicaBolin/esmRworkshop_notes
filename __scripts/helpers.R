# Helpers 
# UC Davis/BML ESM R workshop 2025 
# Created: Dec 2024

# Global path -------------------------------------------------------------

pth <- getwd() # THIS NEEDS TO CHANGE PER PERSON

# Other paths -------------------------------------------------------------

oisst_pth <- "/__data/oisst_raw"
oisst_pth_proc <- "/__data/oisst_processed"
cmip_pth <- "/__data/cmip6_raw"
cmip_pth_proc <- "/__data/cmip6_processed"
ts_pth <- "__data/timeseries"
bc_pth <- "/__data/bias_correct"
bc_esm_pth <- "/__data/bias_correct/esm"
bc_pth_anom <- "/esm/_2_anomalies"
bc_pth_anom_rm <- "/esm/_3_anomalies_remapped"
bc_pth_bc <- "/esm/_4_bias_corrected"
wget_pth <- "/__scripts/wget_scripts" 
proj_pth <- "/__data/projections"

# Models ------------------------------------------------------------------

mods = c("ACCESS-CM2", "IPSL-CM6A-LR")


# Packages ----------------------------------------------------------------

library(terra)
library(parallelly)
library(furrr)
library(ncdf4)
library(tidyverse)
library(beepr)
library(tictoc)
library(RCurl)
library(xml2)
library(rvest)
library(tmap)
library(raster)
library(purrr)
library(plotrix)
library(zoo)


# If output folder doesn't exist,  create it -----------------------------------

make_folder <- function(folder) {
  if(!isTRUE(file.info(folder)$isdir)) {
    dir.create(folder, recursive=TRUE) } else 
      message("Folder not created: folder already exists") 
}


# Make data folders --------------------------------------------

make_folder(paste0(pth, "/__data"))

make_folder(paste0(pth, "/__data/bias_correct"))
make_folder(paste0(pth, "/__data/bias_correct/esm"))
make_folder(paste0(pth, "/__data/bias_correct/esm/_1_climatology"))
make_folder(paste0(pth, "/__data/bias_correct/esm/_2_anomalies"))
make_folder(paste0(pth, "/__data/bias_correct/esm/_3_anomalies_remapped"))
make_folder(paste0(pth, "/__data/bias_correct/esm/_4_bias_corrected"))

make_folder(paste0(pth, "/__data/cmip6_processed"))
make_folder(paste0(pth, "/__data/cmip6_raw"))
make_folder(paste0(pth, "/__data/oisst_processed"))
make_folder(paste0(pth, "/__data/oisst_raw"))

make_folder(paste0(pth, "/__data/projections"))
make_folder(paste0(pth, "/__data/projections/delta"))
make_folder(paste0(pth, "/__data/projections/ens"))
make_folder(paste0(pth, "/__data/projections/ind"))

make_folder(paste0(pth, "/__data/projections/timeseries"))


