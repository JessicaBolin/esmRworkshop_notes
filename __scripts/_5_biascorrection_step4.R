# Step 6: Create land mask from OISST for bias correction 
# UC Davis/BML ESM R workshop 2025 
# Author/s: Jessica Bolin
# Created: December 2024
# Updated: March 2025
# macOS: OK
# Windows: TBD

# Dependencies ------------------------------------------------------------

source(paste0(getwd(), "/__scripts/helpers.R"))
infile <- paste0(pth, bc_pth, "/_2_OISST_climatology.nc")
outfile <- paste0(pth, bc_pth, "/_3_OISST_mask.nc")

# 5.6 Make the mask using CDO -------------------------------------------------

# make a mask saying "0:land, 1:ocean"
system(paste0("cdo -expr,'sst = ((sst>-2)) ? 1.0 : sst/0.0' ", infile, " ", outfile))

# plot the mask
r <- rast(outfile)
plot(r, main = "OISST land mask"); values(r) %>% range(na.rm=T)
maps::map("world", add = T)
system(paste0("cdo griddes ", outfile)) #lonlat grid

