# see `help(run_script, package = 'touchstone')` on how to run this
# interactively

# TODO OPTIONAL Add directories you want to be available in this file or during the
# benchmarks.
# touchstone::pin_assets("some/dir")

# installs branches to benchmark
touchstone::branch_install()

# benchmark a function call from your package (two calls per branch)
touchstone::benchmark_run(
  {
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
  n = 20
)
