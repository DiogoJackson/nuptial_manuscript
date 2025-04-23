#Script para unir planilha e criar data_master
#Author: Diogo Silva
#Data: Wed Jul 20 18:04:32 2022
#Last update: Wed Jul 20 18:04:49 2022

#Packages ----
library(tidyverse)

#Import data ----
vis_results  <- read.csv("outputs/tables/02_vis.results.clean.csv")
data_force <- read.csv("data/processed/03_data-force_clean.csv")
nrow(vis_results)
nrow(data_force)

#Unir planilhas usando join() ----
# Adicionando ID completo ao data_force
# Preenchendo valores com NA para alinhar o número de linhas
data_force2 <- data_force %>%
  mutate(ID = c(vis_results$ID[1:n()], rep(NA, max(0, n() - nrow(vis_results))))) %>% 
  relocate(identidade, ID)

data_master <- dplyr::left_join(vis_results, data_force2, by = "ID")
head(data_master)

#Clean data_master----
data_master2 <- data_master %>% 
  select(-identidade,
         -claw_type.y,
         -body_region.y,
         -weight_mg) %>% 
  rename(claw_type = claw_type.x,
         body_region = body_region.x,
         weight_mg = weight_g)

#Save data ----
write.csv(data_master2,
          "data/processed/04_data_master.csv",
          row.names = F)

#test data ----
data_master_test <- read.csv("data/processed/04_data_master.csv")
head(data_master_test)

# Fim ---------------------------------------------------------------------
