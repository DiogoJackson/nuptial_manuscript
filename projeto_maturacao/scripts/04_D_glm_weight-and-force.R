#Script para fazer os graficos das diferenças de carapaça nupcial e escura
#Author: Diogo Silva
# Fri Dec 23 17:40:13 2022 ------------------------------

#Packages ----
library(tidyverse)
library(cowplot)
library(ggpubr)
library(glmmTMB) #beta regression
library(foreign) #Vif
library(car)
library(fitdistrplus)
library(caret)

#1. import data ----
data <- read.csv("data/processed/04_data_master.csv")
glimpse(data)

#2. Analisando tipo de quela ------------------------------------------------------
#subset da modelagem visual do caranguejo considerando apenas os valores de quela
data_qt <- data %>% 
  filter(vismodel == "Fiddler crab") %>% 
  filter(body_region == "Claw") #qt = quela type

data_brac <- data %>% 
  filter(vismodel == "Fiddler crab") %>% 
  filter(body_region == "Claw") %>% 
  filter(claw_type == "Brachychelous")

data_cara <- data %>% 
  filter(vismodel == "Fiddler crab") %>% 
  filter(body_region == "Carapace") %>% 
  filter(claw_type == "Brachychelous")

# Fitting model for claw weight ----
# GLM peso da quela ----

# Remover NAs da variável de interesse
data_brac_na <- data_brac %>%
  filter(!is.na(weight_mg))

# Modelo final
m1 <- glm(weight_mg ~ size + carapace_color, 
          family = "gaussian", data = data_brac_na)

vif(m1) # Verifica colinearidade
summary(m1)


# Diagnósticos do modelo final ----
par(mfrow = c(2, 2))  # Exibe os 4 gráficos de diagnóstico padrão
plot(m1)            # Diagnóstico visual: resíduos, leverage, etc.

# Reset layout gráfico (opcional)
par(mfrow = c(1, 1))


# Fitting gamma regression ----

# Devido a multicolinearidade (vif > 5) de luminance e brilho medio, luminance foi retirado do modelo
m2 <- glm(max_force ~ 
              size + 
              carapace_color +
              weight_mg,
            family = Gamma(link = "log"),
            data = data_brac_na)
vif(m2) #it's all good
summary(m2)

# Fitting gamma regression ----

# Devido a multicolinearidade (vif > 5) de luminance e brilho medio, luminance foi retirado do modelo
m2 <- glm(max_force ~ 
            size + 
            carapace_color +
            weight_mg,
          family = Gamma(link = "log"),
          data = data_brac_na)
vif(m2) #it's all good
summary(m2)

# Diagnóstico do modelo final

# Resíduos de Pearson
resid_pearson <- resid(m2, type = "pearson")
fitted_vals <- fitted(m2)

# Configurar layout de 2x2
par(mfrow = c(2, 2))

# 1. Resíduos de Pearson vs valores ajustados
plot(fitted_vals, resid_pearson,
     main = "Resíduos de Pearson vs Ajustados",
     xlab = "Valores ajustados",
     ylab = "Resíduos de Pearson",
     pch = 16, col = "grey40")
abline(h = 0, lty = 2, col = "red")

# 2. Q-Q plot dos resíduos de Pearson
qqnorm(resid_pearson,
       main = "Q-Q plot dos resíduos de Pearson",
       pch = 16, col = "grey40")
qqline(resid_pearson, col = "red", lty = 2)

# 3. Scale-Location (variância dos resíduos)
sqrt_abs_resid <- sqrt(abs(resid_pearson))
plot(fitted_vals, sqrt_abs_resid,
     main = "Scale-Location",
     xlab = "Valores ajustados",
     ylab = "√|Resíduos de Pearson|",
     pch = 16, col = "grey40")
abline(h = 0, lty = 2, col = "red")

# 4. Resíduos de Pearson vs leverage
leverage <- hatvalues(m2)
plot(leverage, resid_pearson,
     main = "Resíduos de Pearson vs Leverage",
     xlab = "Leverage",
     ylab = "Resíduos de Pearson",
     pch = 16, col = "grey40")
abline(h = 0, lty = 2, col = "red")

# Reset layout gráfico
par(mfrow = c(1, 1))

# Distância de Cook (opcional)
plot(cooks.distance(m2),
     type = "h",
     main = "Distância de Cook",
     ylab = "Cook's distance",
     col = "firebrick")
abline(h = 4 / nrow(data_brac_na), lty = 2, col = "grey50")


# FIM ---------------------------------------------------------------------


