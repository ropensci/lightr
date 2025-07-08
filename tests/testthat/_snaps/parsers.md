# Avantes

    Code
      lr_parse_rfl8(test.file("compare", "Avantes", "feather.RFL8"), specnum = 5)
    Condition
      Error:
      ! 'specnum' is larger than the number of spectra in the input file

# Generic

    Code
      lr_parse_generic(test.file("spec.csv"))
    Condition
      Error:
      ! Parsing failed.
      Please a different value for 'sep' argument

