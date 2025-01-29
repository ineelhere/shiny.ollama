#' @title Create the Shiny UI for the chat interface
#' @return A Shiny UI object
#' @keywords internal
create_chat_ui <- function() {
  shiny::fluidPage(
    # Add Inter font
    shiny::tags$head(
      shiny::tags$link(
        href = "https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap",
        rel = "stylesheet"
      ),
      shiny::tags$style(
        shiny::HTML(
          "body {
            font-family: 'Inter', system-ui, -apple-system, sans-serif;
            background-color: #f0f4f8;
            margin: 0;
            padding: 20px;
            color: #1a1a1a;
          }

          .container-fluid {
            max-width: 1400px;
            padding: 0 20px;
            margin: auto;
          }

          .title-panel {
            background: linear-gradient(88deg, #022a42 0%, #1f4e0e 100%);
            color: white;
            padding: 30px;
            text-align: center;
            font-size: 25px;
            font-weight: 700;
            border-radius: 16px;
            box-shadow: 0 8px 24px rgba(87, 42, 2, 0.2);
            margin: 20px 0 20px;
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease;
          }

          .title-panel:hover {
            transform: scale(0.98);
          }

          .sidebar-panel {
            background-color: white;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 20px -16px 24px rgb(6 33 90 / 8%);
            margin-bottom: 20px;
          }

          .chat-history-wrapper {
            background-color: white;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 20px -16px 24px rgb(6 33 90 / 8%);
            margin-left: 20px;
          }

          .form-control {
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 12px;
            transition: all 0.2s ease;
            font-size: 15px;
          }

          .form-control:focus {
            border-color: #572a02;
            box-shadow: 0 0 0 2px rgba(87, 42, 2, 0.1);
            outline: none;
          }

          .form-group label {
            font-weight: 500;
            margin-bottom: 8px;
            color: #333;
          }

          #send, #download_chat {
            font-weight: 600;
            padding: 12px 24px;
            border-radius: 8px;
            transition: all 0.2s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 14px;
            cursor: pointer;
            width: 100%;
            border: none;
            background: #014f86;
            color: #ffffff;
          }

          #send:hover, #download_chat:hover {
            background: #013a63;
            transform: translateY(-1px);
          }

          #send:disabled {
            opacity: 0.7;
            cursor: not-allowed;
            transform: none;
          }

          #chat_history {
            max-height: 880px;
            overflow-y: auto;
            padding: 20px;
            border: 1px solid #e0e0e0;
            border-radius: 12px;
            background: #f8f9fa;
            scrollbar-width: thin;
            scrollbar-color: #572a02 #f0f4f8;
          }

          #chat_history::-webkit-scrollbar {
            width: 8px;
          }

          #chat_history::-webkit-scrollbar-track {
            background: #f0f4f8;
          }

          #chat_history::-webkit-scrollbar-thumb {
            background-color: #572a02;
            border-radius: 4px;
          }

          .footer {
            background: linear-gradient(128deg, #13435d 0%, #5a1616 100%);
            color: #e0e0e0;
            text-align: center;
            padding: 20px;
            font-size: 14px;
            margin-top: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 24px rgba(1, 71, 63, 0.2);
          }

          .footer a {
            color: white;
            text-decoration: none;
            font-weight: 500;
            transition: opacity 0.2s ease;
          }

          .footer a:hover {
            opacity: 0.8;
          }

          #loading-spinner {
            padding: 30px;
            color: #572a02;
            text-align: center;
          }

          .spinner {
            border: 3px solid rgba(87, 42, 2, 0.1);
            border-top: 3px solid #572a02;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            animation: spin 1s linear infinite;
            margin: 0 auto;
          }

          @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
          }

          @media (max-width: 768px) {
            .chat-history-wrapper {
              margin-left: 0;
              margin-top: 20px;
            }
            
            .title-panel {
              font-size: 24px;
              padding: 20px;
            }

            .sidebar-panel,
            .chat-history-wrapper {
              padding: 20px;
            }
          }

          /* Add fancy hover effect to inputs */
          .form-control:hover {
            border-color: #8B4513;
          }

          /* Style the select dropdowns */
          select.form-control {
            appearance: none;
            background-image: url('data:image/svg+xml;charset=US-ASCII,<svg width=\"24\" height=\"24\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M7 10l5 5 5-5z\" fill=\"%23572a02\"/></svg>');
            background-repeat: no-repeat;
            background-position: right 8px center;
            padding-right: 32px;
          }

          /* Add section headers */
          .section-header {
            font-size: 18px;
            font-weight: 600;
            color: linear-gradient(88deg, #022a42 0%, #1f4e0e 100%);
            margin: 24px 0 16px;
            padding-bottom: 8px;
            border-bottom: 2px solid rgba(87, 42, 2, 0.1);
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
               $('#send').prop('disabled', true);
               $('#loading-spinner').html('<div class=\"spinner\"></div><p>Generating response...</p>').show();
             });

             Shiny.addCustomMessageHandler('hideLoading', function(message) {
               $('#loading-spinner').hide();
               $('#send').prop('disabled', false);
             });
           });"
        )
      )
    ),
    shiny::div(class = "title-panel", 
      "Shiny Ollama - Chat with LLMs offline on local with Ollama \U0001F916"
    ),
    shiny::sidebarLayout(
      shiny::sidebarPanel(
        class = "sidebar-panel",
        shiny::div(class = "section-header", "Chat Settings \u2699\ufe0f"),
        shiny::selectInput("model", "Select Model", choices = NULL),
        shiny::textAreaInput("message", "Type your message", rows = 2, placeholder = "Enter your message here..."),
        shiny::div(class = "section-header", "Model Parameters \U0001F9E0"),
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
        shiny::div(class = "section-header", "Export Options \U0001F4C1"),
        shiny::selectInput("download_format", "Download Format", choices = c("HTML", "CSV")),
        shiny::downloadButton("download_chat", "Chat History")
        ),
      shiny::mainPanel(
        shiny::div(
          class = "chat-history-wrapper",
          shiny::div(class = "section-header", "Chat Area \U0001F5E8\ufe0f"),
          shiny::uiOutput("chat_history")
        )
      )
    ),
    shiny::div(
      class = "footer",
      shiny::HTML(
        "<code>shiny.ollama</code> - R package built with ",
        "<a href='https://shiny.rstudio.com/' target='_blank'>Shiny</a> & ",
        "<a href='https://ollama.com/' target='_blank'>Ollama</a> | ",
        "<a href='https://github.com/ineelhere/shiny.ollama' target='_blank'>Source Codes</a> ",
        "| <a href='https://ineelhere.github.io/shiny.ollama/' target='_blank'>Documentation</a>",
      )
    )
  )
}
