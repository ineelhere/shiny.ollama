# Load necessary libraries
library(testthat)

# Test for format_message_md function
test_that("format_message_md formats messages correctly", {

  # Test when role is "User" and content is "Hello"
  result <- format_message_md("User", "Hello")
  expected_result <- "#### `User`\n\nHello\n\n"
  expect_equal(result, expected_result)

  # Test when role is "Assistant" and content is "How can I help you?"
  result <- format_message_md("Assistant", "How can I help you?")
  expected_result <- "#### `Assistant`\n\nHow can I help you?\n\n"
  expect_equal(result, expected_result)

  # Test when role is "System" and content is empty
  result <- format_message_md("System", "")
  expected_result <- "#### `System`\n\n\n\n"
  expect_equal(result, expected_result)
})

# Test for parse_message function
test_that("parse_message parses markdown messages correctly", {

  # Test when message is correctly formatted with "User" role
  message <- "#### `User`\n\nHello\n\n"
  result <- parse_message(message)
  expected_result <- list(role = "`User`", content = "Hello")
  expect_equal(result, expected_result)

  # Test when message is correctly formatted with "Assistant" role
  message <- "#### `Assistant`\n\nHow can I help you?\n\n"
  result <- parse_message(message)
  expected_result <- list(role = "`Assistant`", content = "How can I help you?")
  expect_equal(result, expected_result)

  # Test when message has no content
  message <- "#### `System`\n\n\n\n"
  result <- parse_message(message)
  expected_result <- list(role = "`System`", content = "")
  expect_equal(result, expected_result)
})
