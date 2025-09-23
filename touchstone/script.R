# see `help(run_script, package = 'touchstone')` on how to run this
# interactively

# TODO OPTIONAL Add directories you want to be available in this file or during the
# benchmarks.
# touchstone::pin_assets("some/dir")

# installs branches to benchmark
touchstone::branch_install()

touchstone::benchmark_run(
  {
    library(lightr)
    test.file <- function(...) {
      system.file("testdata", ..., package = "lightr")
    }
  },
  getspec = lr_get_spec(
    test.file(),
    ext = c(
      "TRM",
      "ttt",
      "jdx",
      "jaz",
      "JazIrrad",
      "csv",
      "txt",
      "Transmission",
      "spc"
    )
  ),
  n = 10
)

touchstone::benchmark_run(
  {
    library(lightr)
    test.file <- function(...) {
      system.file("testdata", ..., package = "lightr")
    }
  },
  avantes_converted = lr_parse_avantes_ttt(
    test.file("avantes_export.ttt")
  ),
  n = 50
)

touchstone::benchmark_run(
  {
    library(lightr)
    test.file <- function(...) {
      system.file("testdata", ..., package = "lightr")
    }
  },
  csv = lr_parse_csv(test.file("spec.csv")),
  n = 50
)

touchstone::benchmark_run(
  {
    library(lightr)
    test.file <- function(...) {
      system.file("testdata", ..., package = "lightr")
    }
  },
  generic = lr_parse_generic(test.file("CRAIC_export.txt")),
  n = 50
)

touchstone::benchmark_run(
  {
    library(lightr)
    test.file <- function(...) {
      system.file("testdata", ..., package = "lightr")
    }
  },
  jdx = lr_parse_oceanoptics_jdx(test.file("OceanOptics_period.jdx")),
  n = 50
)

touchstone::benchmark_run(
  {
    library(lightr)
    test.file <- function(...) {
      system.file("testdata", ..., package = "lightr")
    }
  },
  oceanoptics_convert = lr_parse_oceanoptics_jaz(test.file("jazspec.jaz")),
  n = 50
)

touchstone::benchmark_run(
  {
    library(lightr)
    test.file <- function(...) {
      system.file("testdata", ..., package = "lightr")
    }
  },
  procspec = lr_parse_oceanoptics_procspec(test.file(
    "procspec_files",
    "OceanOptics_Linux.ProcSpec"
  )),
  n = 50
)

touchstone::benchmark_analyze()
