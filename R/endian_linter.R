endian_linter <- function() {
  lintr::Linter(linter_level = "expression", function(source_expression) {
    xml_calls <- source_expression$xml_find_function_calls(c(
      "readBin",
      "writeBin"
    ))

    # 'endian=' is only relevant for size > 1 but it is difficult to determine
    # this statically since the default is to use natural size, which depends on
    # 'what='
    bad_expr <- xml2::xml_find_all(
      xml_calls,
      "parent::expr[
        not(SYMBOL_SUB[text() = 'endian'])
        and not(SYMBOL_SUB[text() = 'size']/following-sibling::expr[1]/NUM_CONST = 1)
      ]"
    )

    what_by_name <- lintr::get_r_string(
      bad_expr,
      "SYMBOL_SUB[text() = 'what']/following-sibling::expr[1]"
    )
    what_by_position <- lintr::get_r_string(
      bad_expr,
      "expr[3]"
    )

    what <- ifelse(!is.na(what_by_name), what_by_name, what_by_position)

    lintr::xml_nodes_to_lints(
      bad_expr[is.na(what) || what != "raw"],
      source_expression = source_expression,
      lint_message = paste(
        xml2::xml_find_first(bad_expr, "string(.//SYMBOL_FUNCTION_CALL)"),
        "should always include a value for 'endian'"
      ),
      type = "warning"
    )
  })
}
