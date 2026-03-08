# Nuptial coloration in fiddler crabs as an indicator of reproductive quality
# Script for generating graphs of the differences between nuptial and dark carapaces
# Author: Diogo Silva
# Fri Dec 23 17:40:13 2022 ------------------------------

# Packages ----
library(tidyverse)
library(cowplot)
library(ggpubr)
library(car)
library(fitdistrplus)
library(caret)

#1. import data ----
data <- read.csv("data/processed/04_data_master.csv")
glimpse(data)

#2. Analyzing claw type ------------------------------------------------------
#subset of the crab visual model considering only the claw values
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
# GLM for claw weight ----

# Remove NAs from the variable of interest
data_brac_na <- data_brac %>%
  filter(!is.na(weight_mg))

# Final model
m1 <- glm(weight_mg ~ size + carapace_color, 
          family = "gaussian", data = data_brac_na)

car::vif(m1) # Check collinearity
summary(m1)


# Final model diagnostics ----
par(mfrow = c(2, 2))  # Display the 4 standard diagnostic plots
plot(m1)              # Visual diagnostics: residuals, leverage, etc.

# Reset graphical layout (optional)
par(mfrow = c(1, 1))


# Fitting gamma regression ----

# Due to multicollinearity (VIF > 5) between luminance and mean brightness,
# luminance was removed from the model
m2 <- glm(max_force ~ 
              size + 
              carapace_color +
              weight_mg,
            family = Gamma(link = "log"),
            data = data_brac_na)
vif(m2) #it's all good
summary(m2)

# Fitting gamma regression ----

# Due to multicollinearity (VIF > 5) between luminance and mean brightness,
# luminance was removed from the model
m2 <- glm(max_force ~ 
            size + 
            carapace_color +
            weight_mg,
          family = Gamma(link = "log"),
          data = data_brac_na)
vif(m2) #it's all good
summary(m2)

# Final model diagnostics

# Pearson residuals
resid_pearson <- resid(m2, type = "pearson")
fitted_vals <- fitted(m2)

# Set 2x2 layout
par(mfrow = c(2, 2))

# 1. Pearson residuals vs fitted values
plot(fitted_vals, resid_pearson,
     main = "Resíduos de Pearson vs Ajustados",
     xlab = "Valores ajustados",
     ylab = "Resíduos de Pearson",
     pch = 16, col = "grey40")
abline(h = 0, lty = 2, col = "red")

# 2. Q-Q plot Pearson residuals
qqnorm(resid_pearson,
       main = "Q-Q plot dos resíduos de Pearson",
       pch = 16, col = "grey40")
qqline(resid_pearson, col = "red", lty = 2)

# 3. Scale-Location (residual variance)
sqrt_abs_resid <- sqrt(abs(resid_pearson))
plot(fitted_vals, sqrt_abs_resid,
     main = "Scale-Location",
     xlab = "Valores ajustados",
     ylab = "√|Resíduos de Pearson|",
     pch = 16, col = "grey40")
abline(h = 0, lty = 2, col = "red")

# 4. Pearson residuals vs leverage
leverage <- hatvalues(m2)
plot(leverage, resid_pearson,
     main = "Resíduos de Pearson vs Leverage",
     xlab = "Leverage",
     ylab = "Resíduos de Pearson",
     pch = 16, col = "grey40")
abline(h = 0, lty = 2, col = "red")

# Reset graphical layout
par(mfrow = c(1, 1))

# cooks distances (opcional)
plot(cooks.distance(m2),
     type = "h",
     main = "Distância de Cook",
     ylab = "Cook's distance",
     col = "firebrick")
abline(h = 4 / nrow(data_brac_na), lty = 2, col = "grey50")


# THE END ---------------------------------------------------------------------


