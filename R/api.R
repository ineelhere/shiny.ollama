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
        messages = messages
      ), auto_unbox = TRUE),
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
