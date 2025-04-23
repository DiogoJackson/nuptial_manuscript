#Tabela 1 - branqueamento da carapaca das especies de chama-mares

# Mon Jan  6 16:40:22 2025 ------------------------------

#Packages ----
library(tidyverse)
library(readxl)

#Import data ----
table <- read_excel("data/raw/table1.xlsx", sheet = 1)

p <- ggplot(table, aes(Whitening))+
  geom_bar()
p

p <- ggplot(table, aes(x = Whitening, y = ..prop.., group = 1)) +
  geom_bar() +
  geom_text(aes(label = scales::percent(..prop..)), stat = "count", vjust = -0.5) +
  scale_y_continuous(labels = scales::percent_format()) +
  labs(y = "Porcentagem", x = "Whitening")
p

