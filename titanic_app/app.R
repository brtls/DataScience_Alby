# Shiny App Titanic Datensatz 


library(shiny)
library(e1071)
library(tidyverse)

# Ein Modell laden und neue Daten draufwerfen

# model_svm <- readRDS("titanic.svm.rds")

ui <- fluidPage(
    
    # Titel
    titlePanel("Überlebenschancen"),
    
    # Sidebar layout with input and output definitions 
    sidebarLayout(
        sidebarPanel(
            numericInput("age", "Alter",
                        min = 0,
                        max = 100,
                        value = 0),
            
            selectInput("sex", selected = NULL, "Geschlecht:",
                        c("weiblich" = 1,
                          "männlich" = 0)),
            
            sliderInput("pclass", "Passagierklasse:",
                        min = 1,
                        max = 3,
                        value = 1),
            
            actionButton("action", label = "Überlebenschancen")
        ),
        
        # Show a plot of the generated distribution 
        mainPanel(
            tableOutput("value")
        )
    )
)

# Define server logic
server <- function(input, output, session) {
    
    observeEvent(input$action, {
        pclass <- as.numeric(input$pclass)
        sex <- as.numeric(input$sex)
        age <- input$age
        data <- data.frame(pclass, sex, age)
        result <- predict(model_svm, data, probability = TRUE)
        my_result <- data.frame(attr(result, "probabilities"))
        output$value <- renderTable(my_result)
    }
    )
}

# Run the application 
shinyApp(ui, server)
