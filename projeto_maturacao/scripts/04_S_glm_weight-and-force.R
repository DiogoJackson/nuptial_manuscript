#Script para fazer os graficos das diferenças de carapaça nupcial e escura
#Author: Diogo Silva
# Tue Sep  9 11:10:31 2025 ------------------------------

#Packages ----
library(tidyverse)
library(cowplot)
library(colorspec)
library(pavo)
library(ggpubr)
library(ggdist)

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



p1 <- ggplot(data.b, aes(carapace_type, weight_mg, fill = carapace_type))+
  stat_halfeye(alpha = 0.5, justification = 0, width = 0.5, .width = 0, adjust = 1)+
  stat_dots(aes(color = carapace_type),side = "left",justification = 1, binwidth = 2)+
  geom_boxplot(width = 0.15, show.legend = F, fill = "white")+
  scale_fill_manual(values=c("#ffb560","grey30"))+
  scale_color_manual(values=c("#ffb560","grey30"))+
  labs(x = "Carapace color",
       y = "Claw mass (mg)")+
  theme_classic(base_size = 24)+
  theme(legend.position = "none")+
  annotate("text", x = 1.5, y = 60, label = "*", size = 10)
p1

p2 <- ggplot(data.b, aes(carapace_type, max_force, fill = carapace_type))+
  stat_halfeye(alpha = 0.5, justification = 0, width = 0.5, .width = 0, adjust = 1)+
  stat_dots(aes(color = carapace_type),side = "left",justification = 1, binwidth = 0.5)+
  geom_boxplot(width = 0.15, show.legend = F, fill = "white")+
  scale_fill_manual(values=c("#ffb560","grey30"))+
  scale_color_manual(values=c("#ffb560","grey30"))+
  labs(x = "Carapace color",
       y = "Maximum force (N)")+
  theme_classic(base_size = 24)+
  theme(legend.position = "none")
p2

p3 <- ggplot(data.b, aes(size, weight_mg))+ #a variavel weight_g possivelmente eh weight_mg
  geom_point(alpha = 0.6, size = 5)+
  geom_smooth(method = "glm", se = FALSE, size = 3, color = "orange", linetype = "dashed")+
  labs(x = "Claw size (mm)",
       y = "Claw mass (mg)")+
  theme_classic(base_size = 24)
p3

p4 <- ggplot(data.b, aes(x = weight_mg, y = max_force)) +
  geom_point(alpha = 0.6, size = 5) +
  geom_smooth(method = "glm", se = FALSE, size = 3, color = "orange", linetype = "dashed") +
  scale_color_manual(values = c("#ffb560", "#404244")) +
  labs(
    x = "Claw mass (mg)",
    y = "Maximum force (N)",
    color = "Carapace color",
    size = "Claw size (mm)"
  ) +
  theme_classic(base_size = 24)
p4

p5 <- ggplot(data.b, aes(x = max_force, y = size)) +
  geom_point(alpha = 0.6, size = 5) +
  geom_smooth(method = "glm", se = FALSE, size = 3, color = "orange", linetype = "dashed") +
  scale_color_manual(values = c("#ffb560", "#404244")) +
  labs(
    x = "Claw size (mm)",
    y = "Maximum force (N)") +
  theme_classic(base_size = 24)
p5

#Figure 1 ----
fig3 <- plot_grid(p1, p2, p3, p4, p5,
                  ncol = 2,
                  labels = "AUTO",
                  align = "AUTO",
                  label_size = 22)
fig3

#Save plots ----
ggsave(plot = fig3, 
       filename = "outputs/figures/Figure_3_morphofunctional-traits.png",
       width = 14, 
       height = 18, 
       dpi = 300)

# FIM ---------------------------------------------------------------------

