#Script para fazer os graficos das diferenças de carapaça nupcial e escura
#Author: Diogo Silva
# Fri Dec 23 17:40:13 2022 ------------------------------

#Packages ----
library(tidyverse)
library(cowplot)
library(ggpubr)
library(colorspec)
library(pavo)

#1. import data ----
data <- read.csv("data/processed/04_data_master.csv")
head(data)
str(data)

#2. Analisando tipo de quela ------------------------------------------------------
#subset da modelagem visual do caranguejo considerando apenas os valores de quela
data_brac <- data %>% 
  filter(vismodel == "Fiddler crab") %>% 
  filter(body_region == "Claw") %>% 
  filter(claw_type == "Brachychelous")

data_cara <- data %>% 
  filter(vismodel == "Fiddler crab") %>% 
  filter(body_region == "Carapace") %>% 
  filter(claw_type == "Brachychelous")

#Show ----
data.b <- data_brac %>% 
  filter(body_region == "Claw") %>%
  filter(carapace_type != "Real") %>% #retirar os animais que foram medidos em campo e nao possuem medicao de forca, peso, etc.
  dplyr::mutate(force.b = max_force/(max(max_force) + 0.001)) %>% 
  mutate(carapace_type = fct_recode(carapace_type,
                                    "Dark" = "Dark",
                                    "White" = "Bright"))

weight_str_size <- ggplot(data.b, aes(weight_mg, size, color = carapace_type))+ #a variavel weight_g possivelmente eh weight_mg
  geom_point(alpha = 0.7, size = 4)+
  geom_smooth(method = "glm", se = FALSE, size = 1.5)+
  scale_color_manual(values = c("#ffb560", 
                                "#404244"))+
  labs(x = "Claw mass (mg)",
       y = "Claw size (mm)",
       color = "Carapace color")+
  theme_classic(base_size = 24)
weight_str_size

str_weight_size <- ggplot(data.b, aes(x = weight_mg, y = max_force, color = carapace_type, size = size)) +
  geom_point(alpha = 0.7) +
  geom_smooth(method = "glm", se = FALSE, size = 1.5) +
  scale_color_manual(values = c("#ffb560", "#404244")) +
  labs(
    x = "Claw mass (mg)",
    y = "Maximum force (N)",
    color = "Carapace color",
    size = "Claw size (mm)"
  ) +
  theme_classic(base_size = 24)
str_weight_size


#Figure 1 ----
fig3 <- plot_grid(weight_str_size, str_weight_size,
                  ncol = 1,
                  labels = "AUTO",
                  align = "vh",
                  label_size = 15)
fig3

#Save plots ----
ggsave(plot = fig3, 
       filename = "outputs/figures/Figure_3_clawmass.png",
       width = 8.5, 
       height = 10, 
       dpi = 300)

