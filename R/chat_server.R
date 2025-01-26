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

      user_msg <- format_message_md("User", input$message)
      messages(c(current_messages, user_msg))

      result <- send_ollama_message(input$message, input$model)

      bot_msg <- format_message_md("Assistant", ifelse(result$success, result$response, result$error))
      messages(c(current_messages, user_msg, bot_msg))
      
      shiny::updateTextAreaInput(session, "message", value = "")
    })

    # Render chat history
    output$chat_history <- shiny::renderUI({
      session$sendCustomMessage(type = "hideLoading", message = TRUE)
      md_content <- paste(messages(), collapse = "\n")
      shiny::HTML(markdown::markdownToHTML(text = md_content, fragment.only = TRUE))
    })

    # Handle downloads
    output$download_chat <- shiny::downloadHandler(
      filename = function() {
        paste("chat_history", format(Sys.time(), "%Y%m%d_%H%M%S"), ".", tolower(input$download_format), sep = "")
      },
      content = function(file) {
        chat_data <- messages()
        formatted_data <- format_chat_history(chat_data, format = input$download_format)
        
        if (input$download_format == "HTML") {
          writeLines(formatted_data, file)
        } else {
          write.csv(formatted_data, file, row.names = FALSE)
        }
      }
    )
  }
}
