# 🌟 {`shiny.ollama`}
A **R Shiny interface** to work with LLM models locally using **Ollama**.

---

## ⚠️ Disclaimer  

🚨 **Important:** The `shiny.ollama` package requires **Ollama** to be installed and available on your system. Without Ollama, this package will not function as intended.  

👉 To install Ollama, refer to the [How to Install Ollama](#-how-to-install-ollama) section below.  

---

## 📦 Installation  

To install the `shiny.ollama` package, follow these steps in **R**:  

```R
# Install devtools if not already installed
install.packages("devtools")

# Install shiny.ollama from GitHub
devtools::install_github("ineelhere/shiny.ollama")
```

---

## 🚀 Usage  

Once installed, you can use the `shiny.ollama` app by running:

```R
library(shiny.ollama)

# Launch the Shiny app
shiny.ollama::run_app()
```

---

## ✨ Features  

The `shiny.ollama` package provides the following features:  

- 🎛️ **Model selection**: Choose from available models via a dropdown.  
- 💬 **Message input**: Send messages to the selected model.  
- 🌐 **Streaming response**: View real-time responses from the model.  

---

## 🖥️ Example  

Run the following example to launch the app:  

```R
library(shiny.ollama)

# Run the Shiny app
shiny.ollama::run_app()
```

---

## 📥 How to Install Ollama  

To use this package, ensure **Ollama** is installed:  

1. 🌐 Visit the [Ollama website](https://ollama.com) and download the installer for your OS.  
2. 🛠️ Run the installer and follow the on-screen steps.  
3. ✅ Verify the installation by running this command in your terminal:  

   ```sh
   ollama --version
   ```  

   You should see the version number displayed if the installation was successful.  
4. Pull a model on your local (for example [click here](https://ollama.com/library/llama3.3)) to start with and use it in the app.

---

## 📄 License  

This project is licensed under the **Apache License 2.0**. See the [LICENSE](LICENSE) file for details.  
