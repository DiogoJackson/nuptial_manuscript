# Nuptial coloration in fiddler crabs as an indicator of reproductive quality
# Analisys maturity data
# Author: Diogo J. A. Silva
# Mon Sep 23 14:44:48 2024 ------------------------------

# Packages ----
library(tidyverse)
library(readxl)
library(car)

# Import data ----
dados_clean <- read.csv("data/processed/maturation_data_clean.csv")

dados_clean$claw_lenght <- as.numeric(dados_clean$claw_lenght)
dados_clean$carapace_size <- as.numeric(dados_clean$carapace_size)

# Fisher's exact test ----
# This test was chosen instead of the chi-square test due to values below 5

# Males (plot p1) ----
dados_m <- dados_clean %>% 
  filter(Sex == "Male")

tabela_m <- table(dados_m$carapace_color, dados_m$maturation_stage)
tabela_m

fisher_m <- fisher.test(tabela_m)
fisher_m

# Females (plot p1) ----
dados_f <- dados_clean %>% 
  filter(Sex == "Female")

tabela_f <- table(dados_f$carapace_color, dados_f$maturation_stage)
tabela_f

fisher_f <- fisher.test(tabela_f) ## For cases with many values below 5
fisher_f

# THE END ----
