###############################################################
# Load libraries
###############################################################
library(shiny)
library(ggplot2)
library(scales)

###############################################################
# Tool box
###############################################################
# 1/ Calculate the probability of killing z zombies
#   assuming you roll n dices and need a p score
proba <- function(n, p, z) {
  
  # The formula is given by Bernoulli 
  choose(n, z)*(p-1)^(n-z)*(7-p)^z/6^n
}
###############################################################
# 2/ Calculate probability array for an attack
#     no reroll authorized
odds_no_reroll <- function(n, p, zmx){
  
  # initialize the array
  attack <- seq(0, 0, length=zmx+1)
  
  # calculate the odds
  for (i in 1:(n+1)) {
    if (i<=zmx) {  # if i<=zmx, no problem, I can calculate the odds
      attack[i] <- proba(n, p, i-1)  # probability to kill (i-1) zombies
    }
    else {  # if i>zmx, I can't kill i zombies and I'll kill zmx zombies instead
      attack[zmx+1] <- attack[zmx+1] + proba(n, p, i-1)
    }
  }
  
  # output the array
  attack
}  
###############################################################
# 3/ Calculate probability array for an attack
#      reroll taken into account
calculate_odds <- function(n, p, zmx, r) {
  
  # calculate probability without reroll
  attack <- odds_no_reroll(n, p, zmx)
  
  # if needed, calculate probability with reroll
  if (r) {
    # calculate threshold, i.e. the max score bellow average
    threshold <- trunc(sum(attack*(0:zmx)))
    
    # calculate bad luck probability, i.e. probability to get a score bellow the average 
    BL <- sum(attack[1:(threshold+1)])  # sum the odds to kill from 0 to 'threshold' zombies
    
    # calculate new odds
    attack[1:(threshold+1)] <- attack[1:(threshold+1)]*BL
    attack[(threshold+2):length(attack)] <- attack[(threshold+2):length(attack)]*(1 + BL)
  }
  
  # output the array
  attack
}
###############################################################
# ShinyServer function
## Define server logic required to draw a histogram
###############################################################
shinyServer(function(input, output) {
  output$histPlot <- renderPlot({
  
    # init variables    
    n1 <- input$n  # number of dices for the first weapon
    p1 <- as.numeric(input$p)  # precision of the first weapon
    n2 <- input$n2  # number of dices for the 2nd weapon
    p2 <- as.numeric(input$p2)  # precision of the 2nd weapon
    nmx <- max(n1, n2)  # max rolled dices
    avbZombies <- input$avbZombies  # number of zombies in the targeted area
    zmx <- min(avbZombies, nmx)  # max kills you can get
    success <- 0:zmx  # an array that store the possible numbers of success, i.e. zombies killed
    r1 <- input$reroll1  # can you reroll attack 1?
    r2 <- input$reroll2  # can you reroll attack 2?
    
    # calculate the odds for each attack
    attack_1 <- calculate_odds(n1, p1, zmx, r1)
    attack_2 <- calculate_odds(n2, p2, zmx, r2)
    
    # create the dataset
    probability <- c(attack_1, attack_2)  # put the odds together
    zombie_kills <- c(success,success)    # create zombie_kills column
    attack <- as.factor(c(seq(1,1,length=zmx+1), seq(2,2,length=zmx+1))) # create the factors 
    dat <- data.frame(probability, zombie_kills, attack)
    
    # draw the histogram
    if (n2!=0) {  # if there're 2 attacks
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
                            labels=c(paste("attaque 1 : ", round(sum((probability*zombie_kills)[dat$attack==1]), 2), sep =""),
                                     paste("attaque 2 : ", round(sum((probability*zombie_kills)[dat$attack==2]), 2), sep =""))) +
        xlab("Zombies tués") + 
        ylab("Probabilités")
    }
    else { # now there's only one attack
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
                            labels=c(paste("attaque 1 : ", round(sum((probability*zombie_kills)[dat$attack==1]), 2), sep =""),
                                     paste("attaque 2 : ", round(sum((probability*zombie_kills)[dat$attack==2]), 2), sep =""))) +
        xlab("Zombies tués") + 
        ylab("Probabilités")
    }
    
    # render the plot
    d1
  })
})
      