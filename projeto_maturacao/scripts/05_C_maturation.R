#Clean dados maturidade
#Autor: Diogo J. A. Silva
# Mon Sep 23 14:46:19 2024 ------------------------------

#Packages ----
library(tidyverse)
library(readxl)

#Import data ----
dados <- read_excel("data/raw/dados_maturidade.xlsx")

#Clean data ----
dados$cara_h <- as.numeric(dados$cara_h)
dados$cara_v <- as.numeric(dados$cara_v)
dados$quela_h <- as.numeric(dados$quela_h)

dados_clean <- dados %>% 
  rename(Sex = sexo,
         carapace_color = cor,
         claw_lenght = quela_h,
         carapace_size = cara_h,
         maturation_stage = maturacao,
         residencia = Residencia
  ) %>%
  mutate(carapace_color = fct_recode(carapace_color,
                                     "White" = "b",
                                     "Dark" = "e",
                                     "Yellow" = "a")
  ) %>% 
  filter(carapace_color != "Yellow")

dados_clean %>% 
  count(Sex, carapace_color)

#Save tables ----
write.csv(dados_clean,
          "data/processed/maturation_data_clean.csv",
          row.names = F)


# Fim ---------------------------------------------------------------------
