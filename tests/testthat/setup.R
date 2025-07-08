tdir <- file.path(tempdir(), "test_convert")
dir.create(tdir)
file.copy(
  from = list.files(test.file(), full.names = TRUE),
  to = tdir,
  recursive = TRUE
)
dir.create(file.path(tdir, "csv"))
file.rename(file.path(tdir, "spec.csv"), file.path(tdir, "csv", "spec.csv"))

withr::defer(unlink(tdir, recursive = TRUE), teardown_env())
