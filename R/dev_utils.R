test.file <- function(...) {
  system.file("testdata", ..., package = "lightr")
}

release_bullets <- function() {
  c(
    '`rhub::check(platform = "debian-gcc-devel-nold")`'
  )
}
