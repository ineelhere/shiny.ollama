#' @title Helper function to format messages in markdown
#' @param role Character string specifying the role (User/Assistant/System)
#' @param content Character string containing the message content
#' @return Character string formatted as markdown
#' @export
format_message_md <- function(role, content) {
  sprintf('#### `%s`\n\n%s\n\n', role, content)
}

#' @title Parse a single markdown message into role and content
#' @param message Character string containing the markdown formatted message
#' @return A list with `role` (character) and `content` (character)
parse_message <- function(message) {
  role <- gsub("^#### ([^\n]+)\n\n.*$", "\\1", message)
  content <- gsub("^#### [^\n]+\n\n(.*)$", "\\1", message)
  content <- gsub("\n\n$", "", content)
  list(role = role, content = content)
}
