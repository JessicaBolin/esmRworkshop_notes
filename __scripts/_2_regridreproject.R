# Regrid and reproject CMIP6 ESMs
# UC Davis/BML ESM R workshop 2025 
# Created: Dec 2024


# Dependencies ------------------------------------------------------------

#pth <- "/Users/admin/Documents/GitHub/BMLworkshop"
source(paste0(getwd(), "/__scripts/helpers.R"))

# Inspect ESM -------------------------------------------------------------

### R
rr <- rast(paste0(pth, cmip_pth, 
                  "/tos_Omon_ACCESS-CM2_historical_r1i1p1f1_gn_185001-201412.nc")) 
rr <- rr[[1]] #the first layer
plot(rr) # Nope! 
rr

nc <- nc_open(paste0(pth, cmip_pth, 
                     "/tos_Omon_ACCESS-CM2_historical_r1i1p1f1_gn_185001-201412.nc"))
nc


# Remap with CDO and R ----------------------------------------------------

remap_n_crop_temp <- function(nc_file,
                              cell_res = 0.25, 
                              infold = paste0(pth, cmip_pth), 
                              outfold = paste0(pth, cmip_pth_proc),
                              xmin = -126, xmax = -115, ymin = 32, ymax = 43) {
  
  system(paste0("cdo -L -sellonlatbox,", xmin, ",", xmax, ",", ymin, ",", ymax,  
                " -remapbil,r", 360*(1/cell_res), "x", 180*(1/cell_res), 
                " -select,name=tos ", infold, "/", nc_file, " ", outfold, "/", nc_file))  
  
}

fileys <- list.files(paste0(pth, cmip_pth)) #list the file names of ESMs

tic(); for (i in 1:length(fileys)) {
  remap_n_crop_temp(fileys[i])
}; toc() #28.4 seconds on Jessie's machine


# Visualise output --------------------------------------------------------

# Read in one of the processed output files
rr <- rast(paste0(pth, cmip_pth_proc, 
                  "/tos_Omon_ACCESS-CM2_historical_r1i1p1f1_gn_185001-201412.nc"))
rr <- rr[[1]] #first layer 
plot(rr, main = "Remapped and cropped")
maps::map("state", add = T) #add US state boundaries
rr #display metadata
