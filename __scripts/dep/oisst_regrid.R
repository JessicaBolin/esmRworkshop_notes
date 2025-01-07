
# OISST
# Regrid, crop and calculate monthly averages 
# Merge the files into monhtly files
# 
# infile <- "/Users/admin/Desktop/oisst"
# outfile <- "/Users/admin/Desktop/oisst_processed"
# yr = "2012"
library(tictoc)
filey <- list.files(infile, pattern = yr)



oisst_mr <- function(yr,
                   infile = "/Users/admin/Desktop/oisst",
                   outfile = "/Users/admin/Desktop/oisst_processed",
                   xmin = -126, xmax = -115, ymin = 32, ymax = 43,
                   cell_res = 0.25) {
  
  
  cdoo <- paste0("cdo -mergetime ", 
                 infile, "/", "oisst-avhrr-v02r01.", yr, "*.nc ", 
                 outfile, "/", "oisst-avhrr-merged_", yr, ".nc")
  system(cdoo) # takes a few seconds


#monthly means
runme3 <- paste0("cdo -L monmean ", 
                 outfile, "/oisst-avhrr-merged_", yr, ".nc ",
                 outfile, "/mean_", yr, ".nc")
system(runme3)

# Select SST, crop and remap 
runme2 <- paste0("cdo -L -select,name=,sst ", 
                 "-sellonlatbox,", xmin, ",", xmax, ",", ymin, ",", ymax,  
                 " -remapbil,r", 360*(1/cell_res), "x", 180*(1/cell_res), 
                 " ", outfile, "/mean_", yr, ".nc", 
                 " ", outfile, "/mean_remap_", yr, ".nc")
system(runme2)

# Remove temporary files 
system(paste0("rm ", outfile, "/", "oisst-avhrr-merged_", yr, ".nc"))
system(paste0("rm ", outfile, "/mean_", yr, ".nc"))


}

# Vector of years you want to process
years <- 1994:2014  # Modify as needed

library(furrr)
plan(multisession, workers = 14)  
tic(); future_map(years, ~ oisst_mr(.x)); toc()
plan(sequential)
# 56 seconds! Nice. 


rr <- terra::rast("/Users/admin/Desktop/oisst_processed/mean_remap_1994.nc")[[1]]
rr
terra::plot(rr, main = "Jan 1994")
maps::map("world", add= T)



