#' zfkd.connect
#' Stellt eine Verbindung zur SQLite-Datenbank des ZfKD her, 
#' entweder ueber Dialogfenster oder mit einem uebergebenen Pfad  
#' @param .file Dateipfad zur sqlite-DB
#'
#' @return Connection-Objekt von RSQLITE
#' @import RSQLite
#' @import svDialogs
#' @export
#'
#' @examples c <- zfkd.connect() # Dialogfenster oeffnet sich
#' @examples c <- zfkd.connect(.file = "C:/User/PaulPanzer/sqlite.db") # Ohne Dialogfenster
zfkd.connect <- function(.file = NULL){
  require(RSQLite)
  require(svDialogs)
  if(missing(.file)){
    # Speicherort der Datenbank abfragen
    .file <- svDialogs::dlg_open(title = "Bitte die .sqlite Datei auswählen", multiple = F)$res
  }
  # Verbindung zur sqlite Datenbank herstellen
  return(dbConnect(SQLite(), dbname=.file))
}

# -----------------------------------------------------------------------------

#' zfkd.disconnect
#' Beendet die Verbidnung zur SQLite-Datenbank
#' @param .con RSQLite Connection-Objekt
#'
#' @import RSQLite
#'
#' @examples zfkd.disconnect(c)
zfkd.disconnect <- function(.con){
  require(RSQLite)
  # Verbindung zur sqlite Datenbank herstellen
  dbDisconnect(.con)
  # Connection-Variable entfernen
  Sx <- deparse(substitute(.con))
  rm(list=Sx,envir=sys.frame(-1))
}

# -----------------------------------------------------------------------------

#' get.all.table.names
#' Funktion, um alle Tabellennamen in der Datenbank mit der Connection .con zu erfahren
#' @param .con Connection-Objekt zur SQLite-DB
#'
#' @return Vektor mit allen Tabellennamen der Datenbank
#' @import RSQLite
#'
#' @examples get.all.table.names(c)
get.all.table.names <- function(.con){
  require(RSQLite)
  # Alle Tabellenamen wiedergeben
  return(dbListTables(.con))
}

# -----------------------------------------------------------------------------

#' get.table
#' Funktion um eine ganze Tabelle abzufragen
#' @param .con Connection-Objekt zur SQLite-DB
#' @param .table String mit Tabellennamen
#'
#' @return Dataframe mit der gewuenschten Tabelle
#' @import RSQLite
#' @export
#'
#' @examples substanzen <- get.table(c, "Substanz") 
get.table <- function(.con, .table){
  require(RSQLite)
  # gesamte Tabelle wiedergeben
  return(dbGetQuery(.con, paste0("SELECT * FROM ", .table)))
}

# -----------------------------------------------------------------------------

#' get.query
#' Funktion, um Daten abzufragen mit SQLite-Syntax
#' @param .con Connection-Objekt zur SQLite-DB
#' @param .query String mit SQLite-Statement
#'
#' @return Dataframe mit der gewuenschten Tabelle
#' @import RSQLite
#' @export
#'
#' @examplessubstanzen substanzen_01 <- get.query(c, "SELECT * FROM Substanz WHERE Lieferregister = '01'")
get.query <- function(.con, .query){
  require(RSQLite)
  # gesamte Tabelle wiedergeben
  return(dbGetQuery(.con, .query))
}

# -----------------------------------------------------------------------------

#' Funktion um Spaltennamen einer Tabelle zu erfahren
#'
#' @param .con Verbindungs-Objekt
#' @param .table String Tabellenname
#'
#' @return character Vector der Spaltennamen
#' @import RSQLite
#' @export
#'
#' @examples get.col_names(c, "Substanz") 
get.col_names <- function(.con, .table){
  require(RSQLite)
  # gesamte Tabelle wiedergeben
  return(dbListFields(.con, .table))
}

