#' @title Helper function to format messages in markdown
#' @param role Character string specifying the role (User/Assistant/System)
#' @param content Character string containing the message content
#' @return Character string formatted as markdown
#' @export
format_message_md <- function(role, content) {
  sprintf('## %s\n\n%s\n\n', role, content)
}

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
      body = jsonlite::toJSON(
        list(model = model, prompt = message, stream = FALSE),
        auto_unbox = TRUE
      ),
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

#' @title Parse a single markdown message into role and content
#' @param message Character string containing the markdown formatted message
#' @return A list with `role` (character) and `content` (character)
#' @keywords internal
parse_message <- function(message) {
  # Extract role from the header
  role <- gsub("^## ([^\n]+)\n\n.*$", "\\1", message)

  # Extract content (everything after the header)
  content <- gsub("^## [^\n]+\n\n(.*)$", "\\1", message)

  # Remove trailing newlines
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

#' @title Create the Shiny UI for the chat interface
#' @return A Shiny UI object
#' @keywords internal
create_chat_ui <- function() {
  shiny::fluidPage(
    shiny::titlePanel("Shiny Ollama - Chat with LLMs using Ollama"),
    shiny::sidebarLayout(
      shiny::sidebarPanel(
        shiny::h4("Chat Settings"),
        shiny::selectInput("model", "Select Model:", choices = NULL),
        shiny::textAreaInput(
          "message",
          "Type your message:",
          rows = 3,
          placeholder = "Enter your message here..."
        ),
        shiny::actionButton("send", "Send"),
        shiny::hr(),
        shiny::selectInput(
          "download_format",
          "Download Format:",
          choices = c("HTML", "CSV")
        ),
        shiny::downloadButton("download_chat", "Download Chat History")
      ),
      shiny::mainPanel(
        shiny::h4("Chat History"),
        shiny::uiOutput("chat_history")
      )
    )
  )
}

#' @title Create the Shiny server function for the chat interface
#' @return A Shiny server function
#' @keywords internal
create_chat_server <- function() {
  function(input, output, session) {
    messages <- shiny::reactiveVal(list())

    # Update model choices
    shiny::observe({
      models <- fetch_models()
      shiny::updateSelectInput(session, "model", choices = models)
    })

    # Handle send message button
    shiny::observeEvent(input$send, {
      shiny::req(input$message, input$model)
      current_messages <- messages()

      # Format and add user message
      user_msg <- format_message_md("User", input$message)
      messages(c(current_messages, user_msg))

      # Get response from Ollama
      result <- send_ollama_message(input$message, input$model)

      if (result$success) {
        bot_msg <- format_message_md("Assistant", result$response)
      } else {
        bot_msg <- format_message_md("System", result$error)
      }

      messages(c(current_messages, user_msg, bot_msg))
      shiny::updateTextAreaInput(session, "message", value = "")
    })

    # Render chat history
    output$chat_history <- shiny::renderUI({
      md_content <- paste(messages(), collapse = "\n")
      shiny::HTML(
        markdown::markdownToHTML(text = md_content, fragment.only = TRUE)
      )
    })

    # Handle downloads
    output$download_chat <- shiny::downloadHandler(
      filename = function() {
        paste(
          "chat_history",
          format(Sys.time(), "%Y%m%d_%H%M%S"),
          ".",
          tolower(input$download_format),
          sep = ""
        )
      },
      content = function(file) {
        chat_data <- messages()
        formatted_data <- format_chat_history(
          chat_data,
          format = input$download_format
        )

        if (input$download_format == "HTML") {
          writeLines(formatted_data, file)
        } else {
          write.csv(formatted_data, file, row.names = FALSE)
        }
      }
    )
  }
}

#' @title Run shiny Application for Chat Interface
#' @description Launches a shiny app for interacting with the Ollama API to perform
#' text-based chat.
#' @details The app provides a user-friendly interface for chatting with LLMs using
#' Ollama, including model selection, message sending, and chat history export.
#' @return No return value, called for side effects.
#' @export
#' @examples
#' if (interactive()) {
#'   run_app()
#' }
run_app <- function() {
  shiny::shinyApp(create_chat_ui(), create_chat_server())
}
