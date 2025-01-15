# `shiny.ollama`
**R shiny interface for chatting with LLMs offline on local with ollama**


*Chat with LLMs on your machine without internet with complete privacy via ollama, powered by R shiny interface. For more information on ollama, visit <https://ollama.com>.*

![Work in Progress - Currently serving a basic release](https://img.shields.io/badge/Work%20in%20Progress-Currently%20serving%20a%20basic%20release-blue) [![Visitors](https://hits.sh/github.com/ineelhere/shiny.ollama.svg?label=Visitors&style=flat-square)](https://hits.sh/github.com/ineelhere/shiny.ollama/)


## ⚠️ Disclaimer  

**Important:** The `shiny.ollama` package requires **Ollama** to be installed and available on your system. Without Ollama, this package will not function as intended.  

To install Ollama, refer to the [How to Install Ollama](#-how-to-install-ollama) section below.  



## 📦 Installation  

To install the `shiny.ollama` package, follow these steps in **R**:  

```R
# Install devtools if not already installed
install.packages("devtools")

# Install shiny.ollama from GitHub
devtools::install_github("ineelhere/shiny.ollama")
```



## 🚀 Usage  

Once installed, you can use the `shiny.ollama` app by running:

```R
library(shiny.ollama)

# Launch the Shiny app
shiny.ollama::run_app()
```



## ✨ Features  

The `shiny.ollama` package provides the following features:  

- **Model selection**: Choose from available models via a dropdown.  
- **Message input**: Send messages to the selected model.  
- **Download current chats**: Download the chats from session. 



## Example  

Run the following example to launch the app:  

```R
library(shiny.ollama)

# Run the Shiny app
shiny.ollama::run_app()
```



## 📥 How to Install Ollama  

To use this package, ensure **Ollama** is installed:  

1. Visit the [Ollama website](https://ollama.com) and download the installer for your OS.  
2. Run the installer and follow the on-screen steps.  
3. Verify the installation by running this command in your terminal:  

   ```sh
   ollama --version
   ```  

   You should see the version number displayed if the installation was successful.  
4. Pull a model on your local (for example [click here](https://ollama.com/library/llama3.3)) to start with and use it in the app.



## 📄 License  

This project is licensed under the **Apache License 2.0**.

___
Collaboration and Feedback are most welcome. More updates to come. Happy coding! 🎉