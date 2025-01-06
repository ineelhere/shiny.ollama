library(shiny)
library(bslib)
library(httr)
library(jsonlite)

# UI
ui <- fluidPage(
  titlePanel("Ollama Chat"),
  sidebarLayout(
    sidebarPanel(
      selectInput("model", "Select Model:", choices = NULL),
      textInput("message", "Message:"),
      actionButton("send", "Send")
    ),
    mainPanel(
      verbatimTextOutput("chat_history")
    )
  )
)

# Server
server <- function(input, output, session) {
  messages <- reactiveVal(list())
  
  # Update model list
  observe({
    models <- tryCatch({
      response <- GET("http://localhost:11434/api/tags")
      parsed <- fromJSON(rawToChar(response$content))
      parsed$models$name
    }, error = function(e) {
      c("Error fetching models")
    })
    updateSelectInput(session, "model", choices = models)
  })
  
  # Handle sending messages
  observeEvent(input$send, {
    req(input$message, input$model)
    
    # Add user message
    current <- messages()
    user_msg <- paste("User:", input$message)
    messages(c(current, user_msg))
    
    # Get response from Ollama
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
      bot_msg <- paste("Assistant:", content$response)
      messages(c(messages(), bot_msg))
    } else {
      messages(c(messages(), "Error: Failed to get response"))
    }
    
    updateTextInput(session, "message", value = "")
  })
  
  # Display chat history
  output$chat_history <- renderText({
    paste(messages(), collapse = "\n\n")
  })
}

shinyApp(ui, server)