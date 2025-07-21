int32_to_uint32 <- function(int32) {
  ifelse(int32 >= 0, int32, 2^31 - 1 + int32)
}

convert_backward_tzdata <- function(tz) {
  # Convert timezones removed in tzdata 2024b.
  # This is a subset of what tzdata-backward is providing, based on cases we
  # could observe in test files. It can be expanded based on user feedback and
  # new test files.
  switch(
    tz,
    EST = "America/Panama",
    CET = "Europe/Brussels",
    CEST = "Europe/Brussels",
    CST = "America/Chicago",
    CDT = "America/Chicago",
    tz
  )
}

uncompress_spc_date <- function(compressed_date) {
  extract_spc_date_component <- function(bits) {
    components <- compressed_date %% 2^bits
    # nolint next: undesirable_operator_linter.
    compressed_date <<- compressed_date %/% 2^bits

    return(components)
  }
  minutes <- extract_spc_date_component(6)
  hour <- extract_spc_date_component(5)
  day <- extract_spc_date_component(5)
  month <- extract_spc_date_component(4)
  year <- compressed_date

  date <- sprintf(
    "%d-%02d-%02d %02d:%02d:00",
    year,
    month,
    day,
    hour,
    minutes
  )

  return(date)
}
