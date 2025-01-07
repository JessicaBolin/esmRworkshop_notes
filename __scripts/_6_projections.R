# Projections for two time periods
# 2020-2040
# 2080-2100
# UC Davis/BML ESM R workshop 2025 
# Created: Dec 2024


# Dependencies ------------------------------------------------------------

#pth <- "/Users/admin/Documents/GitHub/BMLworkshop"
source(paste0(getwd(), "/__scripts/helpers.R"))

# Ensemble for each model -------------------------------------------------

models = c("ACCESS-CM2", "IPSL-CM6A-LR")
ssps = c("ssp245", "ssp585")
term = c("near", "long")
outdir = paste0(pth, proj_pth)
indir_proj <- paste0(pth, bc_pth, bc_pth_bc)

termdf <- data.frame(timeperiod = c("near", "long"),
                     st = c("2020-01-01", "2080-01-01"),
                     fin = c("2040-01-01", "2100-01-01"))

tic(); for (k in term) {
  for (i in ssps) {
    for (j in models) {
      
      allfiles_proj <- list.files(indir_proj, pattern = j, full.names = T)
      allfiles_proj <- allfiles_proj[grep(i, allfiles_proj)]
      allfiles_proj <- allfiles_proj[grep("2100", allfiles_proj)]
      rr <- rast(allfiles_proj)
      
      # subset to time period
      tp <- subset(termdf, timeperiod == k)
      rr <- rr[[time(rr) > tp[,"st"] & time(rr) < tp[,"fin"] ]]
      
      # Mean and SD
      proj_u <- mean(rr)
      proj_sd <- stdev(rr)
      # write to outdir
      filename_u <- paste0(outdir, "/ind/mean_", j, "_", i, "_", k, "_", "proj.nc" )
      filename_sd <- paste0(outdir, "/ind/sd_", j, "_", i, "_", k, "_", "proj.nc" )
      terra::writeCDF(proj_u, filename_u, overwrite = T)
      terra::writeCDF(proj_sd, filename_sd, overwrite = T)
    }
  }
}; toc() #Jessie: 1.8 seconds



# Actual ensemble ---------------------------------------------------------

tic(); for (k in term) {
  for (i in ssps) {
    
      
      allfiles_proj <- list.files(paste0(pth, "/__data/projections/ind"), 
                                  pattern = i, full.names = T)
      allfiles_proj <- allfiles_proj[grep(k, allfiles_proj)]
      allfiles_proj <- allfiles_proj[grep("mean", allfiles_proj)]
      rr <- rast(allfiles_proj)
      
      # Mean and SD
      proj_u <- mean(rr)
      proj_sd <- stdev(rr)
    
      # write to outdir
      filename_u <- paste0(outdir, "/ens/mean_ens_", i, "_", k, "_", "proj.nc" )
      filename_sd <- paste0(outdir, "/ens/sd_ens_", i, "_", k, "_", "proj.nc" )
      terra::writeCDF(proj_u, filename_u, overwrite = T)
      terra::writeCDF(proj_sd, filename_sd, overwrite = T)
      
  }
}; toc() #Jessie: 0.3 seconds


# Delta difference --------------------------------------------------------

# Delta difference
outdir = paste0(pth, proj_pth, "/delta") 

# Historical --------------------------------------------------------------

#Ensemble average of 1994-2014 for both models
full_pth <- paste0(pth, bc_pth, bc_pth_bc, "/")
r1 <- rast(paste0(full_pth, "tos_mo_ACCESS-CM2_1994-2014_bc_historical_remapped.nc"))
r2 <- rast(paste0(full_pth, "tos_mo_IPSL-CM6A-LR_1994-2014_bc_historical_remapped.nc"))
rr <- c(r1, r2)
mean_hist <- mean(rr)


# Delta projections -------------------------------------------------------

# Read in ensemble for all three terms SSP245

ssps = c("ssp245", "ssp585")
#i = "ssp585"
tic(); for (i in ssps) {
  
  near_mean <- rast(paste0(pth, "/__data/projections/ens/mean_ens_", i, "_near_proj.nc"))
  rr <- near_mean - mean_hist
  writeCDF(rr, paste0(outdir, "/delta_mean_ens_near_", i, ".nc"),
           overwrite = T)
  
  long_mean <- rast(paste0(pth, "/__data/projections/ens/mean_ens_", i, "_long_proj.nc"))
  rr <- long_mean - mean_hist
  writeCDF(rr, paste0(outdir, "/delta_mean_ens_long_", i, ".nc"),
           overwrite = T)
  
}; toc() #Jessie: 0.226 seconds


# plot ---------------------------------------------------------------------

# Visualise projections

# 3 columns
# Near, mid, long 

# 2 rows
# Projections
# Delta

# Repeat for each SSP
deltapth = "/Users/admin/Documents/GitHub/BMLworkshop/__data/projections/delta/"


# Long --------------------------------------------------------------------

r2 <- rast(paste0(pth, "/__data/projections/ens/mean_ens_ssp585_long_proj.nc"))
plot(r2, main = "Mean SST",
     range = c(11,22)); maps::map("world", add = T, fill = T, col = "grey")
r3 <-  rast(paste0(pth, "/__data/projections/ens/sd_ens_ssp585_long_proj.nc"))
plot(r3, main = "Std Dev SD",
     col = viridis::magma(255),
     range = c(0,2)); maps::map("world", add = T, fill = T, col = "grey")
r1 <- rast(paste0(deltapth, "delta_mean_ens_long_ssp585.nc"))
plot(r1, main = "Delta SST",
     col = viridis::mako(255),
     range = c(0.5,4.5)); maps::map("world", add = T, fill = T, col = "grey")



# Near --------------------------------------------------------------------

r2 <- rast(paste0(pth, "/__data/projections/ens/mean_ens_ssp585_near_proj.nc"))
plot(r2, main = "Mean SST",
     col = viridis::viridis(255),
     range = c(11,22)); maps::map("world", add = T, fill = T, col = "grey")
r3 <-  rast(paste0(pth, "/__data/projections/ens/sd_ens_ssp585_near_proj.nc"))
plot(r3, main = "Std Dev SST",
     col = viridis::magma(255),
     range = c(0,2)); maps::map("world", add = T, fill = T, col = "grey")
r1 <- rast(paste0(deltapth, "delta_mean_ens_near_ssp585.nc"))
plot(r1, main = "Delta SST",
     col = viridis::mako(255),
     range = c(0.5,4.5)); maps::map("world", add = T, fill = T, col = "grey")



# SSP245 ------------------------------------------------------------------


# Long --------------------------------------------------------------------

r2 <- rast(paste0(pth, "/__data/projections/ens/mean_ens_ssp245_long_proj.nc"))
plot(r2, main = "Mean SST",
     range = c(11,22)); maps::map("world", add = T, fill = T, col = "grey")
r3 <-  rast(paste0(pth, "/__data/projections/ens/sd_ens_ssp245_long_proj.nc"))
plot(r3, main = "Std Dev SD",
     col = viridis::magma(255),
     range = c(0,2)); maps::map("world", add = T, fill = T, col = "grey")
r1 <- rast(paste0(deltapth, "delta_mean_ens_long_ssp245.nc"))
plot(r1, main = "Delta SST",
     col = viridis::mako(255),
     range = c(0.5,4.5)); maps::map("world", add = T, fill = T, col = "grey")



# Near --------------------------------------------------------------------

r2 <- rast(paste0(pth, "/__data/projections/ens/mean_ens_ssp245_near_proj.nc"))
plot(r2, main = "Mean SST",
     col = viridis::viridis(255),
     range = c(11,22)); maps::map("world", add = T, fill = T, col = "grey")
r3 <-  rast(paste0(pth, "/__data/projections/ens/sd_ens_ssp245_near_proj.nc"))
plot(r3, main = "Std Dev SST",
     col = viridis::magma(255),
     range = c(0,2)); maps::map("world", add = T, fill = T, col = "grey")
r1 <- rast(paste0(deltapth, "delta_mean_ens_near_ssp245.nc"))
plot(r1, main = "Delta SST",
     col = viridis::mako(255),
     range = c(0.5,4.5)); maps::map("world", add = T, fill = T, col = "grey")

