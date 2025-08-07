## -----------------------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
has_pavo <- requireNamespace("pavo", quietly = TRUE)

## -----------------------------------------------------------------------------
library(lightr)

## -----------------------------------------------------------------------------
knitr::include_graphics("puffin-small.jpg")

## -----------------------------------------------------------------------------
raw_files <- lr_get_spec(file.path("data", "puffin"), ext = "ProcSpec")
txt_files <- lr_get_spec(file.path("data", "puffin"), ext = "txt")

## -----------------------------------------------------------------------------
#  library(pavo)
#  plot(raw_files, main = "Raw ProSpec files")
#  plot(txt_files, main = "Exported txt files")

## -----------------------------------------------------------------------------
all.equal(raw_files, txt_files, tol = 1e-4)

## -----------------------------------------------------------------------------
#  beak <- procspec(raw_files, opt = "smooth")
#  summary(beak, subset = c("B2", "H5"))

## -----------------------------------------------------------------------------
#  vis_beak <- vismodel(beak, visual = "avg.uv", achromatic = "ch.dc")
#  tcs_beak <- colspace(vis_beak)
#  coldist(tcs_beak, achromatic = TRUE)

