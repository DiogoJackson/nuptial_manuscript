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

#Contando o N
data_cara <- data %>% 
  filter(vismodel == "Fiddler crab") %>% 
  filter(body_region == "Carapace") %>% 
  filter(claw_type == "Brachychelous")
data_cara %>% 
  count(carapace_color, name = "N")

data_cara <- data %>% 
  filter(vismodel == "Fiddler crab") %>% 
  filter(body_region == "Carapace") %>% 
  filter(claw_type == "Brachychelous") %>% 
  filter(carapace_type != "Bright")

data_claw <- data %>% 
  filter(vismodel == "Fiddler crab") %>% 
  filter(body_region == "Claw") %>% 
  filter(claw_type == "Brachychelous") %>% 
  filter(carapace_type != "Bright")

data_brac <- data %>% 
  filter(vismodel == "Fiddler crab") %>% 
  filter(claw_type == "Brachychelous") %>% 
  filter(carapace_type != "Bright")

data %>% 
  filter(vismodel == "Fiddler crab") %>% 
  filter(body_region == "Carapace") %>% 
  filter(claw_type == "Brachychelous") %>% 
  count(carapace_type)

# Teste de normalidade ----
sw_s <- data_brac %>% 
  dplyr::group_by(carapace_color, body_region) %>% 
  rstatix::shapiro_test(s)
sw_s

sw_m <- data_brac %>% 
  dplyr::group_by(carapace_color, body_region) %>% 
  rstatix::shapiro_test(m)
sw_m

#Levene test 
lv_s <- data_brac %>% 
  group_by(body_region) %>%  # Faz um teste para cada região do corpo
  levene_test(s ~ carapace_color)  # Testa se a variância de "s" difere entre as cores
lv_s

lv_m <- data_brac %>% 
  group_by(body_region) %>%  # Faz um teste para cada região do corpo
  levene_test(m ~ carapace_color)  # Testa se a variância de "m" difere entre as cores
lv_m

#Mann-whitney test

#Short photoreceptor (s)
#Claw comparation
boxplot(data_claw$s ~ data_claw$carapace_type)
claw_s <- wilcox.test(data_claw$s ~ data_claw$carapace_type)
claw_s

#Carapace comparation
boxplot(data_cara$s ~ data_cara$carapace_type)
cara_s <- wilcox.test(data_cara$s ~ data_cara$carapace_type)
cara_s

#Short photoreceptor (m)
#Claw comparation
boxplot(data_claw$m ~ data_claw$carapace_type)
claw_m <- wilcox.test(data_claw$m ~ data_claw$carapace_type)
claw_m

#Carapace comparation
boxplot(data_cara$m ~ data_cara$carapace_type)
cara_m <- wilcox.test(data_cara$m ~ data_cara$carapace_type)
cara_m

# Carapace size ----
boxplot(data_cara$size ~ data_cara$carapace_type)
cara_m <- wilcox.test(data_cara$size ~ data_cara$carapace_type)
cara_m

#Converting tables ----
table_claw_s <- broom::tidy(claw_s) %>% 
  mutate(body_region = "Claw") %>% 
  mutate(variable = "short_qi") %>% 
  mutate(comparation = "Bright_vs_Dark")

table_cara_s <- broom::tidy(cara_s)%>% 
  mutate(body_region = "Carapace") %>% 
  mutate(variable = "short_qi") %>% 
  mutate(comparation = "Bright_vs_Dark")

table_claw_m <- broom::tidy(claw_m)%>% 
  mutate(body_region = "Claw") %>% 
  mutate(variable = "medium_qi") %>% 
  mutate(comparation = "Bright_vs_Dark")

table_cara_m <- broom::tidy(cara_m)%>% 
  mutate(body_region = "Carapace") %>% 
  mutate(variable = "medium_qi") %>% 
  mutate(comparation = "Bright_vs_Dark")

#Uniting tables

#Shapiro
shapiro_table <- bind_rows(sw_s,
                           sw_m
) %>% 
  mutate(distribution = if_else(p > 0.05, 
                                "normal", 
                                "non-normal"))
shapiro_table

#Mann-whitney
mw_result <- bind_rows(table_claw_s,
                       table_cara_s,
                       table_claw_m,
                       table_cara_m
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
