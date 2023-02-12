# Chapter 7: Winning & Losing

Inform has no built-in concept of “winning” or “losing” – it’s up to
you to define how your game will end. To end the game, put the phrase
“end the story” in a rule somewhere – perhaps like this:

```
The Forest is a room. "Tall trees stand on all sides."

The gold crown is in the Forest. The description is "The crown is studded with sparkling jewels!"

After taking the crown:
	end the story saying “You have won!”

The player carries a cyanide pill. The cyanide pill is edible.

After eating the cyanide pill:
	end the story saying “Alas, you have died.”
```


An After rule is a good place to end the game, because it gives
Inform a chance to make sure the action actually took place before
ending the game.

If you don’t add your own text to the “end the story” command, Inform
will simply print out “*** The End ***. It’s usually a good idea to
write a line immediately before the “end the story” line, in order to
describe what the player has done to end the game before officially
ending it. We might revise our code like this:

```
After taking the crown:
	say "At last! You've found the gold crown you've been seeking!";
	end the story saying “You have won!”

After eating the cyanide pill:
	say "Moments after ingesting the pill, you begin to feel very, very ill.";
	end the story saying “Alas, you have died.”
```


This is fine as far as it goes, but sometimes the end of a game calls
for something less drastic than the death of the player character.
Depending on the story, maybe the game should detect that the player is
giving up too soon. In that case, you could do this:

```
After taking the crown:
	say "At last! You've found the gold crown you've been seeking!";
	end the story saying “You have won!”

After eating the cyanide pill:
	say "Moments after ingesting the pill, you begin to feel very, very ill.";
	end the story saying “Alas, you have died.”

This is fine as far as it goes, but sometimes the end of a game calls for something less drastic than the death of the player character. Depending on the story, maybe the game should detect that the player is giving up too soon. In that case, you could do this:

Instead of going north in the Forest:
	say "As you wander back down the mountainside toward town, you feel a keen and lingering sense of regret.";
	end the story saying "You have missed the point entirely!"
```


After the phrase “end the story saying”, you can give whatever
message you like. This will appear, surrounded by the rows of asterisks,
when the game ends.

Oddly enough, “end the story” is a phrase that *must* include
the word “the”. More often than not, Inform strips out “the” when
compiling, but here it’s required.

In [WI 9.4: When
play ends](../WI_9.html#section_4), a distinction is made between “end the story” and “end the
story finally.” I haven’t been able to figure out exactly what the
difference is. I suggest just using “end the story” without worrying
about “finally.”

## A Word About Fairness

In the early days of interactive fiction, numerous games were
released that would kill the player without warning. That was part of
the fun (?) – when you opened a door, maybe an ogre would jump out at
you and hit you with his club, and the game was over. If you had been
smart enough to save your game position not too long before, you could
restore the saved game and try to be more careful about the ogre the
second time. If you hadn’t been smart, you might have to spend hours
getting back to that game position again.

Today, many players and authors feel that this type of story event is
more annoying than fun. The trend is to give the player some sort of
advance warning, which might be subtle or obvious, when the player
character is about to get in a dangerous spot. “Dark red stains have
seeped into the floorboards around the door” in the room description
would be a good way to warn the player that opening the door could be
dangerous, and that looking around for a way to do it cautiously would
be a good idea.

It’s all too easy to write a game, even without meaning to, in such a
way that the player can make the game unwinnable. For instance, the
player may need to give the chocolate biscuit to the elf so that the elf
will be willing to part with the silver key … but the biscuit might be
edible, and the player might have eaten it a hundred moves before
meeting the elf. Another example: Maybe the player can’t return to a
region of the map after leaving it. A rope bridge might have fallen the
first time the player crossed it, leaving no way to get back across the
canyon. If the player dropped the gold key on the far side of the
bridge, she won’t be able to go back and get it. If the gold key is
required to open something that’s on *this* side of the canyon,
the game has become unwinnable.

You need to think carefully about where in your story this type of
problem can arise, and decide how you want to handle it. Drawing a
diagram of the flow of the story – of the puzzle structure, in other
words – may be helpful.

One way to handle the situation is to simply not allow the player to
do anything that would make the game unwinnable. If the chocolate
biscuit will be needed later, write something like this:

```
Instead of eating the chocolate biscuit, say "It's a mouth-watering treat, no doubt, but you decide to save it for later."
```


It can be a chore to come up with sensible-sounding reasons why the
player character wouldn’t do something, if it seems a perfectly natural
thing to want to do. After all, the player can’t read your mind, and
doesn’t know what actions or objects will later be needed to win the
game. For variety, I sometimes allow the player to do something that
will turn out to make the game unwinnable, but then add an immediate
message giving a broad hint (which the player is free to ignore) that
that was probably a stupid thing to do:

```
After eating the chocolate biscuit:
	say "You chow down on the delicious biscuit and lick the last of the chocolate from your fingers. Afterward, though, you start to worry. Maybe you shouldn’t have indulged your gluttonous impulses quite so casually.";
	rule succeeds.
```


The player who reads this will probably be smart enough to UNDO the
latest action, thereby retrieving the chocolate biscuit.

## Keeping Score

In a game whose story is serious in tone, awarding points might seem
too frivolous, so you might want to use no scoring. Inform allows the
author, however, to give the player points for doing certain actions. A
way to do this is explained in [WI 9.2: Awarding points](../WI_9.html#section_2). The first step is to put this line
near the top of your source code, along with whatever other Use or
Include options you’ve selected:

```
Use scoring.
```


Among its other effects, this line will cause the current score to be
displayed alongside the turn count in the banner at the top of the game
window. Normally, you would award points in an After rule, like
this:

```
After taking the gold crown for the first time:
	increase the score by 10;
	say "Ah, you've finally gotten your hands on it!"
```


Unless we include “continue the action” at the end of the After rule,
the After rule will halt the action processing *before* the
Report rule has a chance to tell the player that taking the gold crown
has succeeded. So if you’re not going to print out a message of your own
when awarding points, you’ll want to add the line “continue the action”
after awarding the points. This will cause the Report rule to report
“Taken”, “You put the bulb in the socket”, or whatever.

When awarding points, you should get in the habit of always including
the phrase “for the first time” in the rule that awards the points. If
you forget to do this, the player will be able to rack up a huge score
by performing the same action over and over!

Having explained that, however, I’m now going to suggest that you not
do it that way. The reason is because the phrase “for the first time”
applies only the first time the player *attempts* to do
something, whether or not it succeeds. So if the gold crown is in a
locked transparent display case and the player tries TAKE CROWN while
the case is still locked, no points will be awarded, but later, when the
case is unlocked, taking the crown still won’t award any points, because
now it’s not the first time the action has been attempted.

It’s much safer to use one of Inform’s built-in properties,
**handled,** to check whether points should be awarded:

```
After taking the gold crown when the gold crown is not handled:
```


Use “for the first time” to award points *only* when you can
be sure that the action will succeed the first time the player attempts
it.

[Example 136: Mutt's Adventure](../examples/mutts_adventure.html) and [Example 137: No Place Like Home](../examples/no_place_like_home.html) show other ways of awarding points. [WI 9.3: Introducing tables: rankings](../WI_9.html#section_3) shows how to
create a table of rankings that will tell the player how well he or she
is doing. This feature was popular in early IF games, and some authors
still enjoy using it.

Inform doesn’t insist that the number of points awarded for an action
be constant. If you like, you can do this:

```
crown-points is a number that varies. crown-points is 10.

After taking the gold crown when the gold crown is not handled:
	increase the score by crown-points;
	say "Ah, you've finally got your hands on it!"
```


If you’ve set it up this way, you can vary the number of points the
player will gain for taking the crown depending on what else has
happened in the game. You can even award a negative number of points,
thus reducing the player’s overall score. In my first game, “Not Just an
Ordinary Ballerina” (which was written in Inform 6, not Inform 7), I set
up a system that would reduce the number of points the player could gain
by solving each puzzle based on the number of hints the player had
consulted about that puzzle. The only way to get the maximum score for
winning the game was never to consult the hints. This was meant to give
players an incentive to use their ingenuity rather than relying on the
hints.

If your game has scoring, it’s a good idea to keep a list somewhere
of how many points are being awarded for each scored action. Add up the
total possible score. Near the top of your source code, tell Inform the
maximum score, as suggested on [WI 9.2: Awarding
Points](../WI_9.html#section2):

```
The maximum score is 12.
```


### A Treasure Chest

Awarding points when an object is picked up or a room entered is the
usual thing to do in a game. But some classic games require that the
player put the objects that have been found in a treasure chest or
trophy case. Awarding points for this action is slightly tricky, because
the treasure chest might be a closed openable container. If it happens
to be closed the first time the player tries to put a given treasure
into it, the points will never be awarded. Consider this code:

The Lab is a room.

```
After inserting the fish into the trunk:
	if the fish is in the trunk for the first time:
		increase the score by 1;
	continue the action.
```


That certainly looks as if it should work. But here’s the output:

{::options parse_block_html="false" /}
<div class="game-output">
<div class="command"><span class="prompt">&gt;</span>put fish in trunk</div>
<p>The old shipping trunk is closed.</p>
<div class="command"><span class="prompt">&gt;</span>open trunk</div>
<p>You open the old shipping trunk.</p>
<div class="command"><span class="prompt">&gt;</span>put fish in trunk</div>
<p>You put the fish into the old shipping trunk.</p>
<div class="command"><span class="prompt">&gt;</span>score</div>
<p>You have so far scored 0 out of a possible 0, in 4 turns.</p>

</div>
{::options parse_block_html="false" /}

No points were awarded for putting the fish in the trunk, because the
first time the player tried it, the trunk was closed. Here’s the correct
way to write the After rule:

```
After inserting the fish into the trunk:
	if the fish is in the trunk for the first time:
		increase the score by 1;
	continue the action.
```


But wait … what if we want the player to be awarded points only
while the treasure *remains* in the treasure chest? This requires
a slightly different approach. What we need to do is award a point each
time the treasure is successfully inserted into the treasure chest, and
also subtract a point each time the treasure is taken out of the chest.
To subtract a point, just increase the score by -1. Here’s one way to do
that, using the example of the fish and the old trunk, as before:

```
After inserting the fish into the trunk:
	if the fish is in the trunk:
		increase the score by 1;
	continue the action.

Instead of taking the fish:
	if the fish is in the trunk:
		decrease the score by 1;
	continue the action.
```


This use of an Instead rule assumes that there are no active Check
rules that would subsequently prevent the taking of the fish; Instead
runs before Check in the action processing. In most cases it should work
for you.

## Achievements

Some authors feel that keeping a numerical score trivializes a
serious game, or isn’t interesting from a literary standpoint. Even so,
it would be nice to let the player know what kind of progress he or she
is making. Instead of producing a numerical score in response to the
SCORE command, we can give the player a list of achievements. To do
this, we’ll use a table. Tables are one of Inform’s more advanced
features, and the syntax for using them is not entirely intuitive. At
the end of this example, so as to give you a better grasp of tables,
we’ll take a look at how the code works.

We’re going to create a game with three achievements – picking up a
ruby, taking off some goggles (which are being worn), and putting a
guppy back in the fish tank. These are listed in the Table of
Achievements. The table has three columns: object, achievement, and
flag. In the object column, we’ll enter the name of the object that is
being handled when the achievement happens. In the achievement column is
some text describing the achievement. The flag column contains a number;
this starts out as 0, but we’ll change it to 1 when the player
accomplishes the achievement.

```
The Living Room is a room. The guppy is here. The ruby is here. The player wears some goggles.

The fish tank is an open container in the Living room.

After taking the ruby when the ruby is not handled:
	choose the row with an object of ruby in the Table of Achievements;
	now the flag entry is 1;
	continue the action.

After taking off the goggles:
	choose the row with an object of goggles in the Table of Achievements;
	now the flag entry is 1;
	continue the action.

After inserting the guppy into the fish tank:
	choose the row with an object of guppy in the Table of Achievements;
	now the flag entry is 1;
	continue the action.

Table of Achievements
object      achievement            flag
ruby      "picked up the ruby"         0
goggles   "removed the goggles"      0
guppy      "put the guppy back in the tank"   0

This is the new announce the score rule:
	let flag-count be 0;
	repeat with N running from 1 to the number of rows in the Table of Achievements:
		choose row N in the Table of Achievements;
		if the flag entry is 1:
			increase the flag-count by 1;
	if the flag-count is 0:
		say "You haven't done anything notable yet.";
	otherwise:
		let total-flag-count be flag-count;
		say "So far you have [run paragraph on]";
		repeat with N running from 1 to the number of rows in the Table of Achievements:
			choose row N in the Table of Achievements;
			if the flag entry is 1:
				say "[achievement entry][run paragraph on]";
				decrease the flag-count by 1;
				if the flag-count is 0:
					say ".";
					rule succeeds;
				otherwise if the flag-count is 1:
					if the total-flag-count is 2:
						say " and [run paragraph on]";
					otherwise:
						say ", and [run paragraph on]";
				otherwise:
					say ", [run paragraph on]".

The new announce the score rule is listed instead of the announce the score rule in the carry out requesting the score rulebook.

Test me with “put guppy in tank / score / take ruby / score / take off goggles / score”.
```


The heavy lifting in this example is done by the new announce the
score rule, which replaces the announce the score rule (one of the
Standard Rules). The new rule does two things. First, it uses a loop
(“repeat with N running from 1…”) to count the number of achievements
the player has so far done. Each time it finds a row where the flag is
1, it increases the flag-count. Then it prints out a message. If the
flag-count is still zero, nothing has been accomplished, so the rule
will say so and stop.

If the flag-count is at least 1, that means the player has done
something. In this case we start the printout by saying, “So far you
have [run paragraph on]”. Then we go through the Table of Achievements
again, looking for and listing achievements. As we go, we decrease the
flag-count – but we’ve taken the precaution of storing it in
total-flag-count before the process starts. This is so we’ll know
whether the list is exactly two items long, or whether it’s longer. If
it’s exactly two items long, we want to print “ and ” between them, but
if it’s three or more items long, we want to print “, and ” between the
last two. This is the serial comma. If you’re not using the [serial comma](#Ref_serial_comma)
in your game, you can omit
the lines that use total-flag-count.

For more ways to report scoring, see the examples in [RB 11.4: Scoring](../RB_11.html#section4).
