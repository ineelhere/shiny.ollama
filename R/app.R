# Load required packages
library(shiny)
source("R/helpers.R")
source("R/api.R")
source("R/chat_ui.R")
source("R/chat_server.R")

#' @title Run shiny Application for Chat Interface
#' @description Launches a shiny app for interacting with the Ollama API
#' @return No return value, called for side effects.
#' @export
run_app <- function() {
  shiny::shinyApp(create_chat_ui(), create_chat_server())
}
