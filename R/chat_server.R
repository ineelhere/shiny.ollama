#' @title Create the Shiny server function for the chat interface
#' @return A Shiny server function
#' @keywords internal
create_chat_server <- function() {
  function(input, output, session) {

    output$ollama_status <- shiny::renderUI({
      shiny::markdown(format_message_md("System Status", check_ollama()))
    })

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

      result <- send_ollama_message(
        message = input$message,
        model = input$model,
        temperature = input$temperature,
        num_ctx = input$num_ctx,
        top_k = input$top_k,
        top_p = input$top_p,
        system = input$system,
        messages = current_messages
      )

      bot_msg <- format_message_md(input$model, ifelse(result$success, result$response, result$error))
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
