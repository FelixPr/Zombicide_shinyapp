library(shiny)
library(ggplot2)
library(scales)

# Calculate the odds. Takes as input :
#  n: number of dices you roll
#  p: precision of the weapon, i.e. the score you need
#  z: number of zombies killed
proba <- function(n, p, z) {
  # The formula is given by Bernoulli 
  choose(n, z)*(p-1)^(n-z)*(7-p)^z/6^n
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot

  output$histPlot <- renderPlot({
  
    # init variables    
    n <- input$n  # number of dices for the first weapon
    p <- as.numeric(input$p)  # precision of the first weapon
    n2 <- input$n2  # number of dices for the 2nd weapon
    p2 <- as.numeric(input$p2)  # precision of the 2nd weapon
    nmx <- max(n, n2)  # max rolled dices
    avbZombies <- input$avbZombies  # number of zombies in the targeted area
    zmx <- min(avbZombies, nmx)  # max kills you can get
    success <- 0:zmx  # an array that store the possible numbers of success, i.e. zombies killed
    
    # arrays that store the odds for every attack
    attack_1 <- seq(0, 0, length=zmx+1)
    attack_2 <- seq(0, 0, length=zmx+1)
    
    # calculate the odds of killing i zombies for the 1st attack
    for (i in 1:(n+1)) {
      if (i<=zmx) {  # if i<=zmx, no problem, I can calculate the odds
        attack_1[i] <- proba(n, p, i-1)
      }
      else {  # if i>zmx, I can't kill i zombies and I'll kill zmx zombies instead
        attack_1[zmx+1] <- attack_1[zmx+1] + proba(n, p, i-1)
      }
    }  
    
    # calculate the odds of killing i zombies for the 2nd attack
    if (n2!=0) { # if there's a 2nd attack, I calculate
      for (i in 1:(n2+1)) {
        if (i<=zmx) { # if i<=zmx, no problem, I can calculate the odds
          attack_2[i] <- proba(n2, p2, i-1)
        }
        else {  # if i>zmx, I can't kill i zombies and I'll kill zmx zombies instead
          attack_2[zmx+1] <- attack_2[zmx+1] + proba(n2, p2, i-1)
        }
      }
    }
    
    # create the dataset
    probability <- c(attack_1, attack_2)  # put the odds together
    zombie_kills <- c(success,success)    # create zombie_kills column
    attack <- as.factor(c(seq(1,1,length=zmx+1), seq(2,2,length=zmx+1))) # create the factors 
    dat <- data.frame(probability, zombie_kills, attack)
    
    # draw the histogram
    if (n2!=0) {  # if there's no 2nd attack
      d1 <- ggplot(data=dat, aes(x=zombie_kills, y=probability, fill=attack, label = percent(probability))) +
        geom_bar(stat="identity", position=position_dodge(), width=.8) + 
        geom_text(aes(y = probability + 0.02), position = position_dodge(0.8), size=3) +
        scale_y_continuous(labels = percent_format()) +
        scale_x_continuous(breaks=0:max(zombie_kills)) +
        theme(axis.text.y=element_blank(),
              axis.ticks = element_blank(),
              axis.ticks.y=element_blank()) +
        scale_fill_discrete(name="Zombies tués\nen moyenne :",
                            breaks=c("1", "2"),
                            labels=c(paste("attack 1 : ", round(sum((probability*zombie_kills)[dat$attack==1]), 2), sep =""),
                                     paste("attack 2 : ", round(sum((probability*zombie_kills)[dat$attack==2]), 2), sep =""))) +
        xlab("Zombies tués") + 
        ylab("probability")
    }
    else { # now there's a 2nd attack
      d1 <- ggplot(data=dat[dat$attack==1, ], aes(x=zombie_kills, y=probability, fill=attack, label = percent(probability))) +
        geom_bar(stat="identity", position=position_dodge(), width=.8) + 
        geom_text(aes(y = probability + 0.02), position = position_dodge(0.8), size=3) +
        scale_y_continuous(labels = percent_format()) +
        scale_x_continuous(breaks=0:max(zombie_kills)) +
        theme(axis.text.y=element_blank(),
              axis.ticks = element_blank(),
              axis.ticks.y=element_blank()) +
        scale_fill_discrete(name="Zombies tués\nen moyenne :",
                            breaks=c("1", "2"),
                            labels=c(paste("attack 1 : ", round(sum((probability*zombie_kills)[dat$attack==1]), 2), sep =""),
                                     paste("attack 2 : ", round(sum((probability*zombie_kills)[dat$attack==2]), 2), sep =""))) +
        xlab("Zombies tués") + 
        ylab("Probabilités")
    }
    
    # render the plot
    d1
  })
})