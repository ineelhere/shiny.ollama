# `shiny.ollama` 🚀


[![CRAN Version](https://img.shields.io/cran/v/shiny.ollama)](https://cran.r-project.org/package=shiny.ollama)
![](https://img.shields.io/badge/Upgrades%20in%20Progress-Currently%20serving%20a%20basic%20release-cyan)

**R Shiny Interface for Chatting with LLMs Offline via Ollama**

*Experience seamless, private, and offline AI conversations right on your machine! `shiny.ollama` provides a user-friendly R Shiny interface to interact with LLMs locally, powered by [Ollama](https://ollama.com).*  

[![pkgdown](https://img.shields.io/badge/pkgdown-documentation-red.svg)](https://www.indraneelchakraborty.com/shiny.ollama/)
[![Visitors](https://hits.sh/github.com/ineelhere/shiny.ollama.svg?label=Visitors&style=flat-square)](https://hits.sh/github.com/ineelhere/shiny.ollama/)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## ⚠️ Disclaimer  
**Important:** `shiny.ollama` requires Ollama to be installed on your system. Without it, this package will not function. Follow the [Installation Guide](#-how-to-install-ollama) below to set up Ollama first.  

## 📦 Installation  
### From CRAN (Recommended)
```r
install.packages("shiny.ollama")
```

### From GitHub (Latest Development Version)
```r
# Install devtools if not already installed
install.packages("devtools")

devtools::install_github("ineelhere/shiny.ollama")
```

## ✨ Features  
- 🔒 **Fully Offline**: No internet required – complete privacy
- 🎛 **Model Selection**: Easily choose from available LLM models
- 💬 **Message Input**: Engage in conversations with AI
- 💾 **Save & Download Chats**: Export your chat history
- 🖥 **User-Friendly Interface**: Powered by R Shiny

## 🚀 Quick Start  
Launch the Shiny app in R with:
```r
library(shiny.ollama)

# Start the application
shiny.ollama::run_app()
```

## 📥 How to Install Ollama  
To use this package, install Ollama first:  

1. 🔗 Download Ollama from [here](https://ollama.com) (Mac, Windows, Linux supported).
2. 🛠 Install it by following the provided instructions.
3. ✅ Verify your installation:
   ```sh
   ollama --version
   ```
   If successful, the version number will be displayed.
4. 📌 Pull a model (e.g., [Llama3.3](https://ollama.com/library/llama3.3)) to get started.

## 📄 License  
This project is licensed under the **Apache License 2.0**.

💡 Contributions, feedback, and feature requests are always welcome! Stay tuned for more updates. 🚀

