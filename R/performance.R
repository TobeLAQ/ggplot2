# Fast data.frame constructor and indexing
# No checking, recycling etc. unless asked for
new_data_frame <- function(x = list(), n = NULL) {
  if (length(x) != 0 && is.null(names(x))) stop("Elements must be named", call. = FALSE)
  lengths <- vapply(x, length, integer(1))
  if (is.null(n)) {
    n <- if (length(x) == 0) 0 else max(lengths)
  }
  for (i in seq_along(x)) {
    if (lengths[i] == n) next
    if (lengths[i] != 1) stop("Elements must equal the number of rows or 1", call. = FALSE)
    x[[i]] <- rep(x[[i]], n)
  }

  class(x) <- "data.frame"

  attr(x, "row.names") <- .set_row_names(n)
  x
}

data_frame <- function(...) {
  new_data_frame(list(...))
}

data.frame <- function(...) {
  stop('Please use `data_frame()` or `new_data_frame()` instead of `data.frame()` for better performance. See the vignette "ggplot2 internal programming guidelines" for details.', call. = FALSE)
}

mat_2_df <- function(x, col_names = colnames(x), .check = FALSE) {
  force(col_names)
  x <- lapply(seq_len(ncol(x)), function(i) x[, i])
  if (!is.null(col_names)) names(x) <- col_names
  new_data_frame(x)
}

df_col <- function(x, name) .subset2(x, name)

df_rows <- function(x, i) {
  new_data_frame(lapply(x, `[`, i = i))
}

# More performant modifyList without recursion
modify_list <- function(old, new) {
  for (i in names(new)) old[[i]] <- new[[i]]
  old
}
modifyList <- function(...) {
  stop('Please use `modify_list()` instead of `modifyList()` for better performance. See the vignette "ggplot2 internal programming guidelines" for details.', call. = FALSE)
}
