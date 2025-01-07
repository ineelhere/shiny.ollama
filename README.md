# shiny.ollama
R Shiny interface to work with LLM models on local using Ollama

## Installation

To install the `shiny.ollama` package, you can use the following commands in R:

```R
# Install devtools if you haven't already
install.packages("devtools")

# Install shiny.ollama from GitHub
devtools::install_github("ineelhere/shiny.ollama")
```

## Usage

After installing the package, you can use the `shiny.ollama` app by running the following commands in R:

```R
library(shiny.ollama)

# Run the Shiny app
shiny.ollama::run_app()
```

## Features

The `shiny.ollama` package provides a Shiny interface to work with LLM models on local using Ollama. The app includes the following features:

- Model selection dropdown to choose from available models.
- Message input to send messages to the selected model.
- Streaming response feature to display responses from the model in real-time.

## Example

Here is an example of how to use the `shiny.ollama` package:

```R
library(shiny.ollama)

# Run the Shiny app
shiny.ollama::run_app()
```

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.
