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
             h4("Attack 1"),
             numericInput("n",
                          "Number of dice:",
                          min = 1,
                          max = 50,
                          value = 3),
             sliderInput("p",  "Precision :", 2, 6, 5, post = "+" ),
             checkboxInput("reroll1", label = "Reroll", value = FALSE)
           ),
           
           # Attack 2
           wellPanel(
             h4("Attack 2"),
             numericInput("n2",
                          "Number of dice:",
                          min = 0,
                          max = 50,
                          value = 0),
             sliderInput("p2",  "Précision :", 2, 6, 5, post = "+" ),
             checkboxInput("reroll2", label = "Reroll", value = FALSE)
           ),
           
           # Max zombies
           wellPanel(
              numericInput("avbZombies",
                          "Number of zombies in the targeted area:",
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
           h5("Tips: "),
           h5(" - If you roll more dice than the number of zombies in the area, use the third 
		   box to enter a maximum number. You'll see means are going to be slightly different."),
           h5(" - Probability with reroll are calculated assuming you reroll if and only if the 
		   first result is bellow the average."),
           h5(a("You want to know how it works? Click here!", 
                href="https://github.com/FelixPr/Zombicide_shinyapp", target="_blank")
              )
           )
         )
  )
  )
)
