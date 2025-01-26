#' @title Create the Shiny UI for the chat interface
#' @return A Shiny UI object
#' @keywords internal
create_chat_ui <- function() {
  shiny::fluidPage(
    shiny::tags$head(
      shiny::tags$style(
        shiny::HTML(
          "body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
          }
          .container-fluid {
            padding: 0 20px;
            margin: auto;
          }
          .title-panel {
            background-color: #000066;
            color: white;
            padding: 20px;
            text-align: center;
            font-size: 24px;
            font-weight: bold;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.3);
            margin: 20px 0;
          }
          .sidebar-panel, .main-panel {
            background-color: #ffffff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
          }
          #send, #download_chat {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 12px 25px;
            cursor: pointer;
            border-radius: 5px;
            transition: background-color 0.3s, transform 0.1s;
          }
          #send:hover { background-color: #0056b3; }
          #download_chat { margin-top: 10px; }
          #download_chat:hover { background-color: #218838; }
          #send:active, #download_chat:active { transform: scale(0.95); }
          #chat_history {
            max-height: 400px;
            overflow-y: auto;
            border: 1px solid #ddd;
            padding: 10px;
            border-radius: 5px;
            background-color: #f9f9f9;
          }
          .footer {
            background-color: #000066;
            color: white;
            text-align: center;
            padding: 10px;
            font-size: 14px;
            margin-bottom: 20px;
            border-radius: 5px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.3);
          }"
        )
      ),
      shiny::tags$script(
        shiny::HTML(
          "$(document).ready(function() {
            var chatHistory = $('#chat_history');
            if (chatHistory.length) {
              var observer = new MutationObserver(function() {
                chatHistory.scrollTop(chatHistory[0].scrollHeight);
              });
              observer.observe(chatHistory[0], { childList: true });
            }
            $('#message').keypress(function(event) {
              if (event.which === 13 && !event.shiftKey) {
                event.preventDefault();
                $('#send').click();
              }
            });
          });"
        )
      )
    ),
    shiny::div(class = "title-panel", "Shiny Ollama - Chat with LLMs offline on local with Ollama"),
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
    ),
    shiny::div(
      class = "footer",
      shiny::HTML(
        "<code>shiny.ollama</code> - R package built with ",
        "<a href='https://shiny.rstudio.com/' target='_blank'>Shiny</a> & ",
        "<a href='https://ollama.com/' target='_blank'>Ollama</a> | ",
        "Source codes available on ",
        "<a href='https://github.com/ineelhere/shiny.ollama' target='_blank'>GitHub</a>"
      )
    )
  )
}
