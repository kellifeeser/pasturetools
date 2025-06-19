#' Compute and store a distance matrix inside a tractor object
#' @export
tractor_dist <- function(x, method = "bray", name = method, ...) {
  if (name %in% names(x$ties)) return(x)   # skip if already done
  d <- vegan::vegdist(t(x$table), method = method, ...)
  add_tie(x, d, name)
}
