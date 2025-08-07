tdir <- file.path(tempdir(), "test_convert")
dir.create(tdir)
file.copy(
  from = list.files(test.file(), full.names = TRUE),
  to = tdir,
  recursive = TRUE
)
dir.create(file.path(tdir, "csv"))
file.rename(file.path(tdir, "spec.csv"), file.path(tdir, "csv", "spec.csv"))

dir.create(file.path(tempdir(), "csv_mixed"))
file.copy(
  c(test.file("spec.csv"), test.file("non_english", "OceanView_nonEN.txt")),
  file.path(tempdir(), "csv_mixed")
)

withr::defer(
  unlink(c(tdir, file.path(tempdir(), "csv_mixed")), recursive = TRUE),
  teardown_env()
)
