# `shiny.ollama` 

[![CRAN Version](https://img.shields.io/cran/v/shiny.ollama)](https://cran.r-project.org/package=shiny.ollama)
[![Dev Version](https://img.shields.io/badge/dev-v0.1.2-blue)](https://github.com/ineelhere/shiny.ollama)

**R Shiny Interface for Chatting with LLMs Offline via Ollama**

*Experience seamless, private, and offline AI conversations right on your machine! `shiny.ollama` provides a user-friendly R Shiny interface to interact with LLMs locally, powered by [Ollama](https://ollama.com).*  

[![pkgdown](https://img.shields.io/badge/pkgdown-documentation-red.svg)](https://www.indraneelchakraborty.com/shiny.ollama/)
[![Visitors](https://hits.sh/github.com/ineelhere/shiny.ollama.svg?label=Visitors&style=flat-square)](https://hits.sh/github.com/ineelhere/shiny.ollama/)
[![CRAN downloads](https://cranlogs.r-pkg.org/badges/shiny.ollama)](https://CRAN.R-project.org/package=shiny.ollama)
![R-CMD-check](https://github.com/ineelhere/shiny.ollama/actions/workflows/R-CMD-check.yaml/badge.svg)

`Development Version`

![](https://raw.githubusercontent.com/ineelhere/shiny.ollama/refs/heads/main/shiny_ollama_ui_0_1_2.png)

`CRAN release`

![](https://raw.githubusercontent.com/ineelhere/shiny.ollama/refs/heads/cran-0.1.1/shiny_ollama_ui.png)

## ⚠️ Disclaimer  
**Important:** `shiny.ollama` requires Ollama to be installed on your system. Without it, this package will not function. Follow the [Installation Guide](#-how-to-install-ollama) below to set up Ollama first.  

## Version Information
- **`CRAN` Version (`0.1.1`)**:
  - Core functionality for offline LLM interaction
  - Basic model selection and chat interface
  - Chat history export capabilities

- **`Development` Version (`0.1.2`)**:
  - All features from `0.1.1`
  - Better UI/UX
  - Advanced parameter customization
  - Enhanced user control over model behavior

##  Installation  
### From CRAN (Stable Version - `0.1.1`)
```r
install.packages("shiny.ollama")
```

### From GitHub (Latest Development Version - `0.1.2`)
```r
# Install devtools if not already installed
install.packages("devtools")

devtools::install_github("ineelhere/shiny.ollama")
```

##  Quick Start  
Launch the Shiny app in R with:
```r
library(shiny.ollama)

# Start the application
shiny.ollama::run_app()
```

##  Features  
### Core Features (All Versions)
-  **Fully Offline**: No internet required – complete privacy
-  **Model Selection**: Easily choose from available LLM models
-  **Message Input**: Engage in conversations with AI
-  **Save & Download Chats**: Export your chat history
-  **User-Friendly Interface**: Powered by R Shiny

### Advanced Features (Development Version `0.1.2`)
Customize your LLM interaction with adjustable parameters:
- Temperature control
- Context window size
- Top K sampling
- Top P sampling
- System instructions customization

##  How to Install Ollama  
To use this package, install Ollama first:  

1.  Download Ollama from [here](https://ollama.com) (Mac, Windows, Linux supported)
2.  Install it by following the provided instructions
3.  Verify your installation:
   ```sh
   ollama --version
   ```
   If successful, the version number will be displayed

4.  Pull a model (e.g., [deepseek-r1](https://ollama.com/library/deepseek-r1)) to get started

## License and Declaration
This R package is an independent, passion-driven open source initiative, released under the **`Apache License 2.0`**. It is not affiliated with, owned by, funded by, or influenced by any external organization. The project is dedicated to fostering a community of developers who share a love for coding and collaborative innovation.

Contributions, feedback, and feature requests are always welcome! 

Stay tuned for more updates. 🚀