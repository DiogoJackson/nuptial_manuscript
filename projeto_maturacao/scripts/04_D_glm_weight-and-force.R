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

#1.1 convertendo dados
data$max_force <- as.numeric(data$max_force)

#transformando em beta ----

#Se os dados apresentarem distribuicao beta, mas possuir algum valor que nao esteja entre 0 e 1.
#Transforma-se em beta usando-se a formula abaixo:

# beta = xi / (xmax + constante)

#xi = cada valor
#xmax = valor maximo da variavel (nesse caso forca)
#constante = valor criado 0.001

data.b <- data %>% 
  filter(carapace_type != "Real") %>% #retirar os animais que foram medidos em campo e nao possuem medicao de forca, peso, etc.
  dplyr::mutate(force.b = max_force/(max(max_force) + 0.001))

#2. Analisando tipo de quela ------------------------------------------------------
#subset da modelagem visual do caranguejo considerando apenas os valores de quela
data_qt <- data.b %>% 
  filter(vismodel == "Fiddler crab") %>% 
  filter(body_region == "Claw") #qt = quela type

data_brac <- data.b %>% 
  filter(vismodel == "Fiddler crab") %>% 
  filter(body_region == "Claw") %>% 
  filter(claw_type == "Brachychelous")

data_cara <- data.b %>% 
  filter(vismodel == "Fiddler crab") %>% 
  filter(body_region == "Carapace") %>% 
  filter(claw_type == "Brachychelous")

# Fitting model for claw weight ----
# GLM peso da quela ----

# Remover NAs da variável de interesse
data_brac_na <- data_brac %>%
  filter(!is.na(weight_mg))

# Modelo completo com todas as variáveis
m1 <- glm(weight_mg ~ size + carapace_color + saturation + mean_brightness + luminance, 
          family = "gaussian", data = data_brac_na)

vif(m1) # Verifica colinearidade

# Reduzindo variáveis com base na colinearidade
m1.2 <- glm(weight_mg ~ size + carapace_color + saturation + mean_brightness, 
            family = "gaussian", data = data_brac_na)
summary(m1.2)

vif(m1.2) # Checando VIF novamente

# Modelo reduzido
m1.3 <- glm(weight_mg ~ size + carapace_color, 
            family = "gaussian", data = data_brac_na)

summary(m1.3)

#Comparacao dos modelos
anova(m1.2, m1.3, test = "LRT")

#Modelo final ----
m1.3 <- glm(weight_mg ~ size + carapace_color, 
            family = "gaussian", data = data_brac_na)

summary(m1.3)

# Diagnósticos do modelo final ----
par(mfrow = c(2, 2))  # Exibe os 4 gráficos de diagnóstico padrão
plot(m1.3)            # Diagnóstico visual: resíduos, leverage, etc.

# Reset layout gráfico (opcional)
par(mfrow = c(1, 1))


# Fitting gamma regression ----

# Devido a multicolinearidade (vif > 5) de luminance e brilho medio, luminance foi retirado do modelo
m2.1 <- glm(max_force ~ 
              size + 
              carapace_color +
              weight_mg + 
              mean_brightness +
              saturation,
            family = Gamma(link = "log"),
            data = data_brac_na)
summary(m2.1)
vif(m2.1) #it's all good

#Removing no significant variables ----
m2.2 <- glm(max_force ~ 
              size +
              weight_mg +
              saturation,
            family = Gamma(link = "log"),
            data = data_brac_na)
summary(m2.2)

#Comparacao dos modelos ----
anova(m2.1, m2.2, test = "LRT")

#Modelo final ----
m2.2 <- glm(max_force ~ 
              size +
              weight_mg +
              saturation,
            family = Gamma(link = "log"),
            data = data_brac_na)
summary(m2.2)

#Diagnostico do modelo final

# Resíduos deviance padronizados
resid_dev <- resid(m2.2, type = "deviance")
resid_pearson <- resid(m2.2, type = "pearson")
fitted_vals <- fitted(m2.2)

# Configurar layout de 2x2
par(mfrow = c(2, 2))

# 1. Resíduos deviance vs valores ajustados
plot(fitted_vals, resid_dev,
     main = "Resíduos deviance vs Ajustados",
     xlab = "Valores ajustados",
     ylab = "Resíduos deviance",
     pch = 16, col = "grey40")
abline(h = 0, lty = 2, col = "red")

# 2. Q-Q plot dos resíduos deviance
qqnorm(resid_dev,
       main = "Q-Q plot dos resíduos deviance",
       pch = 16, col = "grey40")
qqline(resid_dev, col = "red", lty = 2)

# 3. Scale-Location (variância dos resíduos)
sqrt_abs_resid <- sqrt(abs(resid_dev))
plot(fitted_vals, sqrt_abs_resid,
     main = "Scale-Location",
     xlab = "Valores ajustados",
     ylab = "√|Resíduos deviance|",
     pch = 16, col = "grey40")
abline(h = 0, lty = 2, col = "red")

# 4. Resíduos deviance vs leverage
leverage <- hatvalues(m2.2)
plot(leverage, resid_dev,
     main = "Resíduos deviance vs Leverage",
     xlab = "Leverage",
     ylab = "Resíduos deviance",
     pch = 16, col = "grey40")
abline(h = 0, lty = 2, col = "red")

# Reset layout gráfico
par(mfrow = c(1, 1))

# Distância de Cook (opcional)
plot(cooks.distance(m2.2),
     type = "h",
     main = "Distância de Cook",
     ylab = "Cook's distance",
     col = "firebrick")
abline(h = 4 / nrow(data_brac_na), lty = 2, col = "grey50")

# FIM ---------------------------------------------------------------------


