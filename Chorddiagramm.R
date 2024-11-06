# Libraries ####
library(data.table)
library(tidyverse)
library(chorddiag)

# Funktionen fuer ZfKD-Datensatz einzulesen
source("read_in_zfkd.R", encoding = "UTF-8")
source("function.R", encoding = "UTF-8")

# Key values
# Top 10 Substanzen  
n_top_subs <- 10

# Datenaufbereitung
source("Datenaufbereitung.R", encoding = "UTF-8")

# Durchfuehrung
subs_kombis %>% chorddiagramm("Sub1", "Sub2")
