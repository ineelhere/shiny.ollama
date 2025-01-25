#' @title Create the Shiny UI for the chat interface
#' @return A Shiny UI object
#' @keywords internal
create_chat_ui <- function() {
  shiny::fluidPage(
    shiny::tags$head(
      # Inline CSS for styling
      shiny::tags$style(HTML("
        body {
          font-family: Arial, sans-serif;
          background-color: #f8f9fa;
          margin: 0;
          padding: 0;
        }
        .title-panel {
          background-color: #007bff;
          color: white;
          padding: 15px;
          text-align: center;
          font-size: 20px;
          font-weight: bold;
        }
        .sidebar-panel {
          background-color: #ffffff;
          padding: 15px;
          border-radius: 10px;
          box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .main-panel {
          background-color: #ffffff;
          padding: 15px;
          border-radius: 10px;
          box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        #send {
          background-color: #007bff;
          color: white;
          border: none;
          padding: 10px 20px;
          cursor: pointer;
          border-radius: 5px;
        }
        #send:hover {
          background-color: #0056b3;
        }
        #download_chat {
          margin-top: 10px;
          background-color: #28a745;
          color: white;
          border: none;
          padding: 10px 20px;
          cursor: pointer;
          border-radius: 5px;
        }
        #download_chat:hover {
          background-color: #218838;
        }
      ")),
      
      # External CSS & JS
      shiny::tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),
      shiny::tags$script(src = "script.js")
    ),
    
    shiny::div(class = "title-panel", "Shiny Ollama - Chat with LLMs"),
    
    shiny::sidebarLayout(
      shiny::sidebarPanel(
        class = "sidebar-panel",
        shiny::h4("Chat Settings"),
        shiny::selectInput("model", "Select Model:", choices = NULL),
        shiny::textAreaInput("message", "Type your message:", rows = 3, placeholder = "Enter your message here..."),
        shiny::actionButton("send", "Send"),
        shiny::hr(),
        shiny::selectInput("download_format", "Download Format:", choices = c("HTML", "CSV")),
        shiny::downloadButton("download_chat", "Download Chat History")
      ),
      
      shiny::mainPanel(
        class = "main-panel",
        shiny::h4("Chat History"),
        shiny::uiOutput("chat_history")
      )
    )
  )
}
