# Nuptial coloration in fiddler crab
# Script to clean reflectance spreadsheet
# Author: Diogo Silva
# Date: Mon Jul 18 17:36:55 2022
# last update:
# Tue Oct 21 14:48:28 2025 ------------------------------

#Packages ----
library(pavo)
library(tidyverse)
library(colorspec) #remotes::install_github("Diogojackson/colorspec/colorspec")

#Import reflectance data ----
reflet <- read.csv("data/raw/refletancias/00_refletancias.csv")
reflet <- fixspec(reflet)

#Separate into reflectances ----
#Separating claw and carapace ----
reflet_q <- reflet %>%
  select(wl, contains("_q_"))

reflet_c <- reflet %>%
  select(wl, contains("_c_"))

reflet_c2 <- reflet %>%
  select(wl, contains("_c_"), "substrato_barradorio")

#Separating claws into brachychelous and leptochelous ----
reflet_claw_type <- reflet_q %>%
  rename(Brachychelous = contains("_brac_")) %>% 
  rename(Leptochelous = contains("_lep_"))

#Separating carapaces into bright and dark ----
reflet_carapace_type <- reflet_c %>%
  rename(Bright = contains("_claro")) %>% 
  rename(Dark = contains("_escuro")) %>% 
  rename(Real = contains("_real"))

reflet_carapace_type2 <- reflet_c2 %>%
  rename(Bright = contains("_claro")) %>% 
  rename(Dark = contains("_escuro"))%>% 
  rename(Real = contains("_real"))

#Separating claws into bright and dark ----
reflet_claw_color <- reflet_q %>%
  rename(Bright = contains("_claro")) %>% 
  rename(Dark = contains("_escuro"))%>% 
  rename(Real = contains("_real"))

#Saving tables ----
write.csv(reflet_claw_type,
          "data/processed/01_reflet_claw_type.csv", 
          row.names = FALSE)

write.csv(reflet_carapace_type,
          "data/processed/01_reflet_carapace_type.csv", 
          row.names = FALSE)

write.csv(reflet_carapace_type2,
          "data/processed/01_reflet_carapace_with_background.csv", 
          row.names = FALSE)

write.csv(reflet_claw_color,
          "data/processed/01_reflet_claw_color.csv", 
          row.names = FALSE)

#Test tables ----
reflet_test  <- read.csv("data/processed/01_reflet_claw_type.csv")
reflet_test  <- fixspec(reflet_test)

reflet_test2 <- read.csv("data/processed/01_reflet_carapace_type.csv")
reflet_test2 <- fixspec(reflet_test2)

reflet_test3 <- read.csv("data/processed/01_reflet_claw_color.csv")
reflet_test3 <- fixspec(reflet_test2)

# FIM ---------------------------------------------------------------------


