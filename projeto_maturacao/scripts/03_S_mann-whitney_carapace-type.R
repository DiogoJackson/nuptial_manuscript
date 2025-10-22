# Color signal comparation - bright vs dark carapace
# Author: Diogo J. A. Silva
# Date:
# Fri Sep 13 10:32:12 2024 ------------------------------
# Last update:
# Sun Sep 29 17:02:17 2024 ------------------------------

# Packages ----------------------------------------------------------------
library(pavo)
library(colorspec)
library(tidyverse)
library(cowplot)
library(ggpubr)
library(ggdist)

# Import data -------------------------------------------------------------
data <- read.csv("data/processed/04_data_master.csv")

data_cara <- data %>% 
  filter(vismodel == "Fiddler crab") %>% 
  filter(body_region == "Carapace") %>% 
  filter(claw_type == "Brachychelous")

data_claw <- data %>% 
  filter(vismodel == "Fiddler crab") %>% 
  filter(body_region == "Claw") %>% 
  filter(claw_type == "Brachychelous")

data_brac <- data %>% 
  filter(vismodel == "Fiddler crab") %>% 
  filter(claw_type == "Brachychelous")

reflet_cara <- read.csv("data/processed/01_reflet_carapace_type.csv")
reflet_cara <- fixspec(reflet_cara)

reflet_claw <- read.csv("data/processed/01_reflet_claw_color.csv")
reflet_claw <- fixspec(reflet_claw)

#Plot means - claw ----
claw <- reflet_claw %>%
  rowwise() %>%
  
  mutate(media1 = mean(c_across(contains("Real")), na.rm = TRUE),
         sd1 = sd(c_across(contains("Real")), na.rm = TRUE)) %>%
  
  mutate(media2 = mean(c_across(contains("Dark")), na.rm = TRUE),
         sd2 = sd(c_across(contains("Dark")), na.rm = TRUE)) %>%
  
  ungroup() %>%
  
  ggplot(aes(x = wl)) +
  
  geom_ribbon(aes(ymin = media1 - sd1, ymax = media1 + sd1, fill = "White"), alpha = 0.3, show.legend = FALSE) +
  geom_line(aes(y = media1, color = "White"), size = 1) +
  
  geom_ribbon(aes(ymin = media2 - sd2, ymax = media2 + sd2, fill = "Dark"), alpha = 0.3, show.legend = FALSE) +
  geom_line(aes(y = media2, color = "Dark"), size = 1) +
  
  scale_fill_manual(values = c("White" = "#ffb560", 
                               "Dark" = "black"), name = "") +
  scale_color_manual(values = c("White" = "#ffb560", 
                                "Dark" = "black"), name = "") +
  labs(x = "Wavelenght (nm)",
       y = "Reflectance (%)") +
  theme_classic(base_size = 11) +
  theme(legend.position = "top") +
  geom_text(x = 500, y = 55, label = "Claw", color = "black", size = 4)
claw

#Plot means - carapace ----
cara <- reflet_cara %>%
  rowwise() %>%
  
  mutate(media1 = mean(c_across(contains("Real")), na.rm = TRUE),
         sd1 = sd(c_across(contains("Real")), na.rm = TRUE)) %>%
  
  mutate(media2 = mean(c_across(contains("Dark")), na.rm = TRUE),
         sd2 = sd(c_across(contains("Dark")), na.rm = TRUE)) %>%
  
  ungroup() %>%
  
  ggplot(aes(x = wl)) +
  
  geom_ribbon(aes(ymin = media1 - sd1, ymax = media1 + sd1, fill = "White"), alpha = 0.3, show.legend = FALSE) +
  geom_line(aes(y = media1, color = "White"), size = 1) +
  
  geom_ribbon(aes(ymin = media2 - sd2, ymax = media2 + sd2, fill = "Dark"), alpha = 0.3, show.legend = FALSE) +
  geom_line(aes(y = media2, color = "Dark"), size = 1) +
  
  scale_fill_manual(values = c("White" = "#ffb560", 
                               "Dark" = "black"), name = "") +
  scale_color_manual(values = c("White" = "#ffb560", 
                                "Dark" = "black"), name = "") +
  labs(x = "Wavelenght (nm)",
       y = "Reflectance (%)") +
  theme_classic(base_size = 11) +
  theme(legend.position = "top") +
  geom_text(x = 400, y = 50, label = "Carapace", color = "black", size = 4)
cara

# Colorimetrics ----
data_brac2 <- data_brac %>%
  mutate(carapace_type = fct_recode(carapace_type,
                                    "White" = "Real",
                                    "Dark" = "Dark",
                                    "Darkened white" = "Bright")) %>% 
  filter(carapace_type != "Darkened white")

#Figure 3 ----
s <- ggplot(data_brac2, aes(carapace_type, s, fill = carapace_type))+
  stat_halfeye(alpha = 0.5, justification = 0, width = 0.5, .width = 0, adjust = 1)+
  stat_dots(aes(color = carapace_type),side = "left",justification = 1, binwidth = 0.006)+
  geom_boxplot(width = 0.15, show.legend = F, fill = "white")+
  scale_fill_manual(values=c("grey30","#ffb560"))+
  scale_color_manual(values=c("grey30","#ffb560"))+
  labs(x = "Carapace color",
       y = "Quantum catch (S-receptor)")+
  theme_classic(base_size = 11)+
  theme(legend.position = "none")+
  facet_grid(~body_region)
s 

m <- ggplot(data_brac2, aes(carapace_type, m, fill = carapace_type))+
  stat_halfeye(alpha = 0.5, justification = 0, width = 0.5, .width = 0, adjust = 1)+
  stat_dots(aes(color = carapace_type),side = "left",justification = 1, binwidth = 0.009)+
  geom_boxplot(width = 0.15, show.legend = F, fill = "white")+
  scale_fill_manual(values=c("grey30","#ffb560"))+
  scale_color_manual(values=c("grey30","#ffb560"))+
  labs(x = "Carapace color",
       y = "Quantum catch (M-receptor)")+
  theme_classic(base_size = 11)+
  theme(legend.position = "none")+
  facet_grid(~body_region)
m

#plot grid ----
p <- plot_grid(claw,cara,
               ncol = 2,
               align = "v",
               label_size = 15)
p

p2 <- plot_grid(p,
                s, m,
               ncol = 1,
               labels = "AUTO",
               align = "vh",
               label_size = 15)
p2

#Saving plots ----

#reflectances ----
ggsave(plot = p2, 
       filename = "outputs/figures/Figure_2_vismodel.png",
       width = 6, 
       height = 8, 
       dpi = 300)


# FIM ---------------------------------------------------------------------


