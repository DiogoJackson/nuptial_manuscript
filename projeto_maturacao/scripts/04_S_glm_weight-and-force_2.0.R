# Script para fazer os graficos das diferenças de carapaça nupcial e escura
# Author: Diogo Silva
# Tue Sep  9 11:10:31 2025 ------------------------------

# Packages ----
library(tidyverse)
library(cowplot)
#library(colorspec)
library(pavo)
library(ggpubr)
library(ggdist)

# 1. import data ----
data <- read.csv("data/processed/04_data_master.csv")
head(data)
str(data)

# 2. Subsets ---------------------------------------------------------------
# subset da modelagem visual do caranguejo considerando apenas os valores de quela
data_brac <- data %>%
  filter(
    vismodel == "Fiddler crab",
    body_region == "Claw",
    claw_type == "Brachychelous"
  )

data_cara <- data %>%
  filter(
    vismodel == "Fiddler crab",
    body_region == "Carapace",
    claw_type == "Brachychelous"
  )

# 3. Preparar dados para figura (remover "Real" e garantir variáveis) -------
data_brac_na <- data_brac %>%
  filter(carapace_type != "Real") %>%  # retirar os animais medidos em campo (sem força/peso etc.)
  mutate(
    force.b = max_force / (max(max_force, na.rm = TRUE) + 0.001)
  )

# Padronizar variável de cor em "carapace_color" (fator)
# Se já existir carapace_color, usa ela. Senão, cria a partir de carapace_type (Bright/Dark -> Light/Dark)
if ("carapace_color" %in% names(data_brac_na)) {
  data_brac_na <- data_brac_na %>%
    mutate(carapace_color = as.factor(carapace_color))
} else {
  data_brac_na <- data_brac_na %>%
    mutate(
      carapace_color = fct_recode(as.factor(carapace_type),
                                  "Dark"  = "Dark",
                                  "White" = "Bright")
    )
}

# Remover linhas com NA / não-finitos nas variáveis que serão usadas nos modelos/plots
data_brac_na <- data_brac_na %>%
  filter(
    is.finite(max_force),
    is.finite(size),
    is.finite(weight_mg),
    !is.na(carapace_color)
  ) %>%
  droplevels()

# Versão para os box/halfeye usando rótulos "White/Dark" como no seu layout
data.b <- data_brac_na %>%
  mutate(
    carapace_type = fct_recode(as.factor(carapace_color),
                               "Dark"  = "Dark",
                               "White" = "Bright")
  )

# Helper: função para gerar predições + IC95% no response para GLM Gamma(log) ----
predict_glm_gamma_log <- function(model, newdata) {
  pr <- predict(model, newdata = newdata, type = "link", se.fit = TRUE)
  newdata %>%
    mutate(
      fit = exp(pr$fit),
      lwr = exp(pr$fit - 1.96 * pr$se.fit),
      upr = exp(pr$fit + 1.96 * pr$se.fit)
    )
}

# Nível de referência (primeiro nível do fator) para fixar nos efeitos parciais
ref_color <- levels(data_brac_na$carapace_color)[1]

# 4. Modelos (um para cada relação) ----------------------------------------

# (A) Modelo do artigo: max_force ~ size + color + weight
m_force <- glm(
  max_force ~ size + carapace_color + weight_mg,
  family = Gamma(link = "log"),
  data = data_brac_na
)

# (B) Modelo para massa: weight ~ size + color
m_mass <- glm(
  weight_mg ~ size + carapace_color,
  family = Gamma(link = "log"),
  data = data_brac_na
)

# (C) Modelo para força vs massa (controlando tamanho e cor):
#     max_force ~ weight + size + color
m_force_mass <- glm(
  max_force ~ weight_mg + size + carapace_color,
  family = Gamma(link = "log"),
  data = data_brac_na
)

# Se quiser checar outputs:
summary(m_force)
summary(m_mass)
summary(m_force_mass)

# 5. Figuras ---------------------------------------------------------------

# p1: peso por cor (BOXPLOT/HALFEYE) -> mantém como está (sem "plotar modelo")
p1 <- ggplot(data.b, aes(carapace_type, weight_mg, fill = carapace_type)) +
  stat_halfeye(alpha = 0.5, justification = 0, width = 0.5, .width = 0, adjust = 1) +
  stat_dots(aes(color = carapace_type), side = "left", justification = 1, binwidth = 2) +
  geom_boxplot(width = 0.15, show.legend = FALSE, fill = "white") +
  scale_fill_manual(values = c("#ffb560", "grey30")) +
  scale_color_manual(values = c("#ffb560", "grey30")) +
  labs(
    x = "Carapace color",
    y = "Claw mass (mg)"
  ) +
  theme_classic(base_size = 24) +
  theme(legend.position = "none") +
  annotate("text", x = 1.5, y = 80, label = "*", size = 15)

# p2: força por cor (BOXPLOT/HALFEYE) -> mantém como está (sem "plotar modelo")
p2 <- ggplot(data.b, aes(carapace_type, max_force, fill = carapace_type)) +
  stat_halfeye(alpha = 0.5, justification = 0, width = 0.5, .width = 0, adjust = 1) +
  stat_dots(aes(color = carapace_type), side = "left", justification = 1, binwidth = 0.5) +
  geom_boxplot(width = 0.15, show.legend = FALSE, fill = "white") +
  scale_fill_manual(values = c("#ffb560", "grey30")) +
  scale_color_manual(values = c("#ffb560", "grey30")) +
  labs(
    x = "Carapace color",
    y = "Maximum force (N)"
  ) +
  theme_classic(base_size = 24) +
  theme(legend.position = "none")

# p3: MASSA ~ TAMANHO (com modelo) -----------------------------------------
# Predição parcial: varia size, fixa carapace_color e (nada mais)
newdat_p3 <- data.frame(
  size = seq(min(data_brac_na$size, na.rm = TRUE),
             max(data_brac_na$size, na.rm = TRUE),
             length.out = 200),
  carapace_color = ref_color
)
newdat_p3 <- predict_glm_gamma_log(m_mass, newdat_p3)

p3 <- ggplot(data_brac, aes(x = size, y = weight_mg)) +
  geom_point(alpha = 0.6, size = 5) +
  geom_ribbon(
    data = newdat_p3,
    aes(x = size, ymin = lwr, ymax = upr),
    inherit.aes = FALSE,
    alpha = 0.2
  ) +
  geom_line(
    data = newdat_p3,
    aes(x = size, y = fit),
    inherit.aes = FALSE,
    linewidth = 1.5,
    color = "#ffb560"
  ) +
  labs(
    x = "Claw size (mm)",
    y = "Claw mass (mg)"
  ) +
  theme_classic(base_size = 24)

# p4: FORÇA ~ MASSA (com modelo) -------------------------------------------
# Predição parcial: varia weight_mg, fixa size (mediana) e cor
newdat_p4 <- data.frame(
  weight_mg = seq(min(data_brac_na$weight_mg, na.rm = TRUE),
                  max(data_brac_na$weight_mg, na.rm = TRUE),
                  length.out = 200),
  size = median(data_brac_na$size, na.rm = TRUE),
  carapace_color = ref_color
)
newdat_p4 <- predict_glm_gamma_log(m_force_mass, newdat_p4)

p4 <- ggplot(data_brac, aes(x = weight_mg, y = max_force)) +
  geom_point(alpha = 0.6, size = 5) +
  geom_ribbon(
    data = newdat_p4,
    aes(x = weight_mg, ymin = lwr, ymax = upr),
    inherit.aes = FALSE,
    alpha = 0.2
  ) +
  geom_line(
    data = newdat_p4,
    aes(x = weight_mg, y = fit),
    inherit.aes = FALSE,
    linewidth = 1.5,
    color = "#ffb560"
  ) +
  labs(
    x = "Claw mass (mg)",
    y = "Maximum force (N)"
  ) +
  theme_classic(base_size = 24)

# p5: FORÇA ~ TAMANHO (com modelo do artigo) --------------------------------
# Predição parcial: varia size, fixa weight_mg (mediana) e cor
newdat_p5 <- data.frame(
  size = seq(min(data_brac_na$size, na.rm = TRUE),
             max(data_brac_na$size, na.rm = TRUE),
             length.out = 200),
  weight_mg = median(data_brac_na$weight_mg, na.rm = TRUE),
  carapace_color = ref_color
)
newdat_p5 <- predict_glm_gamma_log(m_force, newdat_p5)

p5 <- ggplot(data_brac_na, aes(x = size, y = max_force)) +
  geom_point(alpha = 0.6, size = 5) +
  geom_ribbon(
    data = newdat_p5,
    aes(x = size, ymin = lwr, ymax = upr),
    inherit.aes = FALSE,
    alpha = 0.2
  ) +
  geom_line(
    data = newdat_p5,
    aes(x = size, y = fit),
    inherit.aes = FALSE,
    linewidth = 1.5,
    color = "#ffb560"
  ) +
  labs(
    x = "Claw size (mm)",
    y = "Maximum force (N)"
  ) +
  theme_classic(base_size = 24)

# Figure 3 ----
fig3 <- plot_grid(
  p1, p2, p3, p4, p5,
  ncol = 2,
  labels = "AUTO",
  align = "AUTO",
  label_size = 22
)

fig3

# Save plots ----
ggsave(
  plot = fig3,
  filename = "outputs/figures/Figure_3_morphofunctional-traits.png",
  width = 14,
  height = 18,
  dpi = 300
)

# FIM ---------------------------------------------------------------------