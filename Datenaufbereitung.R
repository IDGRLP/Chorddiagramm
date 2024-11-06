# Daten aus dem ZfKD-Datensatz ziehen
c <- zfkd.connect() # Verbindung herstellen
# get.all.table.names(c) # Tabellennamen erfahren
substanzen <- get.table(c, "Substanz") # Tabelle Substanzen laden
systemtherapien <- get.table(c, "SYST") # Tabelle Systemtherapien laden
Tumor <- get.table(c, "Tumor") # Tabelle Tumor laden
zfkd.disconnect(c) # Verbindung loesen

# Verjoinen der Tabellen
sys_sub <- systemtherapien %>% left_join(substanzen)
datengrundlage <- Tumor %>% left_join(sys_sub)
rm(sys_sub, substanzen, systemtherapien, Tumor)
gc()

# Eingrenzen auf 1:1 Beziehung der Substanz-Kombinationen untereinander
subs_kombis <- datengrundlage %>% 
  # Nur Tumore behalten die exakt 2 Substanzen beinhalten
  group_by(oBDS_RKIPatientTumorId) %>% 
  filter(n_distinct(Bezeichnung, na.rm = T)==2) %>% 
  mutate(kombi = paste0(sort(unique(Bezeichnung)), collapse = "µ")) %>% # Verbindung wird 1mal gezaehlt
  ungroup() %>% 
  select(kombi)

subs_kombis <- subs_kombis %>% 
  # Transformation von vertikaler Ausrichtung einer Spalte 'Bezeichung' zu horizontaler Ausrichtung mit 2 Spalten 
  separate(kombi, into = c("Sub1", "Sub2"), sep = "µ", fill = "right", extra = "merge") %>% 
  # Eingrenzen auf die 50 haeufigsten Substanzen
  filter( paste(Sub1, Sub2, sep = "µ") %in% {
    (.) %>% 
      count(Sub1, Sub2) %>% 
      slice_max(order_by = n, n = n_top_subs) %>%
      mutate(komb = paste(Sub1, Sub2, sep = "µ")) %>% 
      pull(komb) %>% 
      unique()
  }) 

