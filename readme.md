# Zombicide_shinyapp
A shiny app helping Zombicide players to choose the best equipment:

- [Zombicide App in english](https://felixpr.shinyapps.io/Zombicide_app_en/ "https://felixpr.shinyapps.io/Zombicide_app_en/")
- [Zombicide App en français](https://felixpr.shinyapps.io/ZombieApp/ "https://felixpr.shinyapps.io/ZombieApp/")

Here, you'll find information about this app:
 - [Intro and mental calculation tricks](https://github.com/FelixPr/Zombicide_shinyapp#do-you-like-board-games)
 - [The maths behind the app](https://github.com/FelixPr/Zombicide_shinyapp#lets-do-the-math)
 - [Shiny, a web application framework for R](https://shiny.rstudio.com/)

## Do you like board games?
I do! And one of my favorite is Zombicide. You don't know this game? If you like collaborative strategic games and nice miniatures, you should check it [here!](https://zombicide.com/en/ "zombicide.com") I personnaly prefer the medieval version called *Black Plague*. That's why I'm going to talk about swords and bows, and not about contemporary weapons. 

In this game, you play survivors who try killing zombies. Rules are simple: when you attack, **you roll a few dice** and **you kill** a zombie **for every die which gets the minimum score needed.** The number of dice and the needed score depend on your equipment and your survivors' abilities. At some point, you get new weapons, new abilities, and you start wondering if you should use this longbow you just found or if the crossbow is still more effective...

Most of the time, the answer is obvious, but it can get more tricky... and that's why I built this app!

First of all, keep in mind that **first rule is __"have fun"__**. If you picked a warrior and you want to use the great sword instead of this piece of paper your fellow survivors call "Inferno", go ahead, risk your survivor's life! You're not supposed to optimize everything anyway. This app is meant to help answering questions you are curious about. Don't use it every time you attack.
In fact, it's best if you don't use it during your turn. You shouldn't slow down the game with that. It's clear that if you spend the whole game checking the app, you won't have fun. And if you do, stop killing zombies. Start doing math. Humanity (and your fellow gamers) will be thankful.

## Mental calculation tricks
Before checking the whole formula, let's see why I think that most of the time, the answer is obvious. And don't worry, there's not that much math in it.

The first thing you want to do is to **compare weapons.** To do so, a good idea is often to compare the **average number of zombies you can kill.** And you can easly calculate it mentally.

First, you **calculate the number of faces that give you a hit** for one die. If you need 5 or more, there are 2 faces you want to see, the 5 and the 6. If you need 2 or more, there are 5 winning faces. Ok, easy. **Then you multiply by the number of dice** you'll roll. You end up with a number that you can use to compare weapons.
For example, 2 dice and a score of 3 or more needed (I'll write this "2/3+" from now on), gives *2x4 = _8_*. It beats 3/5+ which gives *3x2 = _6_*, but 3/4+ is better (*3x3 = 9*). Really easy!
And if you want something more concrete, you divide by 6 and you get the average kills you can expect (8/6 = 1.25, 6/6 = 1 and 9/6 = 1.33 with our example).

That said, if you want to compare very different attacks, don't forget to include everything. For example, your sword can be more effective but you'll need 1 action to get closer to zombies and you'll have 2 actions left for the attack. If you don't move and you use your bow instead, you can spend your 3 actions shooting zombies. In this case, you should multiply the sword's score by 2 and the bow's score by 3 to calculate a global score for your whole turn and make the right choice...

There are still cases that are a bit more complex. For example, when there is only a few zombies in the area, it becomes less interesting to roll a lot of dice and precision becomes more important. No need to say that precision is also very important when you try shooting zombies that are fighting  friends of yours. Yes, you can do so in the *Black Plague* version! But for every losing die, you hit your friend. I mean your former friend. Another complex situation is when you can reroll... Specific items or abilities allow you to reroll *every* dice if you don't like your first roll. That's because of these situations that we may need to do the math from time to time.

## Let's do the math
Do you know [Jacob Bernoulli?](https://en.wikipedia.org/wiki/Jacob_Bernoulli "Check on Wikipedia") He worked on our problem in the XVIIth century. No kidding!

Every single die-roll is what mathematicians call a [Bernoulli trial](https://en.wikipedia.org/wiki/Bernoulli_trial "Check on Wikipedia"), i.e. a random experiment with two possible outcomes: success or failure. In zombicide, a success means you kill a zombie and it happens when you get more than the precision of your weapon, or equal. The probability of success is given by the number of winning faces *(7-precision)* divided by 6, the total number of faces: *probability(success) = (7 - precision) / 6*
   

When you roll a few dice, you have what mathematicians call a [Bernoulli process](https://en.wikipedia.org/wiki/Bernoulli_process "Check on Wikipedia"). The probability to get exactly *k* successes among *n* trials with a *p* success probability is:

-   **probability(nb_success = k) = B(n, k) \* p^k \* (1-p)^(n-k)**  
   *where B(n, k) is the Binomial coefficient: B(n, k) = n! / ( k! \* (n-k)! )* 
 
That said, it's easy to calculate the probability to kill *z* zombies with a *n/pc+* weapon (roll *n* dice and try to get *pc* or more): 
-   **probability(killed_zombies = z) = B(n, z) \* ((7-pc)/6)^z \* ((pc-1)/6)^(n-z)** 
   
This formula gives the height for every bar in the barplot.

Then we can easily take into account the maximum number of zombies you can kill. We just need to sum every *probability(killed_zombies >= max_zombies)* to get the new *probability_with_max(killed_zombies = max_zombie).* No scoop here.

**Reroll is a bit trickier...** First, we have to define a reroll strategy. Some players tend to reroll often and others hesitate more. As for me, I decided than a smart strategy would be to *reroll everytime the first roll is below average.* First, I compute the probability without reroll (that's the first roll) and the average killed zombies. Then, I compare the score I got and what I could have expected, i.e. the average killed zombies. If I'm above, I'm lucky and I keep it. If I'm not, I reroll, and I get another chance to get above average.
Let's write **BL = probability_no_reroll(z < average_z)**, where *BL* stands for *bad luck* and *z* is the number of killed zombies. If I get *bad_z < average_z* after reroll, it means I wasn't lucky with the first roll AND I got *bad_z* when I rerolled: 

 -  **probability_reroll(bad_z | bad_z < average_z) = BL \* probability_NO_reroll(bad_z)**
   

On the other hand, they are two ways to get *good_z >= average_z:* I was lucky with the first roll and I got *good_z* OR I wasn't but I rerolled and I got *good_z:*

   *probability_reroll(good_z | good_z >= average_z) = probability_NO_reroll(good_z) + BL x probability_NO_reroll(good_z)*
   
-   **probability_reroll(good_z | good_z >= average_z) = probability_NO_reroll(good_z) \* (1 + BL)**
   

And that's it! We have everything needed to built this app. Or at least, here are the theorical tools. If you check the code, you'll see that most of it is the user interface that I built with [Shiny](https://shiny.rstudio.com/), a very handy web application framework for R. It's easy to use and well-documented. I let you check the link if you're interested! 
