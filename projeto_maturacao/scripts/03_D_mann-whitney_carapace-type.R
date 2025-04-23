# Statitics color signal comparation
# Author: Diogo J. A. Silva
# Date:
# Tue Sep 17 16:32:11 2024 ------------------------------
# Last update:
# Mon Nov 18 14:53:42 2024 ------------------------------

# Packages ----------------------------------------------------------------
library(tidyverse)
library(rstatix)
library(broom)

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

data %>% 
  filter(vismodel == "Fiddler crab") %>% 
  filter(body_region == "Carapace") %>% 
  filter(claw_type == "Brachychelous") %>% 
  count(carapace_type)

# Teste de normalidade ----

# Size ----
sw_size <- data_brac %>% 
  dplyr::group_by(carapace_color, body_region) %>% 
  rstatix::shapiro_test(size)

# Mean brightness ----
sw_brightness <- data_brac %>% 
  dplyr::group_by(carapace_color, body_region) %>% 
  shapiro_test(mean_brightness)

# Saturation
sw_saturation <- data_brac %>% 
  dplyr::group_by(carapace_color, body_region) %>% 
  shapiro_test(saturation)

#Chromatic contrast (dS) ----
sw_ds <- data_brac %>% 
  dplyr::group_by(carapace_color, body_region) %>% 
  shapiro_test(chromatic_contrast)

#Achromatic contrast (dL) ----
sw_dl <- data_brac %>% 
  dplyr::group_by(carapace_color, body_region) %>% 
  shapiro_test(achromatic_contrast)

shapiro_table <- bind_rows(sw_size,
                           sw_brightness,
                           sw_saturation,
                           sw_ds,
                           sw_dl
                           ) %>% 
  mutate(distribution = if_else(p > 0.05, 
                          "normal", 
                          "non-normal"))
shapiro_table

#Considering the non-normal distribution of data we are going to use
#Mann-whitney test

#Comparing Bright males and Dark males ----

#Size ----
# boxplot(data_claw$size ~ data_claw$carapace_color)
# claw_size <- kruskal.test(data_claw$size ~ data_claw$carapace_color)
# claw_size
# 
# boxplot(data_cara$size ~ data_cara$carapace_color)
# cara_size <- kruskal.test(data_cara$size ~ data_cara$carapace_color)
# cara_size

#Mean brightness ----
boxplot(data_claw$mean_brightness ~ data_claw$carapace_color)
claw_b2 <- kruskal.test(data_claw$mean_brightness ~ data_claw$carapace_color)
claw_b2

posthoc_claw_b2 <- data_claw %>%
  dunn_test(mean_brightness ~ carapace_color, p.adjust.method = "bonferroni")
posthoc_claw_b2

boxplot(data_cara$mean_brightness ~ data_cara$carapace_color)
cara_b2 <- kruskal.test(data_cara$mean_brightness ~ data_cara$carapace_color)
cara_b2

posthoc_cara_b2 <- data_cara %>%
  dunn_test(mean_brightness ~ carapace_color, p.adjust.method = "bonferroni")
posthoc_cara_b2

#Saturation ----
boxplot(data_claw$saturation ~ data_claw$carapace_color)
claw_sat <- kruskal.test(data_claw$saturation ~ data_claw$carapace_color)
claw_sat

posthoc_claw_sat <- data_claw %>%
  dunn_test(saturation ~ carapace_color, p.adjust.method = "bonferroni")
posthoc_claw_sat

boxplot(data_cara$saturation ~ data_cara$carapace_color)
cara_sat <- kruskal.test(data_cara$saturation ~ data_cara$carapace_color)
cara_sat

posthoc_cara_sat <- data_cara %>%
  dunn_test(saturation ~ carapace_color, p.adjust.method = "bonferroni")
posthoc_cara_sat

#Chromatic contrast ----
#Porcentagem da conspicuidade

#Claw
data_claw2 <- data_claw %>%
  group_by(carapace_type) %>% 
  summarise(claw_consp_percentage = sum(chromatic_contrast > 1) / n() * 100)
data_claw2

data_claw2.2 <- data_claw %>%
  group_by(carapace_type) %>% 
  summarise(claw_consp_percentage = sum(chromatic_contrast > 3) / n() * 100)
data_claw2.2

boxplot(data_claw$chromatic_contrast ~ data_claw$carapace_color)
claw_ds <- kruskal.test(data_claw$chromatic_contrast ~ data_claw$carapace_color)
claw_ds

#Carapace
data_cara2 <- data_cara %>%
  group_by(carapace_type) %>% 
  summarise(cara_consp_percentage = sum(chromatic_contrast > 1) / n() * 100)
data_cara2

boxplot(data_cara$chromatic_contrast ~ data_cara$carapace_color)
cara_ds <- kruskal.test(data_cara$chromatic_contrast ~ data_cara$carapace_color)
cara_ds

posthoc_cara_ds <- data_cara %>%
  dunn_test(chromatic_contrast ~ carapace_color, p.adjust.method = "bonferroni")
posthoc_cara_ds

#Achromatic contrast ----
boxplot(data_claw$achromatic_contrast ~ data_claw$carapace_color)
claw_dl <- kruskal.test(data_claw$achromatic_contrast ~ data_claw$carapace_color)
claw_dl

posthoc_claw_dl <- data_claw %>%
  dunn_test(achromatic_contrast ~ carapace_color, p.adjust.method = "bonferroni")
posthoc_claw_dl

boxplot(data_cara$achromatic_contrast ~ data_cara$carapace_color)
cara_dl <- kruskal.test(data_cara$achromatic_contrast ~ data_cara$carapace_color)
cara_dl

posthoc_cara_dl <- data_cara %>%
  dunn_test(achromatic_contrast ~ carapace_color, p.adjust.method = "bonferroni")
posthoc_cara_dl

#Converting tables ----
table_claw_size <- broom::tidy(claw_size) %>% 
  mutate(body_region = "Claw") %>% 
  mutate(variable = "Size") %>% 
  mutate(comparation = "Bright_vs_Dark")

table_cara_size <- broom::tidy(cara_size)%>% 
  mutate(body_region = "Carapace") %>% 
  mutate(variable = "Size") %>% 
  mutate(comparation = "Bright_vs_Dark")

table_claw_b2 <- broom::tidy(claw_b2)%>% 
  mutate(body_region = "Claw") %>% 
  mutate(variable = "Mean_brightness") %>% 
  mutate(comparation = "Bright_vs_Dark")

table_cara_b2 <- broom::tidy(cara_b2)%>% 
  mutate(body_region = "Carapace") %>% 
  mutate(variable = "Mean_brightness") %>% 
  mutate(comparation = "Bright_vs_Dark")

table_claw_sat <- broom::tidy(claw_sat)%>% 
  mutate(body_region = "Claw") %>% 
  mutate(variable = "Saturation") %>% 
  mutate(comparation = "Bright_vs_Dark")

table_cara_sat <- broom::tidy(cara_sat)%>% 
  mutate(body_region = "Carapace") %>% 
  mutate(variable = "Saturation") %>% 
  mutate(comparation = "Bright_vs_Dark")

table_claw_ds <- broom::tidy(claw_ds)%>% 
  mutate(body_region = "Claw") %>% 
  mutate(variable = "Chromatic_contrast") %>% 
  mutate(comparation = "Bright_vs_Dark")

table_cara_ds <- broom::tidy(cara_ds)%>% 
  mutate(body_region = "Carapace") %>% 
  mutate(variable = "Chromatic_contrast") %>% 
  mutate(comparation = "Bright_vs_Dark")

table_claw_dl <- broom::tidy(claw_dl)%>% 
  mutate(body_region = "Claw") %>% 
  mutate(variable = "Achromatic_contrast") %>% 
  mutate(comparation = "Bright_vs_Dark")

table_cara_dl <- broom::tidy(cara_dl)%>% 
  mutate(body_region = "Carapace") %>% 
  mutate(variable = "Achromatic_contrast") %>% 
  mutate(comparation = "Bright_vs_Dark")

#Uniting tables
mw_result <- bind_rows(table_claw_size,
                       table_cara_size,
                       table_claw_b2,
                       table_cara_b2,
                       table_claw_sat,
                       table_cara_sat,
                       table_claw_ds,
                       table_cara_ds,
                       table_claw_dl,
                       table_cara_dl
) %>% 
  relocate(comparation, body_region, variable)

mw_result

#Save results ----
write.csv(shapiro_table,
          "outputs/tables/shapiro_test_result.csv",
          row.names = F)

write.csv(mw_result,
          "outputs/tables/mann_whitney_result.csv",
          row.names = F)

# THE END -----------------------------------------------------------------
