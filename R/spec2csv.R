spec2csv <- function(filename) {

  data <- switch(fileext,
                 trm = parse_trm(filename)[[1]],
                 parse_trm(filename)[[1]])


}
