# Download monthly means of OISST 1995-2014 for ESM SST bias-correction
# UC Davis/BML ESM R workshop 2025 
# Author/s: Jessica Bolin
# Created: December 2024
# Updated: March 2025
# macOS: OK
# Windows: TBD

# Dependencies ------------------------------------------------------------

source(paste0(getwd(), "/__scripts/helpers.R"))


# Function ----------------------------------------------------------------

oisst_mr <- function(infile = paste0(pth, oisst_pth),
                     outfile = paste0(pth, oisst_pth_proc),
                     xmin = -126, xmax = -116, ymin = 32, ymax = 43,
                     cell_res = 0.25) {
  
  # Select SST, crop and remap 
  oisst_regrid <- paste0("cdo -L -select,name=,sst ", 
                         "-sellonlatbox,", xmin, ",", xmax, ",", ymin, ",", ymax,  
                         " -remapbil,r", 360*(1/cell_res), "x", 180*(1/cell_res), 
                         " ", infile, "/sst.mon.mean.nc.nc4", 
                         " ", outfile, "/sst.mon.mean_remap.nc")
  system(oisst_regrid)
  
}


# Run function ------------------------------------------------------------


oisst_mr() #run with default function arguments