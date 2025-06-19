#' Run PCoA or NMDS and attach to object
#' @export
tractor_ordinate <- function(x, tie = "bray", method = c("PCoA", "NMDS"), ...) {
  method <- match.arg(method)
  if (!tie %in% names(x$ties))
    x <- tractor_dist(x, tie)        # ensure distance exists
  d <- x$ties[[tie]]
  
  ord <- switch(method,
                PCoA = stats::cmdscale(d, k = 2, eig = TRUE),
                NMDS = vegan::metaMDS(d, k = 2, autotransform = FALSE, ...))
  add_ordination(x, ord, paste(method, tie, sep = "_"))
}
