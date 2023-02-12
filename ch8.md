# Chapter 8: Time & Scenes

Lots of interactive fiction
games take place in a sort of “eternal now.” The player is free to
wander around, trying whatever commands she thinks of. No matter how
many turns she takes, nothing changes in the model world except when she
takes an action that changes it.

In other games, though, the passage of time has some effect on the
game-play. That is, the game counts the number of turns the player
spends doing things, and makes some change after a set number of turns.
For instance, the sun might set, in which case outdoor rooms would
become dark. In almost all games, nothing whatever happens between the
player’s commands: time passes only when the player does something. A
very few games include some sort of “real time” routine to force the
player to type the correct command within a few seconds, but these games
are quite rare, and we’re not going to worry about them in this
book.

Inform has three systems with which you can organize the passage of
time of your game. In this chapter we’ll look at all of them.

## Passing Time

Inform doesn’t do anything to mark the passage of time in a game
unless you tell it to. All the same, it’s quietly keeping track of the
number of turns that have passed since the beginning of the game. Unless
you write some code that changes the default, Inform starts the game at
9:00 A.M. Each time the player enters a sensible command, one minute
passes. But if the player types something that the parser doesn’t
understand, no time passes.

A simple way to see this mechanism in action is to add this code to
your game:

```
When play begins:
	now the right hand status line is "[time of day]".
```


The status line is
the bar across the top of the game window. Normally (unless you do
something to change it), the right side of the status line is empty, but
this code can be used to show the number of points the player has earned
(“[score]”), for example. The code above changes the status line to show
the time of day. For more, see [WI 8.3: Changing the status line](../WI_8.html#section3).

As a courtesy to the player, you might want to have no time pass when
the player is simply using the LOOK command to refresh her memory about
the room, or the INV (or I) command to remind herself what she’s
carrying. To do that, use this code:

```
Every turn:
	if the current action is taking inventory or the current action is looking:
		now the time of day is 1 minute before the time of day.
```


We’ll have more to say about Every Turn rules later in this chapter.
Another way to do the same thing is to use a Before rule rather than an
Every Turn rule:

```
Before looking or taking inventory:
	now the time of day is 1 minute before the time of day.
```


The downside of using a
Before rule in this case is that the first action when a game starts is
a look action. That’s what causes the initial room description to print.
So if you use a Before rule in this case, the game will be starting one
minute before you think it does, which could be a problem in a game that
opens with a tight timing puzzle.

[Example 408: Timeless](../examples/timeless.html), shows a different way to accomplish the same
thing.

The game doesn’t have to start at 9:00 A.M. If you want it to start
at 3:00 in the afternoon, do this:

```
When play begins:
	now the time of day is 3:00 pm.
```


If you want time to jump ahead for some reason (such as when the
player character has been hit on the head and is unconscious for a
while), include a line like this in your code as part of what happens
when the player is hit:

```
now the time of day is 7:00 pm.
```


If you want something to happen at a specific time, one way to do it
– the primitive, clumsy way, as I’ll explain in a moment – is with an
Every Turn rule:

```
Every turn:
	if the time of day is 11:59 pm or the time of day is 12:59 am or the time of day is 1:59 am:
		say "In the distance you hear the chimes in the tower strike the hour."
```


As you can see, I’ve set the chimes to ring one minute
*before* the hour. This is because of the way Inform runs your
Every Turn rules. Every Turn rules run before the Advance Time rule. If
you do it as shown above, the message about the chimes in the tower will
be printed out on the hour.

In this case, Inform has a simpler way to get the same effect. You
can write a rule that tells the game what to do at specific times:

```
At 11:59 pm: say chimes.
At 12:59 am: say chimes.
At 1:59 am: say chimes.

To say chimes: say "In the distance you hear the chimes in the tower strike the hour."
```


This way of doing it is easier to write and debug, especially when
you want the chimes to ring every hour for 24 hours, rather than only at
three times, as shown.

The main reason to want to keep track of the current time (and let
the player know what time it is) is because time is passing in the model
world. In some games, the player character will get hungry and/or
thirsty on a regular schedule, so finding food and water will be one of
the puzzles. If the game includes a realistic alternation of day and
night, at a certain time in the evening the player might need to find a
place to sleep. Some people consider eating and sleeping puzzles
old-fashioned, but timed puzzles can be interesting if handled in a
creative way.

## Future Events

[WI 9.11: Future
events](../WI_9.html#section11) shows how to cue up events that will happen at a certain time
in the future. For the next example, I’ll borrow some code from the
chapter of the *Handbook* on characters. When the player tries to
take the spider, not only the game prevent the action, but there will be
an after-effect – a sort of emotional echo of the intended action:

```
Instead of taking the spider:
	say "You can't bring yourself even to get near it.";
	the spider thought returns in four minutes from now.

At the time when the spider thought returns:
	say "You're still thinking about that creepy spider…"
```


Here I’ve created a new phrase, “the spider thought returns,” and
told Inform what to do when that event happens. There are two ways to
cue this action: You can say “in four minutes from now” or “in four
turns from now” (substituting your own number of turns or minutes,
obviously). If you’re making adjustments in the time of day, as shown
earlier in this chapter in the section “Passing Time,” four minutes from
now will *not* necessarily be the same as four turns from now.
The handy thing about this code is that the spider thought time will be
reset if the player tries to take the spider several times in a row: The
thought return will happen only once. If the player then tries to take
the spider *after* the thought has returned the first time, the
thought can return a second time.

If you need to trigger a more complex series of events rather than
something that happens once, using Scenes (see below) will give you
better tools.

If you want something to *maybe* happen in the future,
depending on some factor, you can use Inform’s handy “do nothing”
phrase. The example below was suggested by one of my students, who
wanted to transform a magic wand into an old shoe – but only if the
player has been carrying the wand for three turns in a row.

```
The Wizard's Workshop is a room. "This odd-smelling little room is crowded with tables and shelves overflowing with magical implements."

The magic wand is in the Wizard's Workshop. "A Wham-O(tm) magic wand lies on the floor." The description is "It's a shiny black plastic wand on which the words 'Wham-O' are written in flowing white script."
Understand "wham-o", "shiny", "black", and "plastic" as the magic wand.

The old shoe is a thing. The description is "It looks like somebody left it lying in the gutter."

After taking the magic wand:
	the wand transforms in three turns from now;
	continue the action.

At the time when the wand transforms:
	if the player does not carry the wand:
		do nothing;
	otherwise:
		remove the magic wand from play;
		now the player carries the old shoe;
		say "The wand quivers and squirms in your hand! Suddenly it's not a wand, it's an old shoe!"
```


Here, we start Inform’s internal “alarm clock” ticking when the
player takes the magic wand, using an After rule. If the player isn’t
carrying the wand when the “alarm clock” goes off, nothing happens. And
if the player drops the wand and picks it up again, Inform will
automatically reset the clock. The wand will only transform if it’s
carried for three turns in a row. Obviously, this type of scheduling of
future events has many other uses. In the code above, the transformation
can occur only once, because the wand ends up off-stage as a result of
the transformation. If you’re planning to use teleportation (moving the
wand somewhere interesting) rather than transformation, you’ll need to
think closely about what happens if the player triggers the event again
later.

## Scenes

One of the more powerful features of Inform is its ability to
organize the story into scenes. An entire chapter of *Writing with
Inform*[ (Chapter 10, “Scenes”)](../WI_10.html), is devoted to scenes. If you haven’t
read this chapter yet, give it a look. Some games won’t need scenes at
all, but scenes can be very handy for giving your story some structure.
Almost any time you need to create a complex, well-coordinated set of
changes in the model world, defining a scene is a good tool for the
job.

To create a scene, you simply give it a name, and then tell Inform
when it starts – that is, what set of events or circumstances triggers
it. You can also, optionally, tell Inform when the scene ends. By
default, a scene will happen only once. If you want it to be able to
happen over and over, you need to create it as a *recurring*
scene.

Why might you want to use a scene? Here are some random ideas:

```
Saucer-menace is a scene. Saucer-menace begins when the flying saucer is in the Meadow. Saucer-menace ends when the bug-eyed monster is dead.

Guard-evasion is a scene. Guard-evasion begins when the security guard is suspicious. Guard-evasion ends when the player is in the Bank Vault for the first time. 

Dance mania is a scene. Dance mania begins when the player is in the Abandoned Warehouse for the first time. Dance mania ends when the police sergeant is in the Abandoned Warehouse.
```


When a certain scene starts, you might want to rearrange the objects
in the model world, shuffling some items offstage and others onstage.
While the scene is happening, you might want to restrict the player’s
travel, or print out certain atmospheric messages (as shown in
[WI 10.4: During
scenes](../WI_10.html#section4)). While a scene is happening, the magical weapons the player is
carrying might have different effects than at other times. The
possibilities are unlimited.

You can’t start a scene simply by saying that it starts:

```
now guard-evasion is happening; [Error!]
```


Nor can you end a scene by saying that it ends. The way to start or
end a scene is to tie it to a condition, as shown above:

```
Guard-evasion begins when the security guard is suspicious.
```


The condition can be as simple as whether a truth state that varies
(a true-or-false variable) is true or false. You could do it this
way:

```
Guard-evasion-flag is a truth state that varies. Guard-evasion-flag is false.

Guard-evasion is a scene. Guard-evasion begins when guard-evasion-flag is true.
```


Having set it up this way, you can start the scene whenever or
wherever you like by writing:

```
now guard-evasion-flag is true;
```

### Chaining Scenes

[WI 10.5: Linking
scenes together](../WI_10.html#section5) gives this simple example of how to chain two
scenes:

```
Train Stop is a scene. Brief Encounter is a scene. Brief Encounter begins when Train Stop ends.
```

From this code, we can’t tell what events will cause Train Stop to
begin or end, but we can see that Brief Encounter will begin immediately
when Train Stop ends.

Setting up a new scene so that it starts a certain number of turns
after a previous scene ends is a little trickier. First, we need to
create a truth state. Second, we need to write a simple function that
will switch the truth state to true. Third, we need to tell Inform to
run the function at some time in the future. Here’s an example that
shows how to do it:

```
The Antechamber is a room. "The princess's boudoir lies to the south."

The Princess's Boudoir is south of the Antechamber. "This luxuriously appointed chamber is fit for a princess."

The princess is a woman in the Boudoir. "…and as it happens, a princess is sitting here right now!"

The player carries some crown jewels. The indefinite article of the crown jewels is "the".

Princess Demanding is a recurring scene. Princess Demanding begins when the player is in the Boudoir and the player carries the crown jewels.

Princess Demanding ends when the player does not carry the crown jewels.

Instead of going during Princess Demanding:
	say "'You're not going anywhere until you surrender the jewels!' the princess insists."

When Princess Demanding begins:
	say "'I notice you're carrying the crown jewels,' the princess says. 'Give them to me at once!'"

Instead of giving the jewels to the princess:
	now the princess carries the jewels;
	say "You surrender the jewels. The princess smiles sweetly. 'Thank you,' she says. 'You may go.'"
```


Here we’ve created a scene called Princess Demanding. The point of
this scene is the “Instead of going” rule. This rule gets in the way if
the player tries to leave the boudoir with the jewels. Other than this,
the scene is transparent – that is, it has no effect on game-play. The
player can drop the jewels or give them to the princess. At that point,
the scene ends (because we’ve written a rule that defines this as ending
the scene).

The keyword “during” in this Instead rule lets us write code that
will make sweeping changes in many aspects of the game depending on
whether a certain scene is happening.

We’ve made Princess Demanding a recurring scene. This is necessary.
If you leave out the word “recurring,” the player can get away with the
jewels by dropping them in the boudoir and then picking them up again.
When they’re dropped, the scene ends – and if it’s not a recurring
scene, it will never start again.

Let’s look at this scene more closely. It looks sensible on the
surface, but in fact there are some problems. By analyzing the problems,
you can start to get a better picture of how to write trouble-free
code.

In a real game the player would quite likely be able to figure out a
way to abscond with the jewels, even after the princess has noticed
them. Can you spot the problem? If you’ve read the section in Chapter 3
on “Testing Where a Thing Is,” you may recall that the condition “if the
player carries the crown” is only true if the crown is in the PC’s hands
– that is, if it’s directly carried. The bug will show up if we give the
player a container for carrying things:

```
The sack is a container. The player carries the sack.
```


Now the player can walk into the boudoir, which will cause the
princess to notice the jewels, and then put the jewels in the sack and
walk straight out again. Oops! The fix for this bug is simple. We change
“carries” in the end-of-scene statement to “encloses”:

```
Princess Demanding ends when the player does not enclose the crown jewels.
```


If you make these changes, the player will be able to put the jewels
in the sack and then enter the boudoir, and the princess will let him
leave again. Presumably, she hasn’t noticed the jewels because they’re
in the sack. But once the jewels are not in the sack but in the PC’s
hands, she’ll see them. At that point, putting them back in the sack
won’t help. The princess will still demand that they be turned over.

But there’s still a problem. Try this series of commands:

```
Test me with "s / put jewels in sack / drop sack / take sack / n".
```


The princess will notice the jewels … but you can still get away
with them by putting them in the sack, dropping the sack, and picking it
up again, because the Princess Demanding scene won’t start again as long
as the jewels are in the sack. Ah, but we don’t want to change the
definition of the start of the scene so that it uses “encloses” rather
than “carries,” because that would cause the princess to notice the
jewels for the first time even if they’re in the sack. What a
tangle!

The solution is in two parts. First, we need to keep track of what
the princess knows. In addition, we’ll create a second scene, Princess
Still Demanding. This scene will do the work of stopping the player from
leaving – and it will have a more complicated beginning. Here’s the
revised part of the code:

```
The princess is a woman in the Boudoir. "…and as it happens, a princess is sitting here right now!"
The princess can be jewel-knowing or jewel-ignorant. The princess is jewel-ignorant.

When Princess Demanding begins:
	now the princess is jewel-knowing.

The player carries some crown jewels. The indefinite article of the crown jewels is "the".

The sack is a container. The player carries the sack.

Princess Demanding is a scene. Princess Demanding begins when the player is in the Boudoir and the player carries the crown jewels.

Princess Still Demanding is a recurring scene. Princess Still Demanding begins when the player is in the boudoir and the player encloses the crown jewels and the princess is jewel-knowing.

Princess Demanding ends when Princess Still Demanding begins.

Princess Still Demanding ends when the player does not enclose the crown jewels.

Instead of going during Princess Still Demanding:
	say "'You're not going anywhere until you surrender the jewels!' the princess insists."
```


The first thing we’ve done here is give the princess a new either-or
property. She can be jewel-knowing or jewel-ignorant. At the beginning
of the game she’s jewel-ignorant. But when Princess Demanding begins,
she becomes jewel-knowing. The moment she becomes jewel-knowing, the
game switches to a different scene, Princess Still Demanding.

If you add this code to the original version of the example, the
player will be able to go in and out of the boudoir freely carrying the
jewels in the sack. But once the princess spies the jewels, the player
will be prevented from leaving whether the jewels are directly carried
or are being carried in a container.

There’s still at least one more problem with this example game, which
illustrates just how tricky writing IF can be. If the player drops the
jewels on the floor, the princess will just leave them lying there.
She’ll let you leave, but if you leave the boudoir and come back, you’ll
find that the jewels are still lying on the floor in plain sight. A
writer of conventional fiction might describe this by saying that the
princess’s motivation (her reasons for her actions) is not consistent.
We can fix this with an Every Turn rule:

```
Every turn:
	if the holder of the crown jewels is the Boudoir:
		now the princess carries the crown jewels;
		say "The princess scoops up the jewels. 'These belong to my family,' she says, adding haughtily, 'you may go.'"
```


As an exercise, I’ll leave you the chore of setting it up so that if
the princess is jewel-knowing, the jewels are in the sack, and the sack
is on the floor of the boudoir, the princess will take the jewels from
the sack. The moral of the story is this: When planning an action, think
about *all* of the actions a player might take. Think about all
of the configurations the various objects might get into. Also, think
about how any other characters in the room would naturally react when
the PC does something or other.

## Every Turn Rules

We’ve already seen a couple of examples of Every Turn rules. As you
can guess from the name of the rule, an Every Turn rule is consulted
every turn to see whether it would like to do anything. This rule is
consulted as the *last* step in the process that starts when the
player types a command. The output of an Every Turn rule will normally
appear at the bottom of a block of text in the game, after the
description of whatever happens as a result of the player’s latest
command.

An Every Turn rule can print out some text, or it can do something
more complicated. Printing out some text is a nice way to add atmosphere
to your game, but a message that prints every turn will quickly become
annoying. Here’s an Every Turn rule that adds atmosphere to a forest
setting in a slightly more interesting way. Sometimes it chooses a
random text to print, and sometimes it does nothing:

```
Every turn:
	if a random chance of 1 in 3 succeeds:
		say "[one of]A dragonfly darts past you.[or]You hear a frog croaking.[or]A bird chirps in the bushes.[or]The breeze rustles the leaves.[at random]".
```


But even with a bit of randomness, this type of Every Turn rule will
get boring before very long. A better solution is to write an Every Turn
rule that only runs when a certain scene is happening, or when the
player is in a certain region. If we have defined the Forest Area as a
region, we could rewrite the rule above like this:

```
Every turn when the player is in the Forest Area:
```


If we’ve created a scene called Forest Explorations, we could do it
this way:

```
Every turn during Forest Explorations:
```


In fact, if you’re concerned about writing efficient code so that
your game won’t be sluggish when played in the current generation of Web
browsers (and this is something to be concerned about), qualifying your
Every Turn rules in this way, so that they’re only consulted by the game
when specific scenes are active, is a good idea.

We can also write an Every Turn rule that will produce some narrative
or background text at specific points within a scene. Here, the phrase
“exactly three turns” will insure that the output text is produced only
once (unless the scene is recurring, in which case it will be produced
once per recurrence):

```
Every turn:
	if Saucer Menace has been happening for exactly three turns:
		say "You hear an odd glorping noise somewhere nearby.";
	otherwise if Saucer Menace has been happening for exactly five turns:
		say "Was that a tentacle you saw slithering out of sight?"
```


An Every Turn rule can also wait quietly in the background, checking
for a certain set of conditions, and then do something when the
conditions are met. Here’s a simple game that shows how the idea might
work:

```
The Throne Room is a room. "The king's golden throne stands here."

The golden throne is an enterable scenery supporter in the Throne Room. The description is "A magnificent golden throne."

The jewelled sceptre is here. The sparkling crown is here. The crown is wearable.

Every turn:
	if the player wears the sparkling crown and the player carries the jewelled sceptre and the player is on the golden throne:
		say "You're the king!!!";
		end the story saying “Congratulations!”
```


Every turn, this rule checks to see whether the player has done all
three things that are needed to win: the player has to be carrying the
sceptre and wearing the crown while sitting on the throne. You could get
the same results using After rules for three different actions (after
taking the sceptre, after wearing the crown, and entering the throne),
and test in each of the After rules for whether the other two conditions
were satisfied – but using an Every Turn rule is less likely to lead to
a bug, because you can test all three conditions in one place. And if
you need to edit the code for some reason, you only need to edit it in
one place; you don’t need to hunt for every spot in the code where that
condition is being checked.

Here’s another way to get the same result:

```
Every turn when the player is on the golden throne:
	if the player wears the sparkling crown and the player carries the jewelled sceptre:
		say "You're the king!!!";
		end the story saying “Congratulations!”
```


As this example shows, an Every Turn rule can include a test in its
first line. If we’re writing a game in which the player needs to eat
periodically, we might do something like this:

```
A person can be hungry or not hungry. A person is usually not hungry.
The player has a number called hunger-level. The hunger-level of the player is 0.
Every turn when the player is hungry:
	increase the hunger-level of the player by 1;
	say "[one of]Your stomach is rumbling.[or]You're becoming quite hungry.[or]You're very hungry. You need to find food soon.[or]You're practically starving![stopping]";
	if the hunger-level of the player is 7:
		end the story saying "You have starved to death!"
```


Switching the player to hungry would happen elsewhere in the code. In
this example we’ve added something new – a counter (hunger-level) that
keeps track of how long the player has been hungry, and ends the game
after a set number of turns. When the player eats food, your code would
both switch the player to not hungry and reset the hunger-level of the
player to 0.
