#' @title Run Shiny Application for Chat Interface
#' @description Launches a Shiny app for interacting with the Ollama API to perform text-based chat.
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
    theme = bslib::bs_theme(version = 5,
                            primary = "#0056b3",
                            secondary = "#5a5a5a",
                            success = "#1e7e34",
                            info = "#138496",
                            warning = "#d39e00",
                            danger = "#c82333"),
    shiny::tags$head(
      shiny::tags$link(rel = "stylesheet",
                       href = "https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.2.0/github-markdown.min.css"),
      shiny::tags$style(shiny::HTML("
        body {
          background-color: #e9ecef;
          font-family: Arial, sans-serif;
        }
        #chat_history {
          max-height: 400px;
          overflow-y: auto;
          border: 1px solid #ced4da;
          padding: 10px;
          border-radius: 5px;
          background-color: #ffffff;
          box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        .markdown-body {
          padding: 10px;
          font-size: 14px;
        }
        .user-section, .assistant-section, .system-section {
          margin-bottom: 15px;
          padding: 10px;
          border-radius: 5px;
          color: #343a40;
        }
        .user-section { background-color: #cfe2ff; }
        .assistant-section { background-color: #d4edda; }
        .system-section { background-color: #f8d7da; }
        .user-section h2,
        .assistant-section h2,
        .system-section h2 {
          font-size: 16px;
          font-weight: bold;
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
        shiny::div(class = "markdown-body",
                   shiny::uiOutput("chat_history"))
      )
    )
  )

  server <- function(input, output, session) {
    messages <- shiny::reactiveVal(list())

    format_message_md <- function(role, content) {
      class_name <- tolower(paste0(role, "-section"))
      sprintf('<div class="%s">\n\n## %s\n\n%s\n\n</div>', class_name, role, content)
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
        bot_msg <- format_message_md("Assistant", content$response)
        messages(c(current_messages, user_msg, bot_msg))
      } else {
        error_msg <- format_message_md("System", "Error: Unable to fetch response.")
        messages(c(current_messages, user_msg, error_msg))
      }

      shiny::updateTextAreaInput(session, "message", value = "")
    }

    output$chat_history <- shiny::renderUI({
      md_content <- paste(messages(), collapse = "\n")
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
            "<html><head>",
            '<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.2.0/github-markdown.min.css">',
            "</head><body class='markdown-body'>",
            markdown::markdownToHTML(text = paste(chat_data, collapse = "\n"), fragment.only = TRUE),
            "</body></html>"
          )
          writeLines(html_content, file)

        } else if (input$download_format == "CSV") {
          chat_df <- data.frame(
            Type = ifelse(grepl("## User", chat_data), "User",
                          ifelse(grepl("## Assistant", chat_data), "Assistant", "System")),
            Message = gsub("## .*\n\n|<div.*?>|</div>", "", chat_data),
            stringsAsFactors = FALSE
          )
          write.csv(chat_df, file, row.names = FALSE)
        }
      }
    )

    observe({
      update_model_choices()
    })

    observeEvent(input$send, {
      send_message()
    })
  }

  shiny::shinyApp(ui, server)
}
