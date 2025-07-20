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
