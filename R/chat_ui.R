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
            background-color: #f0f4f8;
            margin: 0;
            padding: 0;
          }
          .container-fluid {
            padding: 0 20px;
            margin: auto;
          }
          .title-panel {
            background-color: #572a02;
            color: white;
            padding: 25px;
            text-align: center;
            font-size: 30px;
            font-weight: bold;
            border-radius: 12px;
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.2);
            margin: 20px 0;
          }
          .sidebar-panel {
            background-color: #ffffff;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
          }
          #send, #download_chat {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 14px 28px;
            cursor: pointer;
            border-radius: 6px;
            transition: background-color 0.3s, transform 0.1s;
          }
          #send:hover { background-color: #0056b3; }
          #download_chat { margin-top: 15px; }
          #download_chat:hover { background-color: #28a745; }
          #send:active, #download_chat:active { transform: scale(0.95); }
          #chat_history {
            max-height: 850px;
            overflow-y: auto;
            border-radius: 6px;
            border-top-left-radius: 12px;
            border-top-right-radius: 12px;
            border-bottom-left-radius: 6px;
            border-bottom-right-radius: 6px;
            border-top: none;
            padding: 15px;
          }
          .footer {
            background-color: #01473f;
            color: white;
            text-align: center;
            padding: 15px;
            font-size: 14px;
            margin-top: 20px;
            border-radius: 6px;
            box-shadow: inset -1px -1px rgba(255,255,255,0.1);
          }
          #loading-spinner {
            display: none;
            text-align: center;
            padding: 20px;
            color: #007bff;
          }
          .spinner {
            border: 4px solid #f3f3f3;
            border-top: 4px solid #007bff;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
            margin: 0 auto;
          }
          @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
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

             $('#send').on('click', function() {
               // Disable send button
               $('#send').prop('disabled', true);

               // Show loading spinner
               $('#loading-spinner').html('<div class=\"spinner\"></div><p>Generating response...</p>').show();
             });

             // Shiny binding to hide spinner when response is ready
             Shiny.addCustomMessageHandler('hideLoading', function(message) {
               $('#loading-spinner').hide();
               $('#send').prop('disabled', false);
             });
           });"
        )
      )
    ),
    shiny::div(class = "title-panel", "Shiny Ollama - Chat with LLMs offline on local with Ollama"),
    shiny::sidebarLayout(
      shiny::sidebarPanel(
        class = "sidebar-panel",
        shiny::h4(shiny::strong("Chat Settings")),
        shiny::selectInput("model", "Select Model", choices = NULL),
        shiny::textAreaInput("message", "Type your message", rows = 4, placeholder = "Enter your message here..."),
        shiny::tags$div(
          title = "Controls response randomness: 0.0 indicates Deterministic, 0.7 indicates Balanced creativity, 1.0 indicates More diverse/random",
          shiny::numericInput("temperature", "Temperature", value = 0.7, min = 0, max = 1, step = 0.1)
        ),
        shiny::tags$div(
          title = "Maximum context window size (tokens to remember)",
          shiny::numericInput("num_ctx", "Context Window Size", value = 1024, min = 1)
        ),
        shiny::tags$div(
          title = "Limits highest-probability tokens at each step",
          shiny::numericInput("top_k", "Top K", value = 50, min = 1)
        ),
        shiny::tags$div(
          title = "Probability mass for token selection. Lower values make responses more focused",
          shiny::numericInput("top_p", "Top P", value = 0.9, min = 0, max = 1, step = 0.1)
        ),
        shiny::tags$div(
          title = "Provides system instructions to guide model behavior",
          shiny::textInput("system", "System Instructions", value = "")
        ),
        shiny::actionButton("send", "Send"),
        shiny::div(id = "loading-spinner"),
        shiny::hr(),
        shiny::selectInput("download_format", "Download Format", choices = c("HTML", "CSV")),
        shiny::downloadButton("download_chat", "Download Chat History")
      ),
      shiny::div(
        class = "chat-history-wrapper",
        shiny::h4(shiny::strong("Chat History")),
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
