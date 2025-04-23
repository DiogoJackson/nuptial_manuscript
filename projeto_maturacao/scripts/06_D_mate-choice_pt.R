#Packages ----
library(tidyverse)
library(pavo)
library(colorspec)
library(readxl)
library(performance)
library(cowplot)

#Import procspec data ----
refletancias <- getspec("data/raw/refletancias_modelo",                 
                        ext=c("procspec","txt"), 
                        decimal=",", 
                        lim=c(300,700))
refletancias <- fixspec(refletancias)
explorespec(refletancias)

# Crab model reflectances ----
r1 <- ggplot(refletancias, aes(x = wl)) +
  geom_line(aes(y = painted_yellow_claw, linetype = "Modelo"), 
            color = "grey20", linewidth = 1) +
  geom_line(aes(y = natural_yellow_claw, linetype = "Natural"), 
            color = "grey20", linewidth = 1) +
  scale_linetype_manual(values = c("Modelo" = "dashed", "Natural" = "solid")) +
  ylim(0, 100) +
  labs(y = "Refletancias (%)",
       x = "Comprimento de onda (nm)",
       title = "Quela amarela",
       linetype = "")+
  theme_test(base_size = 16)
r1

r2 <- ggplot(refletancias, aes(x = wl)) +
  geom_line(aes(y = model_white_carapace,linetype = "Modelo"), 
            color = "grey20" , linewidth = 1) +
  geom_line(aes(y = natural_white_carapace, linetype = "Natural"), 
            color = "grey20", linewidth = 1) +
  scale_linetype_manual(values = c("Modelo" = "dashed", "Natural" = "solid")) +
  ylim(0, 100) +
  labs(y = "Refletancias (%)",
       x = "Comprimento de onda (nm)",
       linetype = "",
       title = "Carapaça branca")+
  theme_test(base_size = 16)
r2

r3 <- ggplot(refletancias, aes(x = wl)) +
  geom_line(aes(y = model_dark_carapace, linetype = "Modelo"), 
            color = "grey20", linewidth = 1) +
  geom_line(aes(y = natural_dark_carapace, linetype = "Natural"), 
            color = "grey20", linewidth = 1) +
  scale_linetype_manual(values = c("Modelo" = "dashed", "Natural" = "solid")) +
  ylim(0, 100) +
  labs(y = "Refletancias (%)",
       x = "Comprimento de onda (nm)",
       title = "Carapaça escura",
       linetype = "")+
  theme_test(base_size = 16)
r3


#Mate choice data ----
data <- read_xlsx("data/raw/mate_choice.xlsx")
data

dataf <- data %>% 
  filter(experimento == "oficial")

data_agg <- aggregate(choice ~ color, 
                      FUN = sum, 
                      data = dataf)
data_agg

binom.test(21, 32, alternative = "greater")

dataf$choice <- as.numeric(dataf$choice)
ggplot(dataf, aes(x = color, y = choice, fill = color))+
  geom_col(show.legend = F, width = 0.5)+
  scale_fill_manual(values = c("#404244", "#ffb560"))+
  scale_x_discrete(limits = c("white", "dark"),
                   labels = c("Branco", "Escuro"))+
  labs(x = "Cor da carapaça",
       y = "Escolha da fêmea")+
  theme_classic(base_size = 18)

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
  labs(title = "Escolha da fêmea", fill = "Cor da carapaça") +  # Adicionando o rótulo para a legenda
  scale_fill_manual(values = c("white" = "#F4A261", "dark" = "#4F4F4F"),  # Definir cores manualmente
                    labels = c("dark" = "Escuro", "white" = "Branco"))+
  theme(
    plot.title = element_text(hjust = 0.5)  # Centralizar o título
  )
p1

#plot grid ----
p2 <- plot_grid(r1, r2, r3, 
                ncol = 1, 
                labels = c("A", "B", "C"), 
                label_size = 18)
p2

#Save figure
ggsave(p1,
       filename = "outputs/figures/mate_choice_pt.png",
       width = 4, 
       height = 4,
       dpi = 300)

ggsave(p2,
       filename = "outputs/figures/model_reflectances.png",
       width = 6, 
       height = 12,
       dpi = 300)
