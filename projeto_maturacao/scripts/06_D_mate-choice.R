# Nuptial coloration in fiddler crabs as an indicator of reproductive quality
# Script to analyze mate choice data (white males vs dark males)
# Author: Diogo J. A. Silva
# date: Mon Jul 18 17:36:55 2022
# last update:
# Tue Sep  9 09:34:14 2025 ------------------------------

#Packages ----
library(tidyverse)
library(pavo)
library(colorspec)
library(readxl)
library(performance)

# Import procspec data ----
refletancias <- getspec("data/raw/refletancias_modelo",                 
                        ext=c("procspec","txt"), 
                        decimal=",", 
                        lim=c(300,700))

explorespec(refletancias)

# Mate choice data ----
data <- read_xlsx("data/raw/mate_choice.xlsx")
data

dataf <- data %>% 
  filter(experimento == "oficial")

# No choice number ----
choices <- dataf %>% 
  summarise(sum_no_choice = sum(no_choice),
            sum_choice = sum(choice))
choices

# Binomial regression model ----
m1 <- glm(choice ~ color, family = binomial, data = dataf)
summary(m1)

# Model diagnostics ----
check_model(m1) #performance package

#grafico de donut ----
dados_resumo <- dataf %>%
  group_by(color) %>%
  summarise(total = sum(choice))
dados_resumo

dataf %>%
  group_by(color) %>%
  count()

# Calculate proportion for the donut chart
dados_resumo$fraction <- dados_resumo$total / sum(dados_resumo$total)

# Add the position for the label at the center of the slices
dados_resumo$ypos <- cumsum(dados_resumo$fraction) - 0.4 * dados_resumo$fraction

# Create the donut chart with legend
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

# Saving figure ----
ggsave(p1,
       filename = "outputs/figures/Figure_mate-choice.png",
       width = 4, 
       height = 4,
       dpi = 300)

# THE ---------------------------------------------------------------------
