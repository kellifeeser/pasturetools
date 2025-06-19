#' @export
print.tractor <- function(x, ...) {
  cat("<tractor> object\n")
  cat(sprintf("  Table:        %d taxa × %d samples\n",
              nrow(x$table), ncol(x$table)))
  if (!is.null(x$ranks))
    cat(sprintf("  Ranks:        %d ranks\n", ncol(x$ranks)))
  if (!is.null(x$attributes))
    cat(sprintf("  Attributes:   %d variables\n", ncol(x$attributes)))
  if (!is.null(x$clustering))
    cat("  Clustering:   present\n")
  cat(sprintf("  Ties:         %d matrices\n", length(x$ties)))
  cat(sprintf("  Ordinations:  %d stored\n", length(x$ordinations)))
  if (!is.null(x$richness))
    cat("  Richness:     calculated\n")
  invisible(x)
}
