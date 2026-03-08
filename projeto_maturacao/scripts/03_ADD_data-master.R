# Nuptial coloration in fiddler crabs as an indicator of reproductive quality
# Script to merge spreadsheets and create data_master
#Author: Diogo Silva
#Data: Wed Jul 20 18:04:32 2022
#Last update: Wed Jul 20 18:04:49 2022

# Packages ----
library(tidyverse)

# Import data ----
vis_results  <- read.csv("outputs/tables/02_vis.results.clean.csv")
data_force <- read.csv("data/processed/03_data-force_clean.csv")
nrow(vis_results)
nrow(data_force)

# Merging data using join() ----
# Adding complete ID to data_force
# Filling values with NA to align the number of rows
data_force2 <- data_force %>%
  mutate(ID = c(vis_results$ID[1:n()], rep(NA, max(0, n() - nrow(vis_results))))) %>% 
  relocate(ID, identidade)

data_master <- dplyr::left_join(vis_results, data_force2, by = "ID")
head(data_master)

# Cleaning data_master----
data_master2 <- data_master %>% 
  select(-claw_type.y,
         -body_region.y,
         -weight_mg) %>% 
  rename(claw_type = claw_type.x,
         body_region = body_region.x,
         weight_mg = weight_g)

# Saving data ----
write.csv(data_master2,
          "data/processed/04_data_master.csv",
          row.names = F)

# Testing data ----
data_master_test <- read.csv("data/processed/04_data_master.csv")
head(data_master_test)

# THE END ---------------------------------------------------------------------

