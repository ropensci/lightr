#' Parse OceanOptics ProcSpec file
#'
#' Parse OceanOptics ProcSpec file. <https://oceanoptics.com/>
#'
#' @inheritParams lr_parse_generic
#'
#' @inherit lr_parse_generic return
#'
#' @importFrom xml2 read_xml xml_find_all xml_find_first xml_text
#'
#' @references <https://oceanoptics.com/faq/extract-data-procspec-file-without-spectrasuite/>
#'
#' @examples
#' lr_parse_procspec(system.file("testdata", "procspec_files",
#'                               "OceanOptics_Linux.ProcSpec",
#'                               package = "lightr"))
#'
#' @export
#'
lr_parse_procspec <- function(filename) {
  # We let R find the suitable tmp folder to extract files
  tmp <- tempdir()
  on.exit(unlink(tmp))

  extracted_files <- utils::unzip(zipfile = filename,
                                  exdir = tmp)

  # According to OceanOptics FAQ, each procspec archive will only contain
  # one XML spectra file.

  # Data files have the format ps_\d+.xml
  data_file <- grep(pattern = "ps_\\d+\\.xml", extracted_files, value = TRUE)

  # OceanOptics softwares produce badly encoded characters. The only fix is to
  # strip them before feeding the xml file to read_xml.
  plain_text <- scan(data_file, what = character(), sep = "\n", quiet = TRUE)
  clean_text <- lapply(plain_text, function(line) {
    # Convert non-ASCII character to ""
    line <- iconv(line, to = "ASCII", sub = "")
    # Remove the extra malformed character
    line <- gsub("\\\001", "", line)

    return(line)
  })

  clean_text <- paste(clean_text, collapse = "\n")

  # Because the file is non ASCII, we don't need to specify the encoding.
  xml_source <- read_xml(clean_text)

  wl_node <- xml_find_all(xml_source, ".//channelWavelengths")
  wl_values <- xml_find_all(wl_node, ".//double")
  # Get rid of the XML tags.
  wl <- xml_text(wl_values)

  scope_node <- xml_find_first(xml_source, ".//pixelValues")
  scope_values <- xml_find_all(scope_node, ".//double")
  scope_inttime <- xml_text(xml_find_first(xml_source, ".//integrationTime"))
  scope_average <- xml_text(xml_find_first(xml_source, ".//scansToAverage"))
  scope_boxcar <- xml_text(xml_find_first(xml_source, ".//boxcarWidth"))
  scope <- xml_text(scope_values)

  white_node <- xml_find_all(xml_source, ".//referenceSpectrum")
  white_values <- xml_find_all(white_node, ".//double")
  white_inttime <- xml_text(xml_find_all(white_node, ".//integrationTime"))
  white_average <- xml_text(xml_find_all(white_node, ".//scansToAverage"))
  white_boxcar <- xml_text(xml_find_all(white_node, ".//boxcarWidth"))
  # Get rid of the XML tags.
  white <- xml_text(white_values)

  dark_node <- xml_find_all(xml_source, ".//darkSpectrum")
  dark_values <- xml_find_all(dark_node, ".//double")
  dark_inttime <- xml_text(xml_find_all(dark_node, ".//integrationTime"))
  dark_average <- xml_text(xml_find_all(dark_node, ".//scansToAverage"))
  dark_boxcar <- xml_text(xml_find_all(dark_node, ".//boxcarWidth"))
  # Get rid of the XML tags.
  dark <- xml_text(dark_values)

  processed_node <- xml_find_all(xml_source, ".//processedPixels")
  processed_values <- xml_find_all(processed_node, ".//double")
  # Get rid of the XML tags.
  processed <- xml_text(processed_values)

  specdf <- cbind(wl, dark, white, scope, processed)

  # The XML file was considered as text. So are "wl" and "procspec" columns.
  specdf <- apply(specdf, 2, as.numeric)

  author <- xml_text(xml_find_first(xml_source, ".//userName"))
  savetime <- NA # FIXME
  specclass <- xml_text(xml_find_first(xml_source, ".//spectrometerClass"))
  specmodel <- gsub(".+\\.([[:alnum:]]+)$", "\\1", specclass)
  specID <- xml_text(xml_find_first(xml_source, ".//spectrometerSerialNumber"))

  metadata <- c(author, savetime, specmodel, specID,
                dark_inttime, white_inttime, scope_inttime,
                dark_average, white_average, scope_average,
                dark_boxcar, white_boxcar, scope_boxcar)

  # Put integration time in ms instead of us
  metadata[c(5,6,7)] <- as.numeric(metadata[c(5,6,7)]) / 1000

  return(list(data.frame(specdf), metadata))
}
