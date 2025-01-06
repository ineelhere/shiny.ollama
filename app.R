library(shiny)
library(bslib)
library(httr)
library(jsonlite)

# UI
ui <- fluidPage(
  theme = bs_theme(version = 5, bootswatch = "flatly"),
  tags$head(
    tags$style(HTML("
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
  titlePanel("Ollama Chat"),
  sidebarLayout(
    sidebarPanel(
      h4("Chat Settings"),
      selectInput("model", "Select Model:", choices = NULL),
      textAreaInput("message", "Type your message:", rows = 3, placeholder = "Enter your message here..."),
      actionButton("send", "Send"),
      hr(),
      selectInput("download_format", "Download Format:", choices = c("HTML", "CSV")),
      downloadButton("download_chat", "Download Chat History")
    ),
    mainPanel(
      h4("Chat History"),
      div(id = "chat_history", htmlOutput("chat_history")) # Use htmlOutput for styled text
    )
  )
)

# Server
server <- function(input, output, session) {
  messages <- reactiveVal(list())
  
  observe({
    models <- tryCatch({
      response <- GET("http://localhost:11434/api/tags")
      parsed <- fromJSON(rawToChar(response$content))
      parsed$models
    }, error = function(e) {
      c("Error fetching models")
    })
    updateSelectInput(session, "model", choices = models)
  })
  
  observeEvent(input$send, {
    req(input$message, input$model)
    current <- messages()
    
    # Add user message and prompt to chat history
    user_msg <- sprintf("<span class='user-message'>User:</span> %s", input$message)
    messages(c(current, user_msg))
    
    # API call to fetch assistant response
    response <- POST(
      url = "http://localhost:11434/api/generate",
      body = toJSON(list(
        model = input$model,
        prompt = input$message,
        stream = FALSE
      ), auto_unbox = TRUE),
      encode = "json"
    )
    
    if (status_code(response) == 200) {
      content <- fromJSON(rawToChar(response$content))
      bot_msg <- sprintf("<span class='assistant-message'>Assistant:</span> %s", content$response)
      messages(c(current, user_msg, bot_msg))
    } else {
      error_msg <- "<span class='error'>Error:</span> Unable to fetch response."
      messages(c(current, user_msg, error_msg))
    }
    updateTextInput(session, "message", value = "")
  })
  
  # Render chat history
  output$chat_history <- renderUI({
    HTML(paste(messages(), collapse = "<br><br>"))
  })
  
  # Download chat history
  output$download_chat <- downloadHandler(
    filename = function() {
      paste("chat_history_", Sys.Date(), ".", tolower(input$download_format), sep = "")
    },
    content = function(file) {
      chat <- messages()
      
      if (input$download_format == "HTML") {
        # Save as HTML
        html_content <- paste0("<html><body>", paste(chat, collapse = "<br><br>"), "</body></html>")
        writeLines(html_content, file)
      } else if (input$download_format == "CSV") {
        # Save as CSV
        chat_data <- data.frame(
          Type = ifelse(grepl("User:", chat), "User", "Assistant"),
          Message = gsub("<.*?>", "", chat), # Remove HTML tags
          stringsAsFactors = FALSE
        )
        write.csv(chat_data, file, row.names = FALSE)
      }
    }
  )
}

shinyApp(ui, server)
