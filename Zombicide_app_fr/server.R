library(shiny)
library(ggplot2)
library(scales)

proba <- function(n, p, z) {
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
    n <- input$n
    p <- as.numeric(input$p)
    n2 <- input$n2
    p2 <- as.numeric(input$p2)
    nmx <- max(n, n2)
    zombiesDispo <- input$zombiesDispo
    zmx <- min(zombiesDispo, nmx)
    
    arme_1 <- seq(0, 0, length=zmx+1)
    arme_2 <- seq(0, 0, length=zmx+1)
    succès <- 0:zmx
    
    for (i in 1:(n+1)) {
      if (i<=zmx) {
        arme_1[i] <- proba(n, p, i-1)
      }
      else {
        arme_1[zmx+1] <- arme_1[zmx+1] + proba(n, p, i-1)
      }
    }  
    
    if (n2!=0) {
      for (i in 1:(n2+1)) {
        if (i<=zmx) {
          arme_2[i] <- proba(n2, p2, i-1)
        }
        else {
          arme_2[zmx+1] <- arme_2[zmx+1] + proba(n2, p2, i-1)
        }
      }
    }
    
    # draw the histogram
    probabilité <- c(arme_1, arme_2)
    zombies_tués <- c(succès,succès)
    arme <- as.factor(c(seq(1,1,length=zmx+1), seq(2,2,length=zmx+1)))
    
    dat <- data.frame(probabilité, zombies_tués, arme)
    
    if (n2!=0) {
      d1 <- ggplot(data=dat, aes(x=zombies_tués, y=probabilité, fill=arme, label = percent(probabilité))) +
        geom_bar(stat="identity", position=position_dodge(), width=.8) + 
        geom_text(aes(y = probabilité + 0.02), position = position_dodge(0.8), size=3) +
        scale_y_continuous(labels = percent_format()) +
        scale_x_continuous(breaks=0:max(zombies_tués)) +
        theme(axis.text.y=element_blank(),
              axis.ticks = element_blank(),
              axis.ticks.y=element_blank()) +
        scale_fill_discrete(name="Zombies tués\nen moyenne :",
                            breaks=c("1", "2"),
                            labels=c(paste("Arme 1 : ", round(sum((probabilité*zombies_tués)[dat$arme==1]), 2), sep =""),
                                     paste("Arme 2 : ", round(sum((probabilité*zombies_tués)[dat$arme==2]), 2), sep =""))) +
        xlab("Zombies tués") + 
        ylab("Probabilité")
    }
    else {
      d1 <- ggplot(data=dat[dat$arme==1, ], aes(x=zombies_tués, y=probabilité, fill=arme, label = percent(probabilité))) +
        geom_bar(stat="identity", position=position_dodge(), width=.8) + 
        geom_text(aes(y = probabilité + 0.02), position = position_dodge(0.8), size=3) +
        scale_y_continuous(labels = percent_format()) +
        scale_x_continuous(breaks=0:max(zombies_tués)) +
        theme(axis.text.y=element_blank(),
              axis.ticks = element_blank(),
              axis.ticks.y=element_blank()) +
        scale_fill_discrete(name="Zombies tués\nen moyenne :",
                            breaks=c("1", "2"),
                            labels=c(paste("Arme 1 : ", round(sum((probabilité*zombies_tués)[dat$arme==1]), 2), sep =""),
                                     paste("Arme 2 : ", round(sum((probabilité*zombies_tués)[dat$arme==2]), 2), sep =""))) +
        xlab("Zombies tués") + 
        ylab("Probabilité")
    }
    d1
  })
  
})