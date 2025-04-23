#Show dados maturation
#Diogo J. A. Silva
# Mon Sep 23 14:49:09 2024 ------------------------------

#Packages ----
library(tidyverse)

#Import data ----
dados_clean <- read.csv("data/processed/maturation_data_clean.csv") %>% 
  mutate(carapace_color = fct_recode(carapace_color,
                                     "Escuro" = "Dark",
                                     "Branco" = "White"))%>%
  mutate(Sex = fct_recode(Sex,
                          "Macho" = "Male",
                          "Fêmea" = "Female"))

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

#Graphics ----
p1 <- ggplot(dados_proporcao2, aes(x = carapace_color, y = prop, fill = maturation_stage)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = c("#ffb560", "#404244","black")) +
  labs(x = "Cor da carapaça",
       y = "Proporção de indivíduos",
       fill = "Maturação") +
  theme_classic(base_size = 18) +
  facet_grid(~Sex)+
  theme(legend.position = "top")+
  geom_text(aes(label = paste0(round(prop * 100, 0), "%")),
            color = "white",# Multiplica por 100 e adiciona o símbolo %
            position = position_stack(vjust = 0.5))
p1

p2 <- ggplot(dados_clean, aes(x = maturation_stage, y = carapace_size, fill = carapace_color)) +
  geom_boxplot(alpha = 0.5) +
  geom_jitter(aes(color = carapace_color), 
              show.legend = FALSE,
              position = position_jitterdodge(jitter.width = 0.1, dodge.width = 0.75), 
              size = 1.5, alpha = 0.8) +  # Adicionando geom_jitter
  scale_color_manual(values = c("#bb9469","#404244"))+
  scale_fill_manual(values = c("#ffb560","#404244"))+
  labs(x = "Maturação",
       y = "Tamanho da carapaça (mm)",
       fill = "Cor da carapaça",
       color = "Cor da carapaça") +  # Para garantir que a legenda seja atualizada
  facet_grid(~Sex) +
  theme_classic(base_size = 18)+
  theme(legend.position = "top")
p2

# Save figures ------------------------------------------------------------
ggsave(p1,
       filename = "outputs/figures/count_maturity_pt.png",
       width = 7, 
       height = 5,
       dpi = 300)

ggsave(p2,
       filename = "outputs/figures/size_maturity_pt.png",
       width = 7.5, 
       height = 4.5,
       dpi = 300)

# FIM ---------------------------------------------------------------------

