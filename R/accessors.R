# raw slots --------------------------------------------------------
table      <- function(x) x$table
ranks      <- function(x) x$ranks
attributes <- function(x) x$attributes
clustering <- function(x) x$clustering
ties       <- function(x) x$ties
ordinations<- function(x) x$ordinations
richness   <- function(x) x$richness

# add / replace helpers -------------------------------------------
add_tie <- function(x, d, name) {
  x$ties[[name]] <- d; x
}
add_ordination <- function(x, ord, name) {
  x$ordinations[[name]] <- ord; x
}
add_richness <- function(x, df) {
  x$richness <- df; x
}
