#' Create a TRACTOR object
#'
#' @param table        matrix/data.frame of raw counts (taxa × samples)
#' @param ranks        data.frame of taxonomic ranks (rows = taxa)
#' @param attributes   data.frame of sample metadata (rows = samples)
#' @param clustering   list or factor of cluster memberships / dendrograms
#' @param ties         named list of dist objects / distance matrices
#' @param ordinations  named list of ordination objects (stats / vegan)
#' @param richness     data.frame of α-diversity metrics per sample
#'
#' @return An object of class <tractor>
#' @export
tractor <- function(table,
                    ranks        = NULL,
                    attributes   = NULL,
                    clustering   = NULL,
                    ties         = list(),
                    ordinations  = list(),
                    richness     = NULL) {
  
  stopifnot(is.matrix(table) || is.data.frame(table))
  
  structure(
    list(
      table       = as.matrix(table),   # T
      ranks       = ranks,              # R
      attributes  = attributes,         # A
      clustering  = clustering,         # C
      ties        = ties,               # T
      ordinations = ordinations,        # O
      richness    = richness            # R
    ),
    class = "tractor"
  )
}
