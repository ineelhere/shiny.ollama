#' Check if Ollama is running
#'
#' This function checks whether the Ollama server is running at `http://localhost:11434/`.
#' It sends a request to the URL and determines if the server is reachable.
#'
#' @return A character string: `"ollama is running"` if the server is accessible,
#'         otherwise `"ollama is not running"`.
#' @export
check_ollama <- function() {
  url <- "http://localhost:11434/"
  response <- try(httr::GET(url), silent = TRUE)

  if (inherits(response, "try-error") || httr::status_code(response) >= 400) {
    return("Ollama is not running.")
  }

  return("Ollama is running!")
}

#' Format a message as markdown
#'
#' This helper function formats a message with a specified role
#' (e.g., "User", "Assistant", "System Status") into a markdown-styled string.
#' If the role is "System Status", it includes the status of the Ollama server.
#'
#' @param role A character string specifying the role (e.g., "User", "Assistant", "System Status").
#' @param content A character string containing the message content.
#'
#' @return A character string formatted as markdown.
#' @export
format_message_md <- function(role, content) {
  if (role == "System Status")  {
    return(sprintf('#### `%s`- %s\n\n', role, check_ollama()))
  } else {
    return(sprintf('#### `%s`\n\n%s\n\n', role, content))
  }
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

#' @title Convert chat history to downloadable format
#' @param messages List of chat messages
#' @param format Character string specifying format ("HTML" or "CSV")
#' @return Formatted chat history as a character string (HTML) or a data frame (CSV)
#' @export
format_chat_history <- function(messages, format = c("HTML", "CSV")) {
  format <- match.arg(format)

  if (format == "HTML") {
    html_content <- paste0(
      "<html><head></head><body>",
      markdown::markdownToHTML(
        text = paste(messages, collapse = "\n"),
        fragment.only = TRUE
      ),
      "</body></html>"
    )
    return(html_content)
  } else {
    # Parse each message into role and content
    parsed_messages <- lapply(messages, parse_message)

    # Convert to data frame
    chat_df <- data.frame(
      Timestamp = Sys.time(),  # Adding timestamp for better record keeping
      Role = sapply(parsed_messages, function(x) x$role),
      Message = sapply(parsed_messages, function(x) x$content),
      stringsAsFactors = FALSE
    )
    return(chat_df)
  }
}
