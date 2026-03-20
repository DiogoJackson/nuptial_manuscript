# Nuptial coloration in fiddler crabs as an indicator of reproductive quality
# Script to create reflectance spreadsheet
# Author: Diogo Silva
# Date: Mon Jul 18 17:36:55 2022
# Last update:
# Wed May 21 08:06:47 2025 ------------------------------

#Packages ----
library(tidyverse)    #version 2.0.0
library(pavo)         #version 2.9.0
library(colorspec)    #To install `colorspec` use: remotes::install_github("Diogojackson/colorspec/colorspec")

#Import procspec data ----
refletancias <- getspec("data/raw/reflectances",                 
                                ext=c("procspec","txt"), 
                                decimal=",", 
                                lim=c(300,700))

refletancias <- colorspec::fixspec(refletancias)

#Save reflectances ----
write.csv(refletancias,
          "data/raw/reflectances/00_refletancias.csv", 
          row.names = FALSE)

#test saved data ----
reflet_test <- read.csv("data/raw/reflectances/00_refletancias.csv")
reflet_test <- fixspec(reflet_test)
head(reflet_test)

# THE END ----
