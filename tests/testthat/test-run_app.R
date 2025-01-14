library(testthat)
library(shiny)
library(shiny.ollama)

test_that("run_app launches without error", {
  expect_error(run_app(), NA)
})

test_that("UI contains expected elements", {
  ui <- run_app()$ui
  expect_true("titlePanel" %in% names(ui))
  expect_true("sidebarLayout" %in% names(ui))
  expect_true("sidebarPanel" %in% names(ui$children[[2]]))
  expect_true("mainPanel" %in% names(ui$children[[2]]))
})

test_that("Server function handles messages correctly", {
  server <- run_app()$server
  session <- shiny::MockShinySession$new()
  input <- shiny::MockShinyInput$new()
  output <- shiny::MockShinyOutput$new()
  
  input$message <- "Hello"
  input$model <- "test_model"
  
  server(input, output, session)
  
  expect_true(length(output$chat_history) > 0)
})
