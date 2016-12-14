library(shiny)
library(ggplot2)
library(scales)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Zombicide"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      helpText("1/ Sélectionne les caractéristiques de ton attaque :"),
      numericInput("n",
                  "Nombre de dés :",
                  min = 1,
                  max = 50,
                  value = 3),
      radioButtons("p",
                   "Précision :",
                   c("6+" = 6, "5+"=5, "4+"=4, "3+"=3, "2+"=2)),
      helpText("Tu n'as pas beaucoup de zombies à portée ? 
               Sélectionne le nombre de zombies max :"),
      numericInput("zombiesDispo",
                  "Zombies sur la case ciblée :",
                  min = 1,
                  max = 50,
                  value = 36),
      helpText("2/ Tu hésites entre deux armes ?
               Sélectionne les caractéristiques de la deuxième arme :"),
      numericInput("n2",
                  "Nombre de dés :",
                  min = 0,
                  max = 50,
                  value = 0),
      radioButtons("p2",
                   "Précision :",
                   c("6+" = 6, "5+"=5, "4+"=4, "3+"=3, "2+"=2))
      
  ),
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("histPlot")
    )
  )
))