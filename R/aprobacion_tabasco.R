library(dplyr)
library(ggplot2)
library(encuestar)

bd_aprobacion_tabasco <- openxlsx2::read_xlsx(file = "./Insumos/aprobracion_lideres_tabasco.xlsx") |> 
  as_tibble() |> 
  filter(!is.na(fecha)) |> 
  rename(aprobacion_amlo = aprobacion) |> 
  tidyr::pivot_longer(cols = !fecha, names_to = "tipo", values_to = "pct") |> 
  mutate(pct = pct/100)

g <- bd_aprobacion_tabasco |> 
  ggplot(aes(x = fecha, y = pct, label = scales::percent(x = pct, accuracy = 1.0), color = tipo, line = tipo)) +
  geom_line() +
  geom_point() +
  geom_text(vjust = -1.0, size = 10, show.legend = F) +
  tema_default() +
  scale_y_continuous(labels = scales::percent, limits = c(0.0, 1.0)) +
  scale_x_date(limits = c(lubridate::as_date("2023-01-01"), lubridate::as_date("2023-11-01")), date_labels = "%b", date_breaks = "1 month") +
  scale_color_manual(values = c("aprobacion_amlo" = color_morena, "aprobacion_merino" = color_prd), name = "", 
                     labels = c("aprobacion_amlo" = "AMLO", "aprobacion_merino" = "Merino")) +
  theme(text = element_text(size = 24, family = "Poppins")) +
  labs(fill = "", color = "", title = "Aprobación") +
  theme(legend.position = "NONE")

ggsave("Entregable/aprobacion_tabasco.png", g, scale = 2, width = 10, bg = "white", dpi = "retina")