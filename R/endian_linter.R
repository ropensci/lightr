endian_linter <- function() {
  lintr::Linter(linter_level = "expression", function(source_expression) {
    xml_calls <- source_expression$xml_find_function_calls(c(
      "readBin",
      "writeBin"
    ))

    bad_expr <- xml2::xml_find_all(
      xml_calls,
      "parent::expr[
        not(SYMBOL_SUB[text() = 'endian']) and
        SYMBOL_SUB[text() = 'size']/following-sibling::expr[1]/NUM_CONST > 1
      ]"
    )

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
