# Nuptial coloration in fiddler crab
# Script to unite datasets
# Author: Diogo Silva
# Data: Sat Aug  6 13:39:58 2022 
# Last update: Tue Oct 21 14:56:36 2025 ------------------------------

# Packages ----
library(dplyr)

# Import datasets ----
# all
vis.all <- read.csv("outputs/tables/01_vis-all.csv")
summary <- read.csv("outputs/tables/01_summary_cor.csv") %>% 
  rename(ID = ID2) #renomeado ID2 para ID, para ser utilizado na funcao join

#Unir planilhas usando join() ----
visual.results <- dplyr::left_join(vis.all, summary, by = "ID")
head(visual.results)


#Save visual. results ----
write.csv(visual.results,
          "outputs/tables/01_visual-results.csv",
          row.names = F)

#test ----
vis.results.test <- read.csv("outputs/tables/01_visual-results.csv")
head(vis.results.test)

# FIM ---------------------------------------------------------------------

  
  