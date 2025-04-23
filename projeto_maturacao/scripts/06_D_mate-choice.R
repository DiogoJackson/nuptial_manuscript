#Packages ----
library(tidyverse)
library(pavo)
library(colorspec)
library(readxl)
library(performance)

#Import procspec data ----
refletancias <- getspec("data/raw/refletancias_modelo",                 
                        ext=c("procspec","txt"), 
                        decimal=",", 
                        lim=c(300,700))

explorespec(refletancias)

#Mate choice data ----
data <- read_xlsx("data/raw/mate_choice.xlsx")
data

dataf <- data %>% 
  filter(experimento == "oficial")

# data_agg <- aggregate(choice ~ color, 
#                       FUN = sum, 
#                       data = dataf)
# data_agg
# 
# binom.test(21, 32, alternative = "greater")


#Modelo de regressão binomial ----
m1 <- glm(choice ~ color, family = binomial, data = dataf)
summary(m1)

#Diagnóstico do modelo ----
check_model(m1) #pacote performance

#grafico de donut ----
dados_resumo <- dataf %>%
  group_by(color) %>%
  summarise(total = sum(choice))

# Calcular proporção para o gráfico de donut
dados_resumo$fraction <- dados_resumo$total / sum(dados_resumo$total)

# Adicionar a posição para o label no centro das fatias
dados_resumo$ypos <- cumsum(dados_resumo$fraction) - 0.4 * dados_resumo$fraction

# Criar o gráfico de donut com legenda
p1 <- ggplot(dados_resumo, aes(x = 2, y = fraction, fill = color)) +  # Definindo x = 2 para criar o buraco
  geom_bar(width = 1, stat = "identity", color = "white") +
  coord_polar("y", start = 0) +
  geom_text(aes(x = 2, y = ypos, label = scales::percent(fraction, accuracy = 1)), 
            color = "white", size = 5, position = position_stack(vjust = 0.5)) +  # Centralizar os rótulos
  theme_void() +
  xlim(0.5, 2.5) +  # Ajustar para criar o buraco no meio
  labs(title = "Female choice", fill = "Color") +  # Adicionando o rótulo para a legenda
  scale_fill_manual(values = c("white" = "#F4A261", "dark" = "#4F4F4F"),  # Definir cores manualmente
                    labels = c("dark" = "Dark", "white" = "White"))+
  theme(
    plot.title = element_text(hjust = 0.5)  # Centralizar o título
  )
p1

#Save figure
ggsave(p1,
       filename = "outputs/figures/mate_choice.png",
       width = 4, 
       height = 4,
       dpi = 300)

# FIM ---------------------------------------------------------------------
