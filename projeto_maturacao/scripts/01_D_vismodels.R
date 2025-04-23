# Diogo Thesis
# Chapter 3 - Nuptial coloration
# Script to to the visual model
# author: Diogo Silva
# Date: Wed Jul 20 11:35:29 2022
# Sun Sep 29 16:35:18 2024 ------------------------------

#Packages ----
library(pavo)
library(tidyverse)
library(colorspec)

#Import reflectances ----
#All
reflet <- read.csv("data/raw/refletancias/00_refletancias.csv")
reflet <- fixspec(reflet)

reflet_cara <- read.csv("data/processed/01_reflet_carapace_with_background.csv")
reflet_cara <- fixspec(reflet_cara)

#Vismodels ----
#Everything ----
vis.fiddler <- vis.fiddler(reflet, "substrato_barradorio", illum = "D65")
vis.peafowl <- vis.peafowl(reflet, "substrato_barradorio", illum = "D65")
vis.bluetit <- vis.bluetit(reflet, "substrato_barradorio", illum = "D65")

#All - Dark carapace vs bright carapace ----
vismodel_cara <- vis.fiddler(reflet_cara, "substrato_barradorio", illum = "D65")

#Unite outputs ----
vis.all <- bind_rows(vis.peafowl, 
                     vis.bluetit, 
                     vis.fiddler
                     )

#save tables ----
write.csv(vis.fiddler,
          "outputs/tables/01_vismodel_fiddlercrab.csv",
          row.names = F)

write.csv(vis.all,
          "outputs/tables/01_vis-all.csv",
          row.names = F)

write.csv(vismodel_cara,
          "outputs/tables/01_vismodel_carapace_color.csv",
          row.names = F)

#test tables ----
vis.all.test <- read.csv("outputs/tables/01_vis-all.csv")
head(vis.all.test)

vis.cara.test <- read.csv("outputs/tables/01_vismodel_carapace_color.csv")
head(vis.cara.test)

# THE END ---------------------------------------------------------------------
