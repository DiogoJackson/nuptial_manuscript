#Show dados maturation
#Diogo J. A. Silva
# Mon Sep 23 14:49:09 2024 ------------------------------

#Packages ----
library(tidyverse)

#Import data ----
dados_clean <- read.csv("data/processed/maturation_data_clean.csv")

#Arrumando dados ----
# Calcula a proporção dentro de cada faceta
dados_proporcao <- dados_clean %>%
  group_by(Sex, maturation_stage, carapace_color) %>%
  summarise(count = n()) %>%
  group_by(Sex, maturation_stage) %>%
  mutate(prop = count / sum(count))

dados_proporcao2 <- dados_clean %>%
  group_by(Sex, maturation_stage, carapace_color) %>%
  summarise(count = n()) %>%
  group_by(Sex, carapace_color) %>%
  mutate(prop = count / sum(count))

dados_clean %>% 
  group_by(Sex) %>% 
  count()

#Graphics ----
p1 <- ggplot(dados_proporcao2, aes(x = carapace_color, y = prop, fill = maturation_stage)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = c("#ffb560", "gray35","black")) +
  labs(x = "Carapace color",
       y = "Proportion",
       fill = "Maturation stage") +
  theme_classic(base_size = 18) +
  facet_grid(~Sex)+
  theme(legend.position = "top")+
  geom_text(aes(label = paste0(round(prop * 100, 0), "%")),
            color = "white",# Multiplica por 100 e adiciona o símbolo %
            position = position_stack(vjust = 0.5))
p1

# Save figures ------------------------------------------------------------
ggsave(p1,
       filename = "outputs/figures/Figure_4_gonadal-maturity.png",
       width = 7, 
       height = 5,
       dpi = 300)

# FIM ---------------------------------------------------------------------

