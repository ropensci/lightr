int32_to_uint32 <- function(int32) {

  ifelse(int32 >= 0, int32, 2^31 - 1 + int32)

}
