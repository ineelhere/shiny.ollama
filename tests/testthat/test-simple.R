test_that("package loads correctly", {
  expect_true(requireNamespace("shiny.ollama", quietly = TRUE))
})
