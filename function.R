#' Funktion zum Erstellen eines Chorddiagramms mit Substanzen
#'
#' @param .data data.frame der die Daten beinhaltet
#' @param .Substanz_1 Spaltenname als String, der die Substanz 1 berinhaltet
#' @param .Substanz_2 Spaltenname als String, der die Substanz 2 berinhaltet
#' @inheritParams chorddiag::chorddiag() ... weitere Parameter aus chorddiag::chorddiag()
#'
#' @return interaktives Chorddiagramm
#' @import dyplr
#' @import chorddiag
#' @export
#'
#' @examples chorddiagramm(subs_kombis, "Sub1", "Sub2")
#' subs_kombis %>% chorddiagramm("Sub1", "Sub2")
chorddiagramm <- function(.data, .Substanz_1 = NULL, .Substanz_2 = NULL, ...) {
  require(dplyr)
  # Wenn Dataframe nicht quadratisch ist
  if(.data %>% nrow() != .data %>% ncol()){
    # weil Input-Matrize quadratisch sein muss:
    # Permutationen der möglichen Substanzeinträge jeder Spalte, aber ohne Gegenpart (NA)
    .data <- .data %>%
      # Alle möglichen Kombinationen müssen für die quadratische Matrix vorhanden sein
      bind_rows(expand_grid({{.Substanz_1}}:=c(.[[.Substanz_1]], .[[.Substanz_2]]) %>% unique(),
                            {{.Substanz_2}}:=NA) %>%
                  bind_rows(expand_grid({{.Substanz_1}}:=NA,
                                        {{.Substanz_2}}:=c(.[[.Substanz_1]], .[[.Substanz_2]]) %>% unique()))
      ) %>%
      # wenigstens eine Substanz muss vorhanden sein
      filter(!is.na(.Substanz_1) | !is.na(.Substanz_2))
  }

  # Chorddiag von quadratischer Matrize
  chorddiag::chorddiag(table(.data), ...)

}

