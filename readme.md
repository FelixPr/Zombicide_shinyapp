# Zombicide_shinyapp
A shiny app helping Zombicide players to choose the best equipment:

https://felixpr.shinyapps.io/ZombieApp/

## Do you like board games?
I do! And one of my favorite is Zombicide. You don't know this game? If you like collaborative strategic games and nice miniatures, you should check it [here!](https://zombicide.com/en/) I personnaly prefer the medieval version called *Black Plague*. That's why I'm going to talk about swords and bows, and not about contemporary weapons. 

In this game, you play survivors who try killing zombies. Rules are simple: when you attack, **you roll a few dices** and **you kill** a zombie **for every dice which gets the minimum score needed.** The number of dices and the needed score depend on your equipment and your survivors' abilities. At some point, you get new weapons, new abilities, and you start wondering if you should use this longbow you just found or if the crossbow is still more effective...

Most of the time, the answer is obvious, but it can get more tricky... and that's why I built this app!

First of all, keep in mind that **first rule is always __"have fun"__**. If you picked a warrior and you want to use the great sword instead of this piece of paper your fellow survivors call "Inferno", go ahead, risk your survivor's life! You're not supposed to optimize everything anyway. This app is meant to help answering questions you are curious about. Don't use it every time you attack.
In fact, it's best if you don't use it during your turn. You shouldn't slow down the game with that. It's clear that if you spend the whole game checking the app, you won't have fun. And if you do, stop killing zombies. Start doing math. Humanity (and your fellow gamers) will be thankful.

## Mental calculation
Before checking the whole formula, let's see why I think that most of the time, the answer is obvious. And don't worry, there's not that much math in it.

The first thing you want to do is to **compare weapons.** To do so, a good idea is often to compare the **average number of zombies you can kill.** And you can easly calculate it mentally.

First you **calculate the number of faces that give you a hit** for one dice. If you need 5 or more, there are 2 faces you want to see, the 5 and the 6. If you need 2 or more, there are 5 winning faces. Ok, easy. **Then you multiply by the number of dices** you'll roll. You end up with a number that you can use to compare weapons.
For example, 2 dices and 3 or more needed, that I'll write "2/3+", gives *2x4 = _8_*. It beats 3/5+ which gives *3x2 = _6_*, but 3/4+ is the best (*3x3 = 9*). Really easy!
And if you want something more concrete, you divide by 6 and you get the average kills you can expect (8/6 = 1.25, 6/6 = 1 and 9/6 = 1.33 for our example).

That said, if you want to compare very different attacks, don't forget to include everything. For example, your sword can be more effective but you'll need 1 action to get closer to zombies and you'll have 2 actions left to attack. If you don't move and you use your bow instead, you can spend your 3 actions shooting undeads. In thid case, you should multiply the sword's score by 2 and the bow's score by 3 to make the right choice...

There are still cases that are a bit more complex. For example, when there is only a few zombies in the area, it becomes less interesting to roll a lot dices and precision becomes more important. No need to say that precision is also very important when you try shooting zombies that are fighting  friends of yours (yes, you can do so in the *Black Plague* version). Another complex situation is when you can reroll... That's why we may need to do the math from time to time.

## Let's do the math
work in progress
