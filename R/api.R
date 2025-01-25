#' @title Fetch available models from Ollama API
#' @return Character vector of model names or an error message
#' @export
fetch_models <- function() {
  tryCatch({
    response <- httr::GET("http://localhost:11434/api/tags")
    parsed <- jsonlite::fromJSON(rawToChar(response$content))
    parsed$models
  }, error = function(e) {
    c("Error fetching models")
  })
}

#' @title Send message to Ollama API and get response
#' @param message Character string containing the user message
#' @param model Character string specifying the model name
#' @return A list with elements `success` (logical) and either `response` (character) or `error` (character)
#' @export
send_ollama_message <- function(message, model) {
  tryCatch({
    response <- httr::POST(
      url = "http://localhost:11434/api/generate",
      body = jsonlite::toJSON(list(model = model, prompt = message, stream = FALSE), auto_unbox = TRUE),
      encode = "json"
    )
    
    if (httr::status_code(response) == 200) {
      content <- jsonlite::fromJSON(rawToChar(response$content))
      list(success = TRUE, response = content$response)
    } else {
      list(success = FALSE, error = "Error: Unable to fetch response.")
    }
  }, error = function(e) {
    list(success = FALSE, error = sprintf("Error: %s", e$message))
  })
}
