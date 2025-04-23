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
  
  mutate(media3 = mean(c_across(contains("Bright")), na.rm = TRUE),
         sd3 = sd(c_across(contains("Bright")), na.rm = TRUE)) %>%
  
  ungroup() %>%
  
  ggplot(aes(x = wl)) +
  
  geom_ribbon(aes(ymin = media1 - sd1, ymax = media1 + sd1, fill = "Branco"), alpha = 0.3, show.legend = FALSE) +
  geom_line(aes(y = media1, color = "Branco"), size = 1) +
  
  geom_ribbon(aes(ymin = media2 - sd2, ymax = media2 + sd2, fill = "Escuro"), alpha = 0.3, show.legend = FALSE) +
  geom_line(aes(y = media2, color = "Escuro"), size = 1) +
  
  geom_ribbon(aes(ymin = media3 - sd3, ymax = media3 + sd3, fill = "Branco escurecido"), alpha = 0.3, show.legend = FALSE) +
  geom_line(aes(y = media3, color = "Branco escurecido"), size = 1) +
  
  scale_fill_manual(values = c("Branco" = "#ffb560", 
                               "Escuro" = "black",
                               "Branco escurecido" = "grey30"), name = "") +
  scale_color_manual(values = c("Branco" = "#ffb560", 
                                "Escuro" = "black",
                                "Branco escurecido" = "grey30"), name = "") +
  labs(x = "Comprimento de onda (nm)",
       y = "Refletância (%)") +
  theme_classic(base_size = 14) +
  theme(legend.position = "top") +
  geom_text(x = 500, y = 55, label = "Quela", color = "black", size = 4)
claw


#Plot means - carapace ----
cara <- reflet_cara %>%
  rowwise() %>%
  
  mutate(media1 = mean(c_across(contains("Real")), na.rm = TRUE),
         sd1 = sd(c_across(contains("Real")), na.rm = TRUE)) %>%
  
  mutate(media2 = mean(c_across(contains("Dark")), na.rm = TRUE),
         sd2 = sd(c_across(contains("Dark")), na.rm = TRUE)) %>%
  
  mutate(media3 = mean(c_across(contains("Bright")), na.rm = TRUE),
         sd3 = sd(c_across(contains("Bright")), na.rm = TRUE)) %>%
  
  ungroup() %>%
  
  ggplot(aes(x = wl)) +
  
  geom_ribbon(aes(ymin = media1 - sd1, ymax = media1 + sd1, fill = "Branco"), alpha = 0.3, show.legend = FALSE) +
  geom_line(aes(y = media1, color = "Branco"), size = 1) +
  
  geom_ribbon(aes(ymin = media2 - sd2, ymax = media2 + sd2, fill = "Escuro"), alpha = 0.3, show.legend = FALSE) +
  geom_line(aes(y = media2, color = "Escuro"), size = 1) +
  
  geom_ribbon(aes(ymin = media3 - sd3, ymax = media3 + sd3, fill = "Branco escurecido"), alpha = 0.3, show.legend = FALSE) +
  geom_line(aes(y = media3, color = "Branco escurecido"), size = 1) +
  
  scale_fill_manual(values = c("Branco" = "#ffb560", 
                               "Escuro" = "black",
                               "Branco escurecido" = "grey30"), name = "") +
  scale_color_manual(values = c("Branco" = "#ffb560", 
                                "Escuro" = "black",
                                "Branco escurecido" = "grey30"), name = "") +
  labs(x = "Comprimento de onda (nm)",
       y = "Refletância (%)") +
  theme_classic(base_size = 14) +
  theme(legend.position = "top") +
  geom_text(x = 400, y = 50, label = "Carapaça", color = "black", size = 4)
cara


#Colspace ----
sens_uca <- pavo::sensmodel(c(430, 520), range = c(300, 700))
sens_uca <- pavo::as.rspec(sens_uca, lim =c(300, 700))
transmit <- transmit #from colorspec package

cara_qi   <- pavo::vismodel(reflet_cara, qcatch = "Qi", 
                            visual = sens_uca, 
                            achromatic = "l",
                            illum = "D65",
                            trans = "ideal", 
                            scale = 1, 
                            relative = T)

claw_qi   <- pavo::vismodel(reflet_claw, qcatch = "Qi", 
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
data_brac2 <- data_brac %>%
  mutate(carapace_type = fct_recode(carapace_type,
                                    "Branco" = "Real",
                                    "Escuro" = "Dark",
                                    "Branco escurecido" = "Bright")) %>% 
  mutate(body_region = fct_recode(body_region,
                                  "Carapaça" = "Carapace",
                                  "Quela" = "Claw"))

b2 <- ggplot(data_brac2, aes(carapace_type, mean_brightness, fill = carapace_type))+
  stat_halfeye(alpha = 0.5, justification = 0, width = 0.5, .width = 0, adjust = 0.8)+
  stat_dots(aes(color = carapace_type),side = "left",justification = 1, binwidth = 1.1)+
  geom_boxplot(width = 0.15, show.legend = F, fill = "white")+
  scale_fill_manual(values=c("grey30","black","#ffb560"))+
  scale_color_manual(values=c("grey30","black","#ffb560"))+
  scale_x_discrete(labels = c("Branco escurecido" = "Branco\nescurecido", 
                              "Escuro" = "Escuro", 
                              "Branco" = "Branco"))+
  labs(x = "",
       y = "Brilho médio")+
  theme_classic(base_size = 14)+
  theme(legend.position = "none")+
  facet_grid(~body_region)+
  scale_y_continuous(limits = c(0, 80))
b2

sat <- ggplot(data_brac2, aes(carapace_type, saturation, fill = carapace_type))+
  stat_halfeye(alpha = 0.5, justification = 0, width = 0.5, .width = 0, adjust = 0.8)+
  stat_dots(aes(color = carapace_type),side = "left",justification = 1, binwidth = 0.04)+
  geom_boxplot(width = 0.15, show.legend = F, fill = "white")+
  scale_fill_manual(values=c("grey30","black","#ffb560"))+
  scale_color_manual(values=c("grey30","black","#ffb560"))+
  scale_x_discrete(labels = c("Branco escurecido" = "Branco\nescurecido", 
                              "Escuro" = "Escuro", 
                              "Branco" = "Branco"))+
  labs(x = "",
       y = "Saturação")+
  theme_classic(base_size = 14)+
  theme(legend.position = "none")+
  facet_grid(~body_region)+
  scale_y_continuous(limits = c(0, 2.5))
sat

#Figure 3 ----
ds <- ggplot(data_brac2, aes(carapace_type, chromatic_contrast, fill = carapace_type))+
  geom_hline(yintercept = 1, linetype = "dashed", color = "grey", size = 0.5)+
  geom_hline(yintercept = 3, linetype = "dashed", color = "grey", size = 0.5)+
  stat_halfeye(alpha = 0.5, justification = 0, width = 0.5, .width = 0, adjust = 1)+
  stat_dots(aes(color = carapace_type),side = "left",justification = 1, binwidth = 0.07)+
  geom_boxplot(width = 0.15, show.legend = F, fill = "white")+
  scale_fill_manual(values=c("grey30","black","#ffb560"))+
  scale_color_manual(values=c("grey30","black","#ffb560"))+
  scale_x_discrete(labels = c("Branco escurecido" = "Branco\nescurecido", 
                              "Escuro" = "Escuro", 
                              "Branco" = "Branco"))+
  labs(x = "",
       y = "Contraste cromático (JND)")+
  theme_classic(base_size = 11)+
  theme(legend.position = "none")+
  facet_grid(~body_region)+
  scale_y_continuous(limits = c(0, 4.5))
ds 

dl <- ggplot(data_brac2, aes(carapace_type, achromatic_contrast, fill = carapace_type))+
  geom_hline(yintercept = 1, linetype = "dashed", color = "grey", size = 0.5)+
  geom_hline(yintercept = 3, linetype = "dashed", color = "grey", size = 0.5)+
  stat_halfeye(alpha = 0.5, justification = 0, width = 0.5, .width = 0, adjust = 1)+
  stat_dots(aes(color = carapace_type),side = "left",justification = 1, binwidth = 0.04)+
  geom_boxplot(width = 0.15, show.legend = F, fill = "white")+
  scale_fill_manual(values=c("grey30","black","#ffb560"))+
  scale_color_manual(values=c("grey30","black","#ffb560"))+
  scale_x_discrete(labels = c("Branco escurecido" = "Branco\nescurecido", 
                              "Escuro" = "Escuro", 
                              "Branco" = "Branco"))+
  labs(x = "",
       y = "Contraste acromático (JND)")+
  theme_classic(base_size = 11)+
  theme(legend.position = "none")+
  facet_grid(~body_region)+
  scale_y_continuous(limits = c(0, 2.5))
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
       filename = "outputs/figures/figure_1_pt.png",
       width = 7, 
       height = 3.5, 
       dpi = 300)

ggsave(plot = p2, 
       filename = "outputs/figures/figure_2_pt.png",
       width = 7.5, 
       height = 8.5, 
       dpi = 300)

ggsave(plot = p3, 
       filename = "outputs/figures/figure_3_pt.png",
       width = 5, 
       height = 5.5, 
       dpi = 300)

#Colspaces ----
png(file = "outputs/figures/01_colspace_cara_pt.png",
    units = "in",
    res = 300,
    width = 4.5,
    height = 4)

plot(colspace_cara, cex = 1.5, 
     col = ifelse(grepl("Bright", colspace_cara$ID), "#ffb560","#404244"))

dev.off()

png(file = "outputs/figures/01_colspace_claw_pt.png",
    units = "in",
    res = 300,
    width = 4.5,
    height = 4)

plot(colspace_claw, cex = 1.5, 
     col = ifelse(grepl("Bright", colspace_claw$ID), "#ffb560","#404244"))

dev.off()

#THE END ----
