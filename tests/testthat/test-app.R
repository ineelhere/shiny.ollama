# Load necessary libraries
library(testthat)

# Tests for format_message_md

test_that("format_message_md formats messages correctly", {
  expect_equal(format_message_md("User", "Hello"), "## User\n\nHello\n\n")
  expect_equal(format_message_md("Assistant", "Hi there!"), "## Assistant\n\nHi there!\n\n")
})

# Tests for fetch_models

test_that("fetch_models handles successful API call", {
  mock_response <- list(models = c("model1", "model2"))
  mockery::stub(fetch_models, "httr::GET", function(...) {
    structure(list(content = charToRaw(jsonlite::toJSON(mock_response))),
              class = "response")
  })
  expect_equal(fetch_models(), c("model1", "model2"))
})

test_that("fetch_models handles API error", {
  mockery::stub(fetch_models, "httr::GET", function(...) stop("API error"))
  expect_equal(fetch_models(), "Error fetching models")
})

# Tests for send_ollama_message

test_that("send_ollama_message handles successful API call", {
  mock_response <- list(response = "Hello, User!")
  mockery::stub(send_ollama_message, "httr::POST", function(...) {
    structure(list(content = charToRaw(jsonlite::toJSON(mock_response)),
                   status_code = 200),
              class = "response")
  })
  result <- send_ollama_message("Hi", "test_model")
  expect_true(result$success)
  expect_equal(result$response, "Hello, User!")
})

test_that("send_ollama_message handles API error", {
  mockery::stub(send_ollama_message, "httr::POST", function(...) {
    structure(list(status_code = 500), class = "response")
  })
  result <- send_ollama_message("Hi", "test_model")
  expect_false(result$success)
  expect_equal(result$error, "Error: Unable to fetch response.")
})

test_that("send_ollama_message handles connection error", {
  mockery::stub(send_ollama_message, "httr::POST", function(...) stop("Connection error"))
  result <- send_ollama_message("Hi", "test_model")
  expect_false(result$success)
  expect_match(result$error, "Connection error")
})

# Tests for parse_message

test_that("parse_message extracts role and content", {
  message <- "## User\n\nHello\n\n"
  parsed <- parse_message(message)
  expect_equal(parsed$role, "User")
  expect_equal(parsed$content, "Hello")
})

test_that("parse_message handles empty content", {
  message <- "## Assistant\n\n\n\n"
  parsed <- parse_message(message)
  expect_equal(parsed$role, "Assistant")
  expect_equal(parsed$content, "")
})
