library(shiny)
library(ggplot2)
library(scales)

# Define UI for application that draws a histogram
shinyUI(
  fluidPage(
    
  # Application title
  titlePanel("Zombicide"),
  
  fluidRow(
    # Left panel
    column(3,
           # Attack 1
           wellPanel(
             h4("Attaque 1"),
             numericInput("n",
                          "Nombre de dés :",
                          min = 1,
                          max = 50,
                          value = 3),
             sliderInput("p",  "Précision :", 2, 6, 5, post = "+" ),
             checkboxInput("reroll1", label = "Relance autorisée", value = FALSE)
           ),
           
           # Attack 2
           wellPanel(
             h4("Attaque 2"),
             numericInput("n2",
                          "Nombre de dés :",
                          min = 0,
                          max = 50,
                          value = 0),
             sliderInput("p2",  "Précision :", 2, 6, 5, post = "+" ),
             checkboxInput("reroll2", label = "Relance autorisée", value = FALSE)
           ),
           
           # Max zombies
           wellPanel(
              numericInput("avbZombies",
                          "Zombies sur la case ciblée :",
                          min = 1,
                          max = 50,
                          value = 36)
           
           )
  ),
  
  # Right panel
  column(9,
         
         # Histogram
         plotOutput("histPlot"),
         
         # Text and link
         wellPanel(
           h5("Conseils d'utilisation : "),
           h5(" - Si tu as plus de dés à lancer que de zombies à tuer, utilise la troisième box 
              pour entrer un nombre maximum. Tu verras que ça change légèrement les calculs."),
           h5(" - Les probabilitées avec relance sont calculées en faisant l'hypothèse que 
              l'on relance si et seulement si le premier jet est en dessous de la moyenne."),
           h5(a("Tu veux savoir comment ça marche ? Clique ici !", 
                href="https://github.com/FelixPr/Zombicide_shinyapp", target="_blank")
              )
           )
         )
  )
  )
)
