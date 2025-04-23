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

reflet_nup_cara <- read.csv("data/processed/01_reflet_nup_carapace_type.csv")
reflet_nup_cara <- fixspec(reflet_nup_cara)

reflet_nup_claw <- read.csv("data/processed/01_reflet_nup_claw_color.csv")
reflet_nup_claw <- fixspec(reflet_nup_claw)

#Plot means - claw ----
claw <- reflet_nup_claw %>%
  rowwise() %>%
  
  mutate(media1 = mean(c_across(contains("Bright")), na.rm = TRUE),
         sd1 = sd(c_across(contains("Bright")), na.rm = TRUE)) %>%
  
  mutate(media2 = mean(c_across(contains("Dark")), na.rm = TRUE),
         sd2 = sd(c_across(contains("Dark")), na.rm = TRUE)) %>%
  
  ungroup() %>%
  
  ggplot(aes(x = wl)) +
  
  geom_ribbon(aes(ymin = media1 - sd1, ymax = media1 + sd1, fill = "Bright"), alpha = 0.3, show.legend = FALSE) +
  geom_line(aes(y = media1, color = "Bright"), size = 1.5) +
  
  geom_ribbon(aes(ymin = media2 - sd2, ymax = media2 + sd2, fill = "Dark"), alpha = 0.3, show.legend = FALSE) +
  geom_line(aes(y = media2, color = "Dark"), size = 1.5) +
  
  scale_fill_manual(values = c("Bright" = "#ffb560", 
                               "Dark" = "#404244"),name = "Groups") +
  scale_color_manual(values = c("Bright" = "#ffb560", 
                                "Dark" = "#404244"), name = "Groups") +
  labs(x = "Wavelenght (nm)",
       y = "Reflectance (%)") +
  theme_classic(base_size = 14)+
  theme(legend.position = "top")+
  geom_text(x = 500, y = 65, label = "Claw", color = "black", size = 4)
claw

#Plot means - carapace ----
cara <- reflet_nup_cara %>%
  rowwise() %>%
  
  mutate(media1 = mean(c_across(contains("Bright")), na.rm = TRUE),
         sd1 = sd(c_across(contains("Bright")), na.rm = TRUE)) %>%
  
  mutate(media2 = mean(c_across(contains("Dark")), na.rm = TRUE),
         sd2 = sd(c_across(contains("Dark")), na.rm = TRUE)) %>%
  
  ungroup() %>%
  
  ggplot(aes(x = wl)) +
  
  geom_ribbon(aes(ymin = media1 - sd1, ymax = media1 + sd1, fill = "Bright"), alpha = 0.3, show.legend = FALSE) +
  geom_line(aes(y = media1, color = "Bright"), size = 1.5) +
  
  geom_ribbon(aes(ymin = media2 - sd2, ymax = media2 + sd2, fill = "Dark"), alpha = 0.3, show.legend = FALSE) +
  geom_line(aes(y = media2, color = "Dark"), size = 1.5) +
  
  scale_fill_manual(values = c("Bright" = "#ffb560", 
                               "Dark" = "#404244"),name = "Groups") +
  scale_color_manual(values = c("Bright" = "#ffb560", 
                                "Dark" = "#404244"), name = "Groups") +
  labs(x = "Wavelenght (nm)",
       y = "Reflectance (%)") +
  theme_classic(base_size = 14)+
  theme(legend.position = "top")+
  geom_text(x = 500, y = 42, label = "Carapace", color = "black", size = 4)
cara

#Colspace ----
sens_uca <- pavo::sensmodel(c(430, 520), range = c(300, 700))
sens_uca <- pavo::as.rspec(sens_uca, lim =c(300, 700))
transmit <- transmit #from colorspec package

cara_qi   <- pavo::vismodel(reflet_nup_cara, qcatch = "Qi", 
                            visual = sens_uca, 
                            achromatic = "l",
                            illum = "D65",
                            trans = "ideal", 
                            scale = 1, 
                            relative = T)

claw_qi   <- pavo::vismodel(reflet_nup_claw, qcatch = "Qi", 
                            visual = sens_uca, 
                            achromatic = "l",
                            illum = "D65",
                            trans = "ideal", 
                            scale = 1, 
                            relative = T)

#Dichromatic Colspace ----
colspace_cara <- colspace(cara_qi, space = "di")
colspace_cara$ID <- rownames(colspace_cara)

colspace_claw <- colspace(claw_qi, space = "di")
colspace_claw$ID <- rownames(colspace_claw)

plot(colspace_cara, 
     cex = 1.5, 
     col = ifelse(grepl("Bright", colspace_cara$ID), "#ffb560","#404244"))
plot(colspace_claw, 
     cex = 1.5,
     col = ifelse(grepl("Bright", colspace_claw$ID), "#ffb560","#404244"))

# Colorimetrics ----
b2 <- ggplot(data_brac, aes(carapace_color, mean_brightness, fill = carapace_color))+
  stat_halfeye(alpha = 0.5, justification = 0, width = 0.5, .width = 0, adjust = 0.8)+
  stat_dots(aes(color = carapace_color),side = "left",justification = 1, binwidth = 1.1)+
  geom_boxplot(width = 0.15, show.legend = F, fill = "white")+
  scale_fill_manual(values=c("#ffb560","#404244"))+
  scale_color_manual(values=c("#ffb560","#404244"))+
  labs(x = "",
       y = "Mean brightness")+
  theme_classic(base_size = 14)+
  theme(legend.position = "none")+
  facet_grid(~body_region)+
  geom_text(data = data_brac, 
            aes(x = 1.5, y = 65, label = "*"), color = "black", size = 6)
b2

sat <- ggplot(data_brac, aes(carapace_color, saturation, fill = carapace_color))+
  stat_halfeye(alpha = 0.5, justification = 0, width = 0.5, .width = 0, adjust = 0.8)+
  stat_dots(aes(color = carapace_color),side = "left",justification = 1, binwidth = 0.04)+
  geom_boxplot(width = 0.15, show.legend = F, fill = "white")+
  scale_fill_manual(values=c("#ffb560","#404244"))+
  scale_color_manual(values=c("#ffb560","#404244"))+
  labs(x = "",
       y = "Saturation")+
  theme_classic(base_size = 14)+
  theme(legend.position = "none")+
  facet_grid(~body_region)
sat

#Figure 3 ----
ds <- ggplot(data_brac, aes(carapace_color, chromatic_contrast, fill = carapace_color))+
  stat_halfeye(alpha = 0.5, justification = 0, width = 0.5, .width = 0, adjust = 0.8)+
  stat_dots(aes(color = carapace_color),side = "left",justification = 1, binwidth = 0.05)+
  geom_boxplot(width = 0.15, show.legend = F, fill = "white")+
  scale_fill_manual(values=c("#ffb560","#404244"))+
  scale_color_manual(values=c("#ffb560","#404244"))+
  labs(x = "",
       y = "Chromatic contrast (JND)")+
  theme_classic(base_size = 11)+
  theme(legend.position = "none")+
  facet_grid(~body_region)
ds 

dl <- ggplot(data_brac, aes(carapace_color, achromatic_contrast, fill = carapace_color))+
  stat_halfeye(alpha = 0.5, justification = 0, width = 0.5, .width = 0, adjust = 0.8)+
  stat_dots(aes(color = carapace_color),side = "left",justification = 1, binwidth = 0.03)+
  geom_boxplot(width = 0.15, show.legend = F, fill = "white")+
  scale_fill_manual(values=c("#ffb560","#404244"))+
  scale_color_manual(values=c("#ffb560","#404244"))+
  labs(x = "",
       y = "Achromatic contrast (JND)")+
  theme_classic(base_size = 11)+
  theme(legend.position = "none")+
  facet_grid(~body_region)+
  geom_text(aes(x = 1.5, y = 2.5, label = "*"), color = "black", size = 6)
dl 

#plot grid ----
p <- plot_grid(claw,cara,
               ncol = 2,
               align = "v",
               label_size = 15)
p

p2 <- plot_grid(p,
                b2, sat,
                ncol = 1,
                labels = "AUTO",
                align = "vh",
                label_size = 15)
p2

p3 <- plot_grid(ds, dl,
                ncol = 1,
                labels = "AUTO",
                align = "vh",
                label_size = 14)
p3

#Saving plots ----

#reflectances ----
ggsave(plot = p, 
       filename = "outputs/figures/figure_1.png",
       width = 6, 
       height = 2.8, 
       dpi = 300)

ggsave(plot = p2, 
       filename = "outputs/figures/figure_2.png",
       width = 6, 
       height = 8, 
       dpi = 300)

ggsave(plot = p3, 
       filename = "outputs/figures/figure_3.png",
       width = 5, 
       height = 5, 
       dpi = 300)

#Colspaces ----
png(file = "outputs/figures/01_colspace_cara.png",
    units = "in",
    res = 300,
    width = 4.5,
    height = 4)

plot(colspace_cara, cex = 1.5, 
     col = ifelse(grepl("Bright", colspace_cara$ID), "#ffb560","#404244"))

dev.off()

png(file = "outputs/figures/01_colspace_claw.png",
    units = "in",
    res = 300,
    width = 4.5,
    height = 4)

plot(colspace_claw, cex = 1.5, 
     col = ifelse(grepl("Bright", colspace_claw$ID), "#ffb560","#404244"))

dev.off()

#THE END ----
