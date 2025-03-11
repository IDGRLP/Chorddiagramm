library(chorddiag) # Diagramm selbst
library(dplyr) # %>%
library(tidyr) # z. B. pivot_wider

stadKat <- c("I", "II", "III", "IV")

df <- data.frame(
    uicc1 = sample(stadKat, 1450, replace = TRUE),
    uicc2 = sample(stadKat, 1350, replace = TRUE)
) %>%
    filter(uicc1 <= uicc2)

chord <- as.matrix(df %>%
                       dplyr::select(uicc1, uicc2) %>%
                       count(uicc1, uicc2) %>%
                       pivot_wider(names_from = uicc2, values_from = n) %>%
                       dplyr::select(-uicc1))
chorddiag(chord,
          groupColors = c("#e6f1d7", "#c2dd9e", "#7fb13d", "#43914a", "#435e20"),
          tooltipUnit = " Patienten",
          tickInterval = 50, # set the interval between ticks
          showZeroTooltips = FALSE,
          ticklabelFontsize = 8,
          groupnamePadding = 30)
