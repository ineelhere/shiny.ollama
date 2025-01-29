#' @title Fetch available models from Ollama API
#' @return Character vector of model names or an error message
#' @export
fetch_models <- function() {
  tryCatch({
    response <- httr::GET("http://localhost:11434/api/tags")
    parsed <- jsonlite::fromJSON(rawToChar(response$content))
    parsed$models$model
  }, error = function(e) {
    c("Error fetching models")
  })
}

#' @title Send message to Ollama API and get response
#' @param message Character string containing the user message
#' @param model Character string specifying the model name
#' @param temperature Numeric value specifying the temperature
#' @param num_ctx Integer value specifying the number of contexts
#' @param top_k Integer value specifying the top K
#' @param top_p Numeric value specifying the top P
#' @param system Character string specifying the system
#' @param messages List of messages
#' @return A list with elements `success` (logical) and either `response` (character) or `error` (character)
#' @export
send_ollama_message <- function(message, model, temperature, num_ctx, top_k, top_p, system, messages) {
  tryCatch({
    response <- httr::POST(
      url = "http://localhost:11434/api/generate",
      body = jsonlite::toJSON(list(
        model = model,
        prompt = message,
        temperature = temperature,
        num_ctx = num_ctx,
        top_k = top_k,
        top_p = top_p,
        system = system,
        messages = messages,
        stream = TRUE  # Enables streaming response
      ), auto_unbox = TRUE),
      encode = "json"
    )

    if (httr::status_code(response) != 200) {
      return(list(success = FALSE, error = sprintf("Error: API returned status %d", httr::status_code(response))))
    }

    # Read the streaming response as plain text
    raw_content <- httr::content(response, as = "text", encoding = "UTF-8")
    json_lines <- unlist(strsplit(raw_content, "\n"))  # Split response into lines
    completions <- c()

    for (line in json_lines) {
      if (nzchar(line)) {  # Ignore empty lines
        parsed <- jsonlite::fromJSON(line, simplifyVector = TRUE)
        if ("response" %in% names(parsed)) {
          completions <- c(completions, parsed$response)
        }
      }
    }

    if (length(completions) == 0) {
      return(list(success = FALSE, error = "Error: No valid response received."))
    }

    # Combine all response parts into a single response
    list(success = TRUE, response = paste(completions, collapse = " "))
  }, error = function(e) {
    list(success = FALSE, error = sprintf("Error: %s", e$message))
  })
}
