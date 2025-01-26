#' Format a message as markdown
#'
#' This helper function formats a message with a specified role 
#' (User, Assistant, or System) into a markdown-styled string.
#'
#' @param role A character string specifying the role (e.g., "User", "Assistant", "System").
#' @param content A character string containing the message content.
#'
#' @return A character string formatted as markdown.
#' @export
format_message_md <- function(role, content) {
  sprintf('#### `%s`\n\n%s\n\n', role, content)
}

#' Parse a markdown-formatted message
#'
#' This function extracts the role and content from a markdown-formatted message.
#'
#' @param message A character string containing the markdown-formatted message.
#'
#' @return A list with two elements:
#'   \item{role}{A character string representing the role (e.g., "User", "Assistant", "System").}
#'   \item{content}{A character string containing the extracted message content.}
parse_message <- function(message) {
  role <- gsub("^#### ([^\n]+)\n\n.*$", "\\1", message)
  content <- gsub("^#### [^\n]+\n\n(.*)$", "\\1", message)
  content <- gsub("\n\n$", "", content)
  list(role = role, content = content)
}
