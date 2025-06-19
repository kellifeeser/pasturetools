#' Calculate standard α-diversity metrics
#' @export
tractor_richness <- function(x) {
  mat <- x$table
  df <- tibble::tibble(
    sample   = colnames(mat),
    observed = apply(mat > 0, 2, sum),
    shannon  = vegan::diversity(t(mat), index = "shannon"),
    simpson  = vegan::diversity(t(mat), index = "simpson")
  )
  add_richness(x, df)
}
