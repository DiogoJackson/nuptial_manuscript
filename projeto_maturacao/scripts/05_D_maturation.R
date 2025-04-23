#Analise dados maturidade
#Autor: Diogo J. A. Silva
# Mon Sep 23 14:44:48 2024 ------------------------------

#Packages ----
library(tidyverse)
library(readxl)
library(car)

#Import data ----
dados_clean <- read.csv("data/processed/maturation_data_clean.csv")

dados_clean$claw_lenght <- as.numeric(dados_clean$claw_lenght)
dados_clean$carapace_size <- as.numeric(dados_clean$carapace_size)

# Teste exato de Fisher ----
# Esse teste foi escolhido em detrimento do qui-quadrado devido aos valores abaixo de 5

#Machos (plot p1) ----
dados_m <- dados_clean %>% 
  filter(Sex == "Male")

tabela_m <- table(dados_m$carapace_color, dados_m$maturation_stage)
tabela_m

fisher_m <- fisher.test(tabela_m)
fisher_m

#Females (plot p1) ----
dados_f <- dados_clean %>% 
  filter(Sex == "Female")

tabela_f <- table(dados_f$carapace_color, dados_f$maturation_stage)
tabela_f

fisher_f <- fisher.test(tabela_f) ## Para caso tenha muitos valores abaixo de 5
fisher_f

#GLM tamanho ~ maturidade + cor (plot p2)
shapiro.test(dados_m$carapace_size)
shapiro.test(dados_f$carapace_size)

#Using gaussian family ----

#Male ----
m1.1 <- glm(carapace_size ~ maturation_stage + carapace_color, data = dados_m)
summary(m1.1)
vif(m1.1)

#Diagnóstico do modelo ----
summary(m1.1)

# 2. Gráficos de diagnóstico padrão (base R)
par(mfrow = c(2, 2))  # Layout 2x2
plot(m1.1)
par(mfrow = c(1, 1))  # Volta ao padrão


#Female ----
m2.1 <- glm(carapace_size ~ maturation_stage + carapace_color, data = dados_f)
summary(m2.1)

#Diagnóstico do modelo ----
summary(m2.1)

# 2. Gráficos de diagnóstico padrão (base R)
par(mfrow = c(2, 2))  # Layout 2x2
plot(m2.1)
par(mfrow = c(1, 1))  # Volta ao padrão
#FIM ----
