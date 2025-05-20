# Diogo Thesis
# Chapter 3 - Nuptial coloration
# Script to create reflectance spreadsheet
# Author: Diogo Silva
# date: Mon Jul 18 17:36:55 2022
# last update:
# Sun Sep 29 16:14:41 2024 ------------------------------

#Packages ----
library(tidyverse)
library(pavo)
library(colorspec)

#To install `colorspec` use: remotes::install_github("Diogojackson/colorspec/colorspec")

#Import procspec data ----
refletancias <- getspec("data/raw/refletancias",                 
                                ext=c("procspec","txt"), 
                                decimal=",", 
                                lim=c(300,700))

refletancias <- colorspec::fixspec(refletancias)

#Save reflectances ----
write.csv(refletancias,
          "data/raw/refletancias/00_refletancias.csv", 
          row.names = FALSE)

#test saved data ----
reflet_test <- read.csv("data/raw/refletancias/00_refletancias.csv")
reflet_test <- fixspec(reflet_test)
head(reflet_test)

# FIM ----