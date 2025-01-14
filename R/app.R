#' @title Run shiny Application for Chat Interface
#' @description Launches a shiny app for interacting with the Ollama API to perform text-based chat.
#' The app includes options for selecting models, sending messages, viewing chat history,
#' and downloading chat history in HTML or CSV format.
#'
#' @details The app provides a user-friendly interface with the following features:
#' - Model selection from available options fetched via the API.
#' - A text input for sending messages and receiving responses.
#' - A display area for chat history styled with GitHub Markdown CSS.
#' - Options to download the chat history in either HTML or CSV formats.
#'
#' @import shiny
#' @import bslib
#' @importFrom httr GET POST status_code
#' @importFrom jsonlite fromJSON toJSON
#' @importFrom markdown markdownToHTML
#' @export
#' @examples
#' if (interactive()) {
#'   run_app()
#' }
run_app <- function() {
  ui <- shiny::fluidPage(
    shiny::titlePanel("Shiny Ollama - Chat with LLMs using Ollama"),
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
        shiny::uiOutput("chat_history")
      )
    )
  )

  server <- function(input, output, session) {
    messages <- shiny::reactiveVal(list())

    format_message_md <- function(role, content) {
      sprintf('## %s\n\n%s\n\n', role, content)
    }

    fetch_models <- function() {
      tryCatch({
        response <- httr::GET("http://localhost:11434/api/tags")
        parsed <- jsonlite::fromJSON(rawToChar(response$content))
        parsed$models
      }, error = function(e) {
        c("Error fetching models")
      })
    }

    update_model_choices <- function() {
      models <- fetch_models()
      shiny::updateSelectInput(session, "model", choices = models)
    }

    send_message <- function() {
      shiny::req(input$message, input$model)
      current_messages <- messages()

      user_msg <- format_message_md("User", input$message)
      messages(c(current_messages, user_msg))

      response <- httr::POST(
        url = "http://localhost:11434/api/generate",
        body = jsonlite::toJSON(list(model = input$model, prompt = input$message, stream = FALSE), auto_unbox = TRUE),
        encode = "json"
      )

      if (httr::status_code(response) == 200) {
        content <- jsonlite::fromJSON(rawToChar(response$content))

        # Render the response in Markdown format
        bot_msg <- format_message_md("Assistant", content$response)

        # Append the bot message to messages
        messages(c(current_messages, user_msg, bot_msg))
      } else {
        error_msg <- format_message_md("System", "Error: Unable to fetch response.")
        messages(c(current_messages, user_msg, error_msg))
      }

      shiny::updateTextAreaInput(session, "message", value = "")
    }

    output$chat_history <- shiny::renderUI({
      md_content <- paste(messages(), collapse = "\n")

      # Convert Markdown to HTML for rendering in UI
      shiny::HTML(markdown::markdownToHTML(text = md_content, fragment.only = TRUE))
    })

    output$download_chat <- shiny::downloadHandler(
      filename = function() {
        paste("chat_history", Sys.Date(), ".", tolower(input$download_format), sep = "")
      },
      content = function(file) {
        chat_data <- messages()

        if (input$download_format == "HTML") {
          html_content <- paste0(
            "<html><head></head><body>",
            markdown::markdownToHTML(text = paste(chat_data, collapse = "\n"), fragment.only = TRUE),
            "</body></html>"
          )
          writeLines(html_content, file)
        } else if (input$download_format == "CSV") {
          chat_df <- data.frame(
            Type = ifelse(grepl("## User", chat_data), "User",
                          ifelse(grepl("## Assistant", chat_data), "Assistant", "System")),
            Message = gsub("## .*\n\n", "", chat_data),
            stringsAsFactors = FALSE
          )
          write.csv(chat_df, file, row.names = FALSE)
        }
      }
    )

    shiny::observe({
      update_model_choices()
    })

    observeEvent(input$send, {
      send_message()
    })
  }

  shiny::shinyApp(ui, server)
}
