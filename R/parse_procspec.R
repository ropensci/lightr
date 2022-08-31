#' Parse OceanInsight ProcSpec file
#'
#' Parse OceanInsight (formerly OceanOptics) ProcSpec file.
#' <https://www.oceaninsight.com/>
#'
#' @inheritParams lr_parse_generic
#'
#' @inherit lr_parse_generic return details
#'
#' @importFrom xml2 read_xml xml_find_all xml_find_first xml_text xml_double
#'
#' @references <https://www.oceaninsight.com/support/faqs/software/>
#'
#' @examples
#' res <- lr_parse_procspec(system.file("testdata", "procspec_files",
#'                                      "OceanOptics_Linux.ProcSpec",
#'                                      package = "lightr"))
#' head(res$data)
#' res$metadata
#'
#' @export
#'
lr_parse_procspec <- function(filename) {
  # We let R find the suitable tmp folder to extract files
  tmp <- tempdir()

  extracted_files <- utils::unzip(zipfile = filename,
                                  exdir = tmp)
  on.exit(unlink(extracted_files))

  # According to OceanOptics FAQ, each procspec archive will only contain
  # one XML spectra file.

  # Data files have the format ps_\d+.xml
  data_file <- grep(pattern = "ps_\\d+\\.xml", extracted_files, value = TRUE)

  # OceanOptics softwares produce badly encoded characters. The only fix is to
  # strip them before feeding the xml file to read_xml.
  plain_text <- scan(data_file, what = character(), sep = "\n", quiet = TRUE)

  # Convert to ASCII
  clean_text <- iconv(plain_text, to = "ASCII", sub = "")
  # Remove extra broken character
  clean_text <- gsub("\\\001", "", clean_text, fixed = TRUE)

  clean_text <- paste(clean_text, collapse = "\n")

  # Because the file is non ASCII, we don't need to specify the encoding.
  xml_source <- read_xml(clean_text)

  wl_values <- xml_find_all(xml_source, ".//channelWavelengths//double")
  # Get rid of the XML tags.
  wl <- xml_double(wl_values)

  scope_node <- xml_find_first(xml_source, ".//pixelValues")
  scope_values <- xml_find_all(scope_node, ".//double")
  scope_inttime <- xml_double(xml_find_first(xml_source, ".//integrationTime"))/1000
  scope_average <- xml_text(xml_find_first(xml_source, ".//scansToAverage"))
  scope_boxcar <- xml_text(xml_find_first(xml_source, ".//boxcarWidth"))
  scope <- xml_double(scope_values)

  white_node <- xml_find_all(xml_source, ".//referenceSpectrum")
  white_values <- xml_find_all(white_node, ".//double")
  white_inttime <- xml_double(xml_find_all(white_node, ".//integrationTime"))/1000
  white_average <- xml_text(xml_find_all(white_node, ".//scansToAverage"))
  white_boxcar <- xml_text(xml_find_all(white_node, ".//boxcarWidth"))
  # Get rid of the XML tags.
  white <- xml_double(white_values)

  dark_node <- xml_find_all(xml_source, ".//darkSpectrum")
  dark_values <- xml_find_all(dark_node, ".//double")
  dark_inttime <- xml_double(xml_find_all(dark_node, ".//integrationTime"))/1000
  dark_average <- xml_text(xml_find_all(dark_node, ".//scansToAverage"))
  dark_boxcar <- xml_text(xml_find_all(dark_node, ".//boxcarWidth"))
  # Get rid of the XML tags.
  dark <- xml_double(dark_values)

  processed_node <- xml_find_all(xml_source, ".//processedPixels")
  processed_values <- xml_find_all(processed_node, ".//double")
  # Get rid of the XML tags.
  processed <- xml_double(processed_values)

  specdf <- cbind(wl, dark, white, scope, processed)

  author <- xml_text(xml_find_first(xml_source, ".//userName"))
  savetime <- xml_double(xml_find_first(xml_source, "//milliTime"))
  savetime <- as.POSIXct(savetime/1000, origin = "1970-01-01", tz = "UTC")
  savetime <- format(savetime, tz = "UTC")
  specclass <- xml_text(xml_find_first(xml_source, ".//spectrometerClass"))
  specmodel <- gsub(".+\\.([[:alnum:]]+)$", "\\1", specclass)
  specID <- xml_text(xml_find_first(xml_source, ".//spectrometerSerialNumber"))

  metadata <- c(author, savetime, specmodel, specID,
                dark_inttime, white_inttime, scope_inttime,
                dark_average, white_average, scope_average,
                dark_boxcar, white_boxcar, scope_boxcar)

  return(list("data" = as.data.frame(specdf), "metadata" = metadata))
}
