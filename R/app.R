#' Run Ollama Chat Shiny App
#'
#' This Shiny application provides an interface for chatting with an assistant using the Ollama API.
#' It allows users to select a model, send a message to the assistant, and view the conversation history.
#' The app also supports downloading the chat history in HTML or CSV formats.
#'
#' @import shiny
#' @importFrom bslib bs_theme
#' @importFrom httr GET POST status_code
#' @importFrom jsonlite fromJSON toJSON
#' @export
#'
#' @return A Shiny app object.
#' @examples
#' if (interactive()) {
#'   run_app()
#' }
run_app <- function() {
  # No need for `library` calls inside package code
  # UI definition
  ui <- shiny::fluidPage(
    theme = bslib::bs_theme(version = 5),  # Ensure bslib is loaded and used correctly
    shiny::tags$head(
      shiny::tags$style(shiny::HTML("
        #chat_history {
          max-height: 400px;
          overflow-y: auto;
          border: 1px solid #ccc;
          padding: 10px;
          border-radius: 5px;
          background-color: #f9f9f9;
        }
        .user-message {
          color: #007bff;
          font-weight: bold;
        }
        .assistant-message {
          color: #28a745;
          font-weight: bold;
        }
        #send {
          background-color: #007bff;
          color: white;
          border-radius: 5px;
          border: none;
        }
        #send:hover {
          background-color: #0056b3;
        }
      "))
    ),
    shiny::titlePanel("Ollama Chat"),
    shiny::sidebarLayout(
      shiny::sidebarPanel(
        shiny::h4("Chat Settings"),
        shiny::selectInput("model", "Select Model:", choices = NULL),
        shiny::textAreaInput("message", "Type your message:", rows = 3, placeholder = "Enter your message here..."),
        shiny::actionButton("send", "Send"),
        shiny::hr(),
        shiny::selectInput("download_format", "Download Format:", choices = c("HTML", "CSV")),
        shiny::downloadButton("download_chat", "Download Chat History")
      ),
      shiny::mainPanel(
        shiny::h4("Chat History"),
        shiny::div(id = "chat_history", shiny::htmlOutput("chat_history"))
      )
    )
  )

  # Server logic
  server <- function(input, output, session) {
    # Reactive value to store chat messages
    messages <- shiny::reactiveVal(list())

    # Observe available models from the API
    shiny::observe({
      models <- tryCatch({
        response <- httr::GET("http://localhost:11434/api/tags")
        parsed <- jsonlite::fromJSON(rawToChar(response$content))
        parsed$models
      }, error = function(e) {
        c("Error fetching models")
      })
      shiny::updateSelectInput(session, "model", choices = models)
    })

    # Handle user message submission
    shiny::observeEvent(input$send, {
      shiny::req(input$message, input$model)
      current <- messages()

      # Add user message to chat history
      user_msg <- sprintf("<span class='user-message'>User:</span> %s", input$message)
      messages(c(current, user_msg))

      # API call to fetch assistant response
      response <- httr::POST(
        url = "http://localhost:11434/api/generate",
        body = jsonlite::toJSON(list(
          model = input$model,
          prompt = input$message,
          stream = FALSE
        ), auto_unbox = TRUE),
        encode = "json"
      )

      if (httr::status_code(response) == 200) {
        content <- jsonlite::fromJSON(rawToChar(response$content))
        bot_msg <- sprintf("<span class='assistant-message'>Assistant:</span> %s", content$response)
        messages(c(current, user_msg, bot_msg))
      } else {
        error_msg <- "<span class='error'>Error:</span> Unable to fetch response."
        messages(c(current, user_msg, error_msg))
      }
      shiny::updateTextInput(session, "message", value = "")
    })

    # Render chat history in UI
    output$chat_history <- shiny::renderUI({
      shiny::HTML(paste(messages(), collapse = "<br><br>"))
    })

    # Handle chat history download
    output$download_chat <- shiny::downloadHandler(
      filename = function() {
        paste("chat_history", Sys.Date(), ".", tolower(input$download_format), sep = "")
      },
      content = function(file) {
        chat <- messages()
        if (input$download_format == "HTML") {
          html_content <- paste0("<html><body>", paste(chat, collapse = "<br><br>"), "</body></html>")
          writeLines(html_content, file)
        } else if (input$download_format == "CSV") {
          chat_data <- data.frame(
            Type = ifelse(grepl("User:", chat), "User", "Assistant"),
            Message = gsub("<.*?>", "", chat),
            stringsAsFactors = FALSE
          )
          write.csv(chat_data, file, row.names = FALSE)
        }
      }
    )
  }

  # Run the Shiny app
  shiny::shinyApp(ui, server)
}
