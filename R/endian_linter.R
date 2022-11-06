endian_linter <- function() {
  xpath <- "
    //SYMBOL_FUNCTION_CALL[text() = 'readBin' or text() = 'writeBin']
      /parent::expr
      /parent::expr[not(SYMBOL_SUB[text() = 'endian'])]
  "

  lintr::Linter(function(source_expression) {
    if (!lintr::is_lint_level(source_expression, "expression")) {
      return(list())
    }

    xml <- source_expression$xml_parsed_content

    bad_expr <- xml2::xml_find_all(xml, xpath)

    lintr::xml_nodes_to_lints(
      bad_expr,
      source_expression = source_expression,
      lint_message = paste(
        xml2::xml_find_first(bad_expr, "string(.//SYMBOL_FUNCTION_CALL)"),
        "should always include a value for 'endian'"
      ),
      type = "warning"
    )
  })
}
