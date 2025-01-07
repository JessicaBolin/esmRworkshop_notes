# Download ESM outputs via wget scripts
# UC Davis/BML ESM R workshop 2025 
# Created: Dec 2024

# Dependencies ------------------------------------------------------------

#pth <- "/Users/admin/Documents/GitHub/BMLworkshop"
source(paste0(getwd(), "/__scripts/helpers.R"))

# Prepare for parallel processing -----------------------------------------

parallelly::availableCores() # Output says I have 16 cores on my machine
w <- 14  # Leave two cores for other background processes

# Function to download files ----------------------------------------------

wget_files <- function(script) {
  setwd(paste0(pth, cmip_pth)) #set directory to where data will be stored
  system(paste0("bash ", script, " -s")) #run wget on the shell script 
  setwd(pth) #set directory back to home directory 
}

files <- list.files(paste0(pth, wget_pth), #full path where wget scripts are stored
                    pattern = "wget", #only files with wget in the name
                    full.names = TRUE #list the full path 
) 

# Run function in parallel ------------------------------------------------

plan(multisession, workers = w) # Change to multi-threaded processing
tic(); future_walk(files, wget_files); toc() #Run the function in parallel (takes 1 min for Jessie)
plan(sequential) # Return to single threaded processing (i.e., sequential/normal)

list.files(paste0(pth, cmip_pth)) #downloaded files post-2100

# Remove data from 2100+ --------------------------------------------------

system(paste0("rm ", pth, cmip_pth, "/", 
              "tos_Omon_ACCESS-CM2_ssp585_r1i1p1f1_gn_210101-230012.nc"))
system(paste0("rm ", pth, cmip_pth, "/", 
              "tos_Omon_IPSL-CM6A-LR_ssp585_r1i1p1f1_gn_210101-230012.nc"))

list.files(paste0(pth, cmip_pth)) #fixed. nice! 
