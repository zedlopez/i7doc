## Appendix C: Short Sample Games   {#appendix-c-short-sample-games}

### Sample Games   {#sample-games}

In this appendix you’ll find a few miniature games that illustrate
various techniques. These games are a bit too complex to fit well within
the main flow of the *Handbook,* so they’re gathered here instead, in no
particular order.

### Flea Market   {#flea-market}

We’ll start with a simple scenario that was suggested by Jay in a post
on the newsgroup rec.arts.int-fiction, back in the day when it was still
a go-to place for IF info. Jay’s goal was to make NPCs respond at random
to items carried by the player. Each time the player takes inventory,
one of the other shoppers in the flea market will notice some random
thing the player carries, and comment on it.

This example illustrates four techniques: calling a function, creating a
definition, using what computer programmers call a *switch* statement,
and using a while loop.

Inform’s switch statement (see [WI 11.8:
Otherwise](../WI_11.html#section_8)) <span id="Ref_switch_statement"
class="anchor" />uses a double hyphen to indicate the various entries in
the switch block. Only one of the lines in a switch block will be run at
any given time. (A note to programmers: Inform doesn’t require break
statements in switch statements.) In this case, we enter the switch
block by selecting a random number between 1 and 5 and then choosing a
say statement based on the value of the random number.

We’re creating a function (“To say the desire”) and passing it two
arguments – a person and a thing. Within the function, we refer to the
person as P and the thing as J. There’s nothing special about these
symbols; we could just as easily have written “To say the desire of
(dude - a person) for (stuff - a thing)” and then referred to “\[dude\]”
and “\[stuff\]” in the say statements.

```
To say the desire of (P - a person) for (J - a thing): 
	if a random number from 1 to 5 is: 
	-- 1: say "'Gee, I'd sure like to have a [J] like that,' [P] remarks."; 
	-- 2: say "'That's sure a swell-looking [J],' says [P]."; 
	-- 3: say "[P] edges closer to you and says wistfully, 'I've been looking for years for a [J].'"; 
	-- 4: say "[P] hovers over you covetously. 'Say, were there more [J]s where you found that?'"; 
	-- 5: say "'Wow, that's a really nice [J],' [P] says enviously." 

After taking inventory: 
	if nothing is held by the player or the player is alone: 
		rule succeeds; 
	otherwise: 
		let shopper be the player; 
		while shopper is the player: 
			let shopper be a random person in the location; 
		let junk be a random thing held by the player; 
		say "[the desire of shopper for junk]". 

Definition: a person (called P) is alone if the number of persons in the location of P is 1.
```

The After rule causes nothing to happen if the player is alone or is
carrying nothing. Before entering the while statement in the After rule,
we define a variable called shopper, and give it the value of the
player. When the while statement starts, shopper is the player. The
while statement is a loop. It will execute over and over, randomly
picking one person after another in the location, until the person it
picks is *not* the player. This is what we want; if the shopper is still
the player, the output of the switch statement will be something like,
“yourself edges closer to you and says wistfully…”. Once the shopper is
not yourself, the condition (while shopper is the player) becomes false,
the loop ends, and the rest of the After rule runs. The rule chooses a
random thing held by the player, combines it with the randomly chosen
NPC, and says the desire of the random person for the random thing.

The definition is simple: We need to tell Inform what we mean by
“alone,” because the “After taking inventory” rule needs to check this.
Can you see what will happen if the “After taking inventory” rule
doesn’t include the condition “if … the player is alone”? If the player
ever takes inventory when no one else is in the location, the rule will
go into an endless loop. The while statement will keep trying forever to
find an NPC in the location, but it will always end up choosing the
player.

Here’s the rest of the game:

```
The Flea Market is a room. "All manner of things are for sale here, lined up in rows on folding tables." 

A folding table is a supporter in the Flea Market. On the table are a replica Maltese Falcon, a phallic fertility statue of Aziz, a 1956 Ford carburetor, a headless Barbie doll, and a broken Pez dispenser.

Wanda is a woman in the Flea Market. 
Julianne is a woman in the Flea Market. 
Chrissie is a woman in the Flea Market. 

The Parking Lot is north of the Flea Market. "Your car is parked here."

Test me with "i / take pez and ford and falcon and doll / i / i / i / i / n / i".
```

Since we don’t know what the player may be carrying or who may be in the
location, we pretty much have to choose NPCs and held items at random.
However, when items are selected at random, Inform will sometimes select
the same item several times in a row. This can result in a repeating
output, which will make the game seem wooden – but in a real game there
might be only one NPC in the location, or the player might be carrying
only one item, so repetition is not avoidable. If you’d prefer to
minimize the repetition, you can at least step through the list of
entries in the “To say the desire” rule in a repeating order, like this:

```
The desire-index is a number that varies. The desire-index is 0.

To say the desire of (P - a person) for (J - a thing): 
	increase the desire-index by 1;
	if the desire-index is greater than 5:
		now the desire-index is 1;
	if the desire-index is: 
	-- 1: say "'Gee, I'd sure like to have a [J] like that,' [P] remarks."; 
	-- 2: say "'That's sure a swell-looking [J],' says [P]."; 
	-- 3: say "[P] edges closer to you and says wistfully, 'I've been 
looking for years for a [J].'"; 
	-- 4: say "[P] hovers over you covetously. 'Say, were there more [J]s where you found that?'"; 
	-- 5: say "'Wow, that's a really nice [J],' [P] says enviously."
```

Here, we’ve created a global variable (desire-index). It’s global so
that it will persist throughout the game; a local variable within a rule
will be destroyed when the rule finishes. We then increase the
desire-index by 1 each time the rule runs and check to see if it has
gone past 5. If so, we reset it to 1. Now the five statements will be
used in the order shown, over and over (but with random people and
random things).

### Mr Potato Head   {#mr-potato-head}

The next example game illustrates several useful points. First, it shows
how to make parts that can be attached to or detached from an object.
(In this case, the object is the ever-obliging Mr Potato Head.)

```
The Potato Factory is a room.

Mr Potato Head is a man in the Factory. The description is "Mr Potato head is big and round and brown[attachment-list]."

To say attachment-list: 
	let count be 0; 
	repeat with item running through things that are a part of Mr Potato Head:
		increase count by 1; 
	if count is 0: 
		do nothing; 
	otherwise: 
		if the lips are part of Mr Potato Head:
			increase count by 1;
		say ". Adding an attractive facial character to Mr Potato Head [if count is greater than 1]are[otherwise]is[end if] [a list of things that are part of Mr Potato Head]".
```

The point of the “say attachment-list” code is that we want to append a
list of Mr Potato Head’s features to his description. Just to make
things slightly more interesting, the lips are plural-named, so if the
lips are part of Mr Potato Head we need to increase the count by 1 in
order to print out “are” rather than “is” if the lips are the only
feature that has been attached.

Next, we’ll create some facial attachments, and also an irrelevant item
(the banana) for testing purposes.

```
A facial attachment is a kind of thing. The nose is a facial attachment. The left eye is a facial attachment. The right eye is a facial attachment. Some lips are a facial attachment. 

The player carries the nose. The player carries the left eye. The player carries the right eye. The player carries the lips.

The player carries a banana.

The command the player is most likely to try is of the form PUT NOSE ON MR POTATO HEAD. But as far as Inform is concerned, putting it on is a different action from tying it to, so we need to redirect the putting it on action using an Instead rule. The next Instead rule handles both the error-checking for the adding of facial attachments, and the action.

Instead of putting something on Mr Potato Head: 
	try tying the noun to Mr Potato Head.

Instead of tying something to Mr Potato Head: 
	if the noun is not a facial attachment:
		say "That's not something you can attach to Mr Potato Head.";
	otherwise if the noun is part of Mr Potato Head:
		say "[The noun] [are] already attached to Mr Potato Head.";
	otherwise:
		now the noun is part of Mr Potato Head; 
		say "You attach [the noun] to Mr Potato Head."
```

In creating our new detaching it from action, we also need to consider
that the player’s most likely command is simply TAKE NOSE. The parser’s
default response would be, “That seems to be a part of Mr Potato Head.”
Inform very sensibly doesn’t let the player go around removing the parts
of things. So we need another Instead rule to map TAKE NOSE onto the
detaching it from action.

```
Check detaching it from: 
	if the noun is not part of the second noun: 
		say "But [the noun] [are] not attached to [the second noun]." instead;
	otherwise if the noun is not a facial attachment:
		say "[The noun] [do] not appear to be detachable." instead. 

Carry out detaching it from: 
	now the player carries the noun. 

Report detaching it from: 
	say "You detach [the noun] from [the second noun]." 

Instead of taking something: 
	if the noun is part of a thing (called the owner): 
		try detaching the noun from the owner instead; 
	otherwise: 
		continue the action.
```

<div data-custom-style="Normal" markdown="1">
And finally, just for fun, we’ll add a victorious outcome to the game:

<div class="codeblock">
<div class="codeline">
Every turn:
</div>
<div class="codeline">
   if the left eye is part of Mr Potato Head and the right eye is part
of Mr Potato Head and the lips is part of Mr Potato Head and the nose is
part of Mr Potato Head:
</div>
<div class="codeline">
      say "'Oh, thank you!' cries Mr Potato Head. 'You've restored my
faith in human nature!'";
</div>
<div class="codeline">
      end the story saying “You have won!”
</div>
</div>
### A Dangerous Jewel Box   {#a-dangerous-jewel-box}

The next example shows a way of printing out a single message when the
player tries to take several items and is prevented from doing so. There
are three jewels in the jewel box, and if the box is in its dangerous
state, we want the player character’s fingers to be zapped by an
electric shock if he tries to get the jewels from the box. But what we
don’t want is an output that looks like this:

<div class="game-output" markdown="1">
<div class="command">
<span class="prompt">></span>take jewels
</div>
ruby: Zap! As your fingers near the jewel box, you recoil from a
powerful electric shock.

diamond: Zap! As your fingers near the jewel box, you recoil from a
powerful electric shock.

sapphire: Zap! As your fingers near the jewel box, you recoil from a
powerful electric shock.

</div>
This would be silly, because the player character would naturally stop
after being shocked the first time. Getting the output to read nicely
turns out to be complicated, because there are many possible conditions
that might occur in the game. The box might be safe rather than
dangerous (this is handled in the example with the command TURN
CARVING). The player might make the box safe, take two jewels, drop them
on the floor, make the box dangerous again, and then try TAKE JEWELS.
What should happen then?

The extension [Consolidated Multiple Actions by John Clemens][1], which
was recently updated by Emily Short for 6L38 compatibility, can handle
this type of scenario – but it only works in Glulx games. If you don’t
need or want all of its functionality, studying the code below will show
you how to handle this type of situation.

The code below contains comments that explain its logic.

<div class="codeblock">
<div class="codeline">
The Sultan's Treasure Room is a room. "Awesome treasures surround you!
To the north, an arch opens on a balcony."
</div>
<div class="codeline">
 
</div>
<div class="codeline">
[To make sure the scoping works properly, we'll add a second room so the
tester can carry a jewel or two elsewhere, drop them, and come back:]
</div>
<div class="codeline">
The Balcony is north of the Treasure Room. "From here you can see the
entire city. The treasure room is back to the south."
</div>
<div class="codeline">
 
</div>
<div class="codeline">
The jewel box is an open container in the Treasure Room. "A jewel box
sits here, invitingly open. On the front of the box is an intricate
ivory carving. In the box you can see [a list of things in the jewel
box]." The jewel box can be safe or dangerous. The jewel box has some
text called the zap-message. The zap-message of the jewel box is "Zap!
As your fingers near the jewel box, you recoil from a powerful electric
shock". The intricate ivory carving is part of the jewel box.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
[We can make the jewel box safe or dangerous with 'turn carving':]
</div>
<div class="codeline">
Instead of turning the carving:
</div>
<div class="codeline">
   say "Click -- the carving rotates a quarter-turn to the [run
paragraph on]";
</div>
<div class="codeline">
   if the jewel box is dangerous:
</div>
<div class="codeline">
      now the jewel box is safe;
</div>
<div class="codeline">
      say "left.";
</div>
<div class="codeline">
   otherwise:
</div>
<div class="codeline">
      now the jewel box is dangerous;
</div>
<div class="codeline">
      say "right."
</div>
<div class="codeline">
 
</div>
<div class="codeline">
A gem is a kind of thing. Understand "jewel" as a gem. Understand
"jewels" and "gems" as the plural of gem.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
The diamond is a gem in the jewel box. The ruby is a gem in the jewel
box. The sapphire is a gem in the jewel box.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
[The box only protects jewels. The token can be taken from it at any
time:]
</div>
<div class="codeline">
The player carries a subway token.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
[Taking and removing from are separate actions, so we have to trap them
both:]   
</div>
<div class="codeline">
This is the new announce items from multiple object lists rule:
</div>
<div class="codeline">
   if the current item from the multiple object list is not nothing:
</div>
<div class="codeline">
      if taking gems when the jewel box is dangerous:
</div>
<div class="codeline">
         do nothing;
</div>
<div class="codeline">
      else if removing gems from the jewel box when the jewel box is
dangerous:
</div>
<div class="codeline">
         do nothing;
</div>
<div class="codeline">
      else:
</div>
<div class="codeline">
         say "[current item from the multiple object list]: [run
paragraph on]".
</div>
<div class="codeline">
 
</div>
<div class="codeline">
The new announce items from multiple object lists rule is listed instead
of the announce items from multiple object lists rule in the
action-processing rules.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Before taking gems:
</div>
<div class="codeline">
   let L be the multiple object list;
</div>
<div class="codeline">
   let N be the number of entries in L;
</div>
<div class="codeline">
   [If the player is only trying to take one jewel, the length of the
multiple object list will be 0:]
</div>
<div class="codeline">
   if N is 0:
</div>
<div class="codeline">
      if the noun is in the jewel box and the jewel box is dangerous:
</div>
<div class="codeline">
         say "[zap-message of the jewel box]." instead;
</div>
<div class="codeline">
      otherwise:
</div>
<div class="codeline">
         continue the action;
</div>
<div class="codeline">
   [Still here? Then either the player is trying to take several jewels
or the jewel box is safe:]
</div>
<div class="codeline">
   if the jewel box is safe:
</div>
<div class="codeline">
      continue the action;
</div>
<div class="codeline">
   [Okay, now we know the jewel box is dangerous, but we don't yet know
whether any of the jewels the player aims to take are actually IN the
jewel box … so we'll set up a flag and a list:]
</div>
<div class="codeline">
   let danger-present be a truth state;
</div>
<div class="codeline">
   let danger-present be false;
</div>
<div class="codeline">
   let safe-list be a list of things;
</div>
<div class="codeline">
   let safe-list be {};
</div>
<div class="codeline">
   [Now let's find out what the player is trying to take:]
</div>
<div class="codeline">
   repeat with G running through gems:
</div>
<div class="codeline">
      if G is listed in L:
</div>
<div class="codeline">
         if G is in the jewel box:
</div>
<div class="codeline">
            now danger-present is true;
</div>
<div class="codeline">
         otherwise:
</div>
<div class="codeline">
            add G to the safe-list;
</div>
<div class="codeline">
   [If none of the jewels the player is trying to take is in the
dangerous box:]
</div>
<div class="codeline">
   if danger-present is false:
</div>
<div class="codeline">
      continue the action;
</div>
<div class="codeline">
   [Now we know that at least one of the jewels in the multiple object
list is in the dangerous box -- but maybe some of them aren't in the
box. In that case, we're going to assume there is no other obstacle,
such as inventory management, a greedy hyena, or the player wearing
mittens, that would prevent their being picked up. We'll only check to
make sure they're in the location:]
</div>
<div class="codeline">
   if the number of entries in safe-list is not 0:
</div>
<div class="codeline">
      repeat with item running through safe-list:
</div>
<div class="codeline">
         if item is enclosed by the location and item is not carried by
the player:
</div>
<div class="codeline">
            now the player carries item;
</div>
<div class="codeline">
            say "[item]: Taken.";
</div>
<div class="codeline">
   truncate L to 1 entries;
</div>
<div class="codeline">
   alter the multiple object list to L;
</div>
<div class="codeline">
   say "[zap-message of the jewel box]." instead;
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Test me with "put token in box / take token and ruby / take jewels /
take diamond / turn carving / take diamond and ruby / turn carving /
drop all / take jewels".
</div>
</div>
The heavy lifting is done by the “Before taking gems” rule. Note that if
one or more gems are available for taking, this rule has to handle the
process manually. It can’t include, near the end, the line “try taking
item”, because that will cause Inform to try running the entire rule
again. It will produce a loop, which will result in a run-time error.

### The Omega Machine   {#the-omega-machine}

This sophisticated example showed up back in 2009 on the IntFiction
forum. The author, who goes by the handle SJ\_43, was responding to [a
question from someone named Eudoxia about how to make a device that the
player can give commands to][2] – for instance, a command like COMPUTER,
CHECK THE STABILIZERS. The game below doesn’t implement anything quite
that complicated, but it provides a framework with which you could
easily do it. The sneaky Inform 6 trick in this code is the line,
“Include (- has talkable, -) when defining a computer.” The parentheses
and dashes are used (as described in [What Does Inform 6 Have to Do with
Inform 7](#what-does-inform-6-have-to-do-with-inform-7)) to drop the
code out of I7 and down into I6. “has talkable” is I6 code that means,
more or less, “This is an object the player may want to be able to talk
to.”

Note that the Default Messages extension may change or not be compatible
with a future version of Inform 7. It’s used here to create a special
error message for devices of the computer kind.

I’ve customized SJ\_43’s code by adding some calendar messages for
Omega. In a real game, you’d probably want to store such messages in a
table, so as to be able to refer to different messages at different
points in the game.

<div class="codeblock">
<div class="codeline">
A computer is a kind of device.
</div>
<div class="codeline">
Include (- has talkable, -) when defining a computer.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Checking for mail is an action applying to nothing.
</div>
<div class="codeline">
Understand "mail", "display mail", and "show mail" as checking for mail.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Check an actor checking for mail:
</div>
<div class="codeline">
   unless the actor is a computer, stop the action.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Carry out a computer checking for mail:
</div>
<div class="codeline">
   say "'You have no messages.'"
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Displaying the calendar is an action applying to nothing.
</div>
<div class="codeline">
Understand "calendar", "display calendar", and "show calendar" as
displaying the calendar.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Check an actor displaying the calendar:
</div>
<div class="codeline">
   unless the actor is a computer, stop the action.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Checking for mail is doing computer stuff. Displaying the calendar is
doing computer stuff.
</div>
<div class="codeline">
Persuasion rule for asking a computer to try doing computer stuff:
persuasion succeeds.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Instead of doing computer stuff, say "That command is for computers
only."
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Instead of a switched off computer (called comp) doing something:
</div>
<div class="codeline">
   say error message for the comp;
</div>
<div class="codeline">
   rule succeeds.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Asking a computer about something is computer conversation.
</div>
<div class="codeline">
Telling a computer about something is computer conversation.
</div>
<div class="codeline">
Asking a computer for something is computer conversation.
</div>
<div class="codeline">
Instead of computer conversation, say "You can only do that to something
animate."
</div>
<div class="codeline">
Instead of answering a computer that something, say error message for
the noun.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
To say error message for (comp - a computer):
</div>
<div class="codeline">
   if comp is switched on, say "'Does not compute!'";
</div>
<div class="codeline">
   otherwise say "[The comp] is currently switched off."
</div>
<div class="codeline">
 
</div>
<div class="codeline">
The Lab is a room. Omega is a computer in the Lab. Understand "pda" as
Omega. The description of omega is "Your trusty handeheld pda. The
chrome-plated device is voice-activated, and no batteries are necessary
since it has a built-in microfusion reactor."
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Carry out Omega displaying the calendar:
</div>
<div class="codeline">
   say "[one of]'You're late for your appointment with the white
rabbit!' says Omega[or]'Time for a flu shot!' says Omega[or]'I'm afraid
I can't do that, Dave,' says Omega[or]'No appointments today,' says
Omega[stopping].";
</div>
<div class="codeline">
   rule succeeds.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Test me with "take omega / omega, mail / turn on omega / omega, mail /
omega, calendar / g / g / omega, sing / mail".
</div>
</div>
### The Lurking Critter   {#the-lurking-critter}

This example, which was inspired by an answer that Mike Gentry gave on
the newsgroup to a question from S. John Ross, is included principally
to show a way of changing the state of an object (the sword) and of
reporting that change in certain conditions – namely, if the player is
carrying the sword. The idea that the sword glows if the lurking critter
is nearby is borrowed from Zork.

We’ll start by creating a checkerboard-like matrix of 16 rooms. This
matrix is at least mildly interesting in that the room connections cross
one another without intersecting. That is, you can go southeast from
Room1 to Room6, or southwest from Room2 to Room5, but the two paths are
independent. (Maybe there are arched stone bridges.) Both the player and
the lurking critter can move diagonally from room to room as well as
orthogonally. The critter will move at random, but only 50% of the time.

<div class="codeblock">
<div class="codeline">
Room1 is a room. Room2 is east of Room1. Room3 is east of Room2. Room4
is east of Room3.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Room5 is south of Room1. Room6 is east of Room5 and south of Room2.
Room7 is east of Room6 and south of Room3. Room8 is east of Room7 and
south of Room4.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Room9 is south of Room5. Room10 is east of Room9 and south of Room6.
Room11 is east of Room10 and south of Room7. Room12 is east of Room11
and south of Room8.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Room13 is south of Room9. Room14 is east of Room13 and south of Room10.
Room15 is east of Room14 and south of Room11. Room16 is east of Room15
and south of Room12.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Room5 is southwest of Room2. Room6 is southwest of Room3 and southeast
of Room1. Room7 is southwest of Room4 and southeast of Room2. Room8 is
southeast of Room3.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Room9 is southwest of Room6. Room10 is southwest of Room7 and southeast
of Room5. Room11 is southwest of Room8 and southeast of Room6. Room12 is
southeast of Room7.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Room13 is southwest of Room10. Room14 is southwest of Room11 and
southeast of Room9. Room15 is southwest of Room12 and southeast of
Room10. Room16 is southeast of Room11.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
The lurking critter is a man in Room4.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Brightness is a kind of value. The brightnesses are glowing brightly,
glowing faintly, and glowless.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
The player carries a sword. The sword has a brightness. The brightness
of the sword is glowless. The description is "A trusty critter-sensing
weapon[if the brightness of the sword is glowing faintly]. It's glowing
faintly[otherwise if the brightness of the sword is glowing brightly].
It's glowing brightly[end if]."
</div>
</div>
This next definition is used, rather than the library’s default
terminology, “adjacent room,” because room adjacency isn’t considered to
exist if two rooms are separated by a door. You might want to add doors
to your game.

<div class="codeblock">
<div class="codeline">
Definition: a room is neighboring if the number of moves from it to
</div>
<div class="codeline">
the location is 1.
</div>
</div>
And finally, we’ll move the critter (maybe) and adjust the sword-glow:

<div class="codeblock">
<div class="codeline">
To adjust sword-glow to (b - a brightness):
</div>
<div class="codeline">
   let current glow be the brightness of the sword;
</div>
<div class="codeline">
   now the brightness of the sword is b;
</div>
<div class="codeline">
   if b is the current glow:
</div>
<div class="codeline">
      do nothing;
</div>
<div class="codeline">
   otherwise if b is glowless:
</div>
<div class="codeline">
      if the player carries the sword:
</div>
<div class="codeline">
         say "Your sword is no longer glowing.";
</div>
<div class="codeline">
   otherwise if b is glowing faintly:
</div>
<div class="codeline">
      if the player carries the sword:
</div>
<div class="codeline">
         say "Your sword glows with a faint blue glow.";
</div>
<div class="codeline">
   otherwise:
</div>
<div class="codeline">
      if the player carries the sword:
</div>
<div class="codeline">
         say "Your sword is glowing brightly."
</div>
</div>
### Restraints   {#restraints}

Preventing the player from performing certain actions in certain
situations is a standard type of puzzle. For instance, if the player is
wearing handcuffs, picking things up (that is, using the TAKE or GET
command) probably shouldn’t work. I’ll leave it up to your imagination
to figure out how the player character might be able to remove a pair of
handcuffs while unable to pick up the key. In the example below, a
simple workaround is used – the player is allowed to pick up the key,
but nothing else.

[The Restraints example was posted by Zeborah on IntFiction][3] and then
revised by me with a little help from Mike Tarbert, provides a
general-purpose way to intercept actions depending on what sort of
restraint the PC is wearing. It uses a table to correlate actions with
restraints.

<div class="codeblock">
<div class="codeline">
A restraint is a kind of thing. A restraint is usually wearable. The
blindfold, the gag, the ball-and-chain, and some handcuffs are
restraints.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Instead of doing something when the player wears a restraint:
</div>
<div class="codeline">
   repeat through the Table of Restricted Movements:
</div>
<div class="codeline">
      if the player wears the restraint entry:
</div>
<div class="codeline">
         let impulses be a list of action names;
</div>
<div class="codeline">
         let impulses be the movement entry;
</div>
<div class="codeline">
         if the action name part of the current action is listed in
impulses:
</div>
<div class="codeline">
            say "You have no hope of [the current action] while wearing
[the restraint entry]." instead;
</div>
<div class="codeline">
   continue the action.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
The handcuffs can be locked or unlocked. The handcuffs are locked.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Instead of locking the handcuffs with the small iron key:
</div>
<div class="codeline">
   if the handcuffs are locked:
</div>
<div class="codeline">
      say "They're already locked.";
</div>
<div class="codeline">
   otherwise if the player does not carry the small iron key:
</div>
<div class="codeline">
      say "You don't seem to have the key.";
</div>
<div class="codeline">
   otherwise:
</div>
<div class="codeline">
      now the handcuffs are locked;
</div>
<div class="codeline">
      say "You lock the handcuffs with the small iron key."
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Instead of taking off the handcuffs:
</div>
<div class="codeline">
   if the handcuffs are locked:
</div>
<div class="codeline">
      say "The handcuffs seem to be locked.";
</div>
<div class="codeline">
   otherwise:
</div>
<div class="codeline">
      now the player carries the handcuffs;
</div>
<div class="codeline">
      say "You remove the handcuffs."
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Instead of wearing the handcuffs:
</div>
<div class="codeline">
   if the handcuffs are worn:
</div>
<div class="codeline">
      say "You're already wearing the handcuffs.";
</div>
<div class="codeline">
   otherwise if the handcuffs are locked:
</div>
<div class="codeline">
      say "You'll need to unlock the handcuffs before you can put them
on.";
</div>
<div class="codeline">
   otherwise:
</div>
<div class="codeline">
      now the player wears the handcuffs;
</div>
<div class="codeline">
      say "You put on the handcuffs."
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Instead of unlocking the handcuffs with the small iron key:
</div>
<div class="codeline">
   if the handcuffs are unlocked:
</div>
<div class="codeline">
      say "But they're not locked!";
</div>
<div class="codeline">
   otherwise if the player does not carry the small iron key:
</div>
<div class="codeline">
      say "You don't seem to have the key.";
</div>
<div class="codeline">
   otherwise:
</div>
<div class="codeline">
      now the handcuffs are unlocked;
</div>
<div class="codeline">
      say "It's awkward, but you manage to insert the key in the keyhole
and turn it. Now the handcuffs are unlocked."
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Instead of taking the small iron key when the player wears the
handcuffs:
</div>
<div class="codeline">
   now the player carries the small iron key;
</div>
<div class="codeline">
   say "You manage to pick up the key, even though you're wearing
handcuffs."
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Instead of opening the tool chest when the player wears the handcuffs:
</div>
<div class="codeline">
   if the tool chest is open:
</div>
<div class="codeline">
      say "It's already open.";
</div>
<div class="codeline">
   otherwise:
</div>
<div class="codeline">
      now the tool chest is open;
</div>
<div class="codeline">
      say "It's awkward, but you manage to open the tool chest while
wearing the handcuffs."
</div>
<div class="codeline">
 
</div>
<div class="codeline">
The Dungeon is a room. "A dank and dismal dungeon. You can go north."
</div>
<div class="codeline">
 
</div>
<div class="codeline">
The Dismal Crypt is north of the Dungeon. "The walls of the crypt are
oozing…"
</div>
<div class="codeline">
 
</div>
<div class="codeline">
The player wears the ball-and-chain and the handcuffs.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
The tool chest is an openable container in the Dungeon. The tool chest
is closed. The blindfold and gag are in the tool chest. The small iron
key is in the tool chest.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
[Due to a bug in the Inform compiler, we have to split the list of
actions that you can’t take while wearing the handcuffs into three
separate rows in the table:]
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Table of Restricted Movements
</div>
<div class="codeline">
restraint   movement
</div>
<div class="codeline">
ball-and-chain   {going action, jumping action, entering action, exiting
action, getting off action, climbing action}
</div>
<div class="codeline">
gag   {eating action, kissing action, answering it that action, telling
it about action, asking it about action, asking it for action, saying
yes action, saying no action, tasting action, saying sorry action}
</div>
<div class="codeline">
handcuffs   {taking action, removing it from action, taking off action,
dropping action, putting it on action, inserting it into action,
searching action, touching action}
</div>
<div class="codeline">
handcuffs   {waving action, pulling action, pushing action, turning
action, squeezing action, eating action, consulting it about action,
locking it with action, unlocking it with action, switching on action,
switching off action}
</div>
<div class="codeline">
handcuffs   {opening action, closing action, wearing action, attacking
action, showing it to action, throwing it at action, cutting action,
tying it to action, drinking action, swinging action, rubbing action,
setting it to action}
</div>
<div class="codeline">
blindfold   {looking action, searching action, examining action}
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Test me with "n / remove ball-and-chain / remove handcuffs / open chest
/ unlock handcuffs with key / remove handcuffs / remove ball-and-chain /
n".
</div>
</div>
This example takes advantage of the fact that when the Inform compiler
builds rulebooks, it lists more specific rules ahead of more general
rules. The Instead rules for the tool chest, key, and handcuffs will be
listed before the general-purpose Instead rule, so they’ll allow the
player to solve the puzzle by opening the chest, picking up the key, and
then unlocking the handcuffs.

The example also shows how to use a table containing list entries, and
how to use the phrase “action-name part of the current action,” which is
not a syntax mentioned elsewhere in this *Handbook* (nor, for that
matter, in *Writing with Inform*). It’s a useful syntax to know. For
instance, if the current action is “going north”, the action-name part
of the action is “going”.

After removing the handcuffs, you can experiment further with this
example by wearing the blindfold and trying to examine things, or by
adding an NPC, wearing the gag, and then trying to talk to the NPC.

### Broken Eggs   {#broken-eggs}

This next example was originally written by Jason Travis and posted in
the newsgroup, in response to a question from Rob Cowell about how to
break a box full of eggs when the box was dropped. I’ve expanded the
example quite a bit. It shows how to handle a collection of
indistinguishable objects (the eggs) when any individual egg can be
either broken or unbroken.

First, we’ll set up the game and let Inform know that an egg is a kind
of thing. We’ll add some code that will allow eggs to be broken or
unbroken. Note the use of a couple of “before printing” rules to let the
player know what sort of egg is being mentioned. This is a handy
alternative to changing the printed name of an egg object when the egg
itself is in the process of getting broken.

<div class="codeblock">
<div class="codeline">
"Humpty Dumpty Doesn't Live Here" by Jason Travis & Jim Aikin
</div>
<div class="codeline">
 
</div>
<div class="codeline">
The story headline is "A heart-rending tale of clumsiness and its
irreversble consequences,"
</div>
<div class="codeline">
 
</div>
<div class="codeline">
The Kitchen is a room. "A well-appointed kitchen with all sorts of
things you really don't need to interact with."
</div>
<div class="codeline">
 
</div>
<div class="codeline">
An egg is a kind of thing. An egg can be unbroken or broken. An egg is
usually unbroken. The description is "[if unbroken]Ovoid and
whitish.[otherwise]Yolk and other stuff grotesquely splashed in an
interesting pattern among various sharp bits of shell."
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Understand the unbroken property as describing an egg.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Understand "sharp", "bits", "shell", "yellow", and "yolk" as broken.
Understand "whole", "white", "whitish", "ovoid", and "fresh" as
unbroken.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Before printing the name of a broken egg, say "broken ".
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Before printing the plural name of a broken egg, say "broken ".
</div>
</div>
We don’t want the player carrying around broken eggs, so we’ll get rid
of them if the player tries to take them. This next bit of code
illustrates the use of the word “called” to create a reference (BE) that
we can use while writing the Instead rule. In this case, we could just
as easily skip the “called” reference and say “remove the noun from
play”, but “called” is a handy bit of syntax to know, so we’ll use it
here.

<div class="codeblock">
<div class="codeline">
Instead of taking a broken egg (called BE):
</div>
<div class="codeline">
   say "You spend a good deal of time cleaning it up, throwing the gooey
</div>
<div class="codeline">
debris into the trash.";
</div>
<div class="codeline">
   remove BE from play.
</div>
</div>
Next, we need a box with some eggs in it. Note the use of the text
substitution “\[box-contents\]”. This lets us write a whole To say rule
that will mention the eggs in the box if there are any. By default,
Inform doesn’t list the contents of an open container when the container
is examined. But since broken eggs are highly noticeable, we’ll tack a
list of things in the eggbox onto the description. The carry out rule
for examining the eggbox causes Inform not to print out an extra line
repeating the contents of the box. This is not strictly necessary; we
could let Inform do this for us. But it would make the list of contents
into a separate paragraph. The code below tucks the list of contents
neatly into the end of the main paragraph.

<div class="codeblock">
<div class="codeline">
The eggbox is a closed openable container in Kitchen. The description is
"It is made of recycled paper, and is decorated with a garish cartoon
showing a line of happy chickens with their wings wrapped across one
another's shoulders as they dance the can-can[box-contents]." The eggbox
contains six eggs. Understand "box", "recycled", "paper", "happy",
"chickens", and "carton" as the eggbox.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Carry out examining the eggbox:
</div>
<div class="codeline">
   say "[description of the eggbox][line break]";
</div>
<div class="codeline">
   rule succeeds.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
To say box-contents:
</div>
<div class="codeline">
   if the eggbox is closed:
</div>
<div class="codeline">
      do nothing;
</div>
<div class="codeline">
   otherwise if the number of things in the eggbox is 0:
</div>
<div class="codeline">
      do nothing;
</div>
<div class="codeline">
   otherwise:
</div>
<div class="codeline">
      say ". In the box you can see [a list of things in the eggbox]".
</div>
</div>
Now it’s time to break some eggs. The first part is easy. If the player
uses the command DROP EGG, something bad will happen. We’ll break the
egg in an After rule because we want to make sure the dropping action
has been successfully carried out. If we used an Instead rule, we’d have
to move the broken egg to the floor of the room manually, because the
Instead rule would bypass Inform’s normal handling of the DROP action.
We’d also have to make sure the player was actually carrying the egg,
for the same reason. With an After rule, our code can be simpler and
less error-prone.

The consequences of dropping the eggbox are more complicated. We’re
going to assume that if the eggbox is closed, the eggs in it won’t break
when the box is dropped. (Kids – don’t try this at home!) If the box is
open, the eggs in it will break. But what if the box contains both some
broken eggs and some unbroken ones? That could happen, for instance, if
the player uses the commands OPEN BOX, TAKE EGG, DROP BOX, PUT EGG IN
BOX, TAKE BOX. At this point the box would contain (probably) some
broken eggs and an unbroken one.

<div class="codeblock">
<div class="codeline">
After dropping an egg (called E):
</div>
<div class="codeline">
   now E is broken;
</div>
<div class="codeline">
   say "The egg tumbles to the floor in slow motion, breaking apart
spectacularly. Somewhere in the distance you hear the forlorn
cluck-cluck-cluck of a mother hen."
</div>
<div class="codeline">
 
</div>
<div class="codeline">
After dropping the eggbox:
</div>
<div class="codeline">
   if the eggbox is closed:
</div>
<div class="codeline">
      if the eggbox does not contain an egg:
</div>
<div class="codeline">
         say "The empty box skitters across the floor.";
</div>
<div class="codeline">
      otherwise if the eggbox contains a broken egg:
</div>
<div class="codeline">
         say "The eggbox makes a sort of squishy, sloshing sound as it
hits the floor.";
</div>
<div class="codeline">
      otherwise:
</div>
<div class="codeline">
         say "You hear [the number of eggs in the eggbox in words]
egg[s] jouncing around safely in the carton.";
</div>
<div class="codeline">
   otherwise:
</div>
<div class="codeline">
      if the eggbox does not contain an egg:
</div>
<div class="codeline">
         say "The empty box thunks hollowly on the floor.";
</div>
<div class="codeline">
      otherwise if the eggbox contains an unbroken egg:
</div>
<div class="codeline">
         say "Whoops! Broken [run paragraph on]";
</div>
<div class="codeline">
         if the number of unbroken eggs in the eggbox is greater than 1:
</div>
<div class="codeline">
            say "eggs.";
</div>
<div class="codeline">
         otherwise:
</div>
<div class="codeline">
            say "egg.";
</div>
<div class="codeline">
         now every egg in the eggbox is broken;
</div>
<div class="codeline">
      otherwise:
</div>
<div class="codeline">
         let N be the number of broken eggs in the eggbox;
</div>
<div class="codeline">
         say "The broken egg[if N is greater than 1]s slosh[otherwise]
sloshes[end if] around viscously in the eggbox as it hits the floor."
</div>
</div>
Studying this After rule may help you see how to structure blocks of
code. The outermost if-test is “if the eggbox is closed … otherwise”.
Within each of these blocks, we test whether the eggbox does not contain
an egg, and deal with that possibility. And so on.

The use of “\[run paragraph on\]” and “let N be the number…” is also
worth a quick look, if you’re not familiar with these tools.

### Indoors & Outdoors   {#indoors-outdoors}

Inform’s built-in library creates rooms in a basic way. They have no
walls, floor, or ceiling. If outdoors, they have no ground or sky. Such
objects can easily be created as backdrops. A more serious limitation is
that even outdoor rooms are, by default, “sealed containers.” You can’t
look from one outdoor room into another and see anything that’s there.

My first thought was to bundle the example game below as an extension,
in order to provide these features and a few others for anyone who might
find them useful. But I suspect authors will almost always want to
customize the implementation in various ways. Since none of the code in
the example game is tucked away in an extension, you can easily copy it
into your own game and modify it as needed.

If you want to write a realistic outdoor setting, spend some time
studying [RB 3.4: Continuous Spaces and the
Outdoors](../RB_3.html#section_p). The examples in that section
illustrate some useful techniques. For the present example, we’re going
to implement both outdoor and indoor rooms. We’ll start by creating some
backdrops and a couple of kinds of room. (Note that to use this code,
you will usually need to add a few extra words to each of your existing
room definitions, to tell Inform whether the new room is an indoor room
or an outdoor room.)

We need a special “check taking” rule for the sky, because by default
Inform will respond to the player’s attempt to take a backdrop by saying
“That’s hardly portable.” This response works fine for walls, floor,
ceiling, and ground, but not for the sky.

<div class="codeblock">
<div class="codeline">
An outdoor room is a kind of room. An indoor room is a kind of room.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
The sky is a backdrop. The description is "A bright and cloudless blue."
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Check taking the sky:
</div>
<div class="codeline">
   say "You can't touch the sky.";
</div>
<div class="codeline">
   rule fails.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
The ground is a backdrop. The description is "The ground is a bit
uneven." Understand "uneven" as the ground.
</div>
<div class="codeline">
The ceiling is a backdrop. The description is "A few cobwebs up there."
Understand "cobwebs" as the ceiling.
</div>
<div class="codeline">
The floor is a backdrop. The description is "The floor is flat and
level."
</div>
<div class="codeline">
 
</div>
<div class="codeline">
A backdrop has a direction called wall-direction. The wall-direction of
a backdrop is usually up.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
A wall is a kind of backdrop.
</div>
<div class="codeline">
The east wall is a wall. The wall-direction of the east wall is east.
</div>
<div class="codeline">
The north wall is a wall. The wall-direction of the north wall is north.
</div>
<div class="codeline">
The south wall is a wall. The wall-direction of the south wall is south.
</div>
<div class="codeline">
The west wall is a wall. The wall-direction of the west wall is west.
</div>
<div class="codeline">
The description of a wall is "It's vertical." Understand "walls" as the
plural of a wall.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
A corner is a kind of backdrop.
</div>
<div class="codeline">
The northeast corner is a corner. The wall-direction of the northeast
corner is northeast.
</div>
<div class="codeline">
The northwest corner is a corner. The wall-direction of the northwest
corner is northwest.
</div>
<div class="codeline">
The southeast corner is a corner. The wall-direction of the southeast
corner is southeast.
</div>
<div class="codeline">
The southwest corner is a corner. The wall-direction of the southwest
corner is southwest.
</div>
<div class="codeline">
The description of a corner is "Two walls join here at right angles."
Understand "corners" as the plural of a corner.
</div>
</div>
Defining some of the directions as diagonal will become important if the
player tries LOOK NORTHEAST, for instance, while indoors. We want to
refer to the corner of the room, not to a wall (since most likely there
will be two walls meeting in the northeast). Having taken care of that
detail, we create a pair of regions, in order to put the backdrops in
them.

A limitation of Inform, which may come into play if you try adapting the
code in this example for use in your game, is that regions can’t
overlap. (The basic way of handling region definitions is explained in
[Regions](#regions).) Because of this limitation, if you use the code
below you won’t be able to include both an indoor room and an outdoor
room in any of the regions you might want to define in your game. Indoor
rooms are in the Great Indoors region and outdoor rooms in the Great
Outdoors region.

<div class="codeblock">
<div class="codeline">
A direction can be orthogonal or diagonal. A direction is usually
orthogonal. Northwest is diagonal. Southwest is diagonal. Northeast is
diagonal. Southeast is diagonal.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
The Great Outdoors is a region. All outdoor rooms are in the Great
Outdoors.
</div>
<div class="codeline">
The Great Indoors is a region. All indoor rooms are in the Great
Indoors.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
The sky is in the Great Outdoors. The ground is in the Great Outdoors.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
The floor is in the Great Indoors. The ceiling is in the Great Indoors.
The east wall is in the Great Indoors. The north wall is in the Great
Indoors. The west wall is in the Great Indoors. The south wall is in the
Great Indoors.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
The northeast corner is in the Great Indoors. The northwest corner is in
the Great Indoors. The southeast corner is in the Great Indoors. The
southwest corner is in the Great Indoors.
</div>
</div>
Next, we’ll add some code to let the player use commands of the form
LOOK EAST. This type of command will do one thing if the player is in an
indoor room (it will examine a wall) and another if the player is in an
outdoor room (it will use the new direction-looking action that we’re
about to define).

Note the use of the “listed instead of” line below to replace a default
library rule with our own version. The library’s default just prints out
a message, but we need more nuance.

<div class="codeblock">
<div class="codeline">
Carry out examining (this is the new examine directions rule):
</div>
<div class="codeline">
   if the noun is a direction:
</div>
<div class="codeline">
      if the location is an indoor room:
</div>
<div class="codeline">
         repeat with item running through backdrops in the location:
</div>
<div class="codeline">
            if the wall-direction of item is the noun:
</div>
<div class="codeline">
               try examining item instead;
</div>
<div class="codeline">
      otherwise:
</div>
<div class="codeline">
         try direction-looking the noun instead;
</div>
<div class="codeline">
   otherwise:
</div>
<div class="codeline">
      continue the action.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
The new examine directions rule is listed instead of the examine
directions rule in the carry out examining rulebook.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Looking toward is an action applying to one visible thing. Understand
"look toward [any room]" as looking toward.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Chosen direction is a direction that varies.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Check looking toward:
</div>
<div class="codeline">
   if the noun is the location:
</div>
<div class="codeline">
      try looking instead;
</div>
<div class="codeline">
   otherwise if the noun is not neighboring:
</div>
<div class="codeline">
      say "You can't see that far." instead.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Carry out looking toward:
</div>
<div class="codeline">
   now the chosen direction is the best route from the location to the
noun;
</div>
<div class="codeline">
   try direction-looking the chosen direction instead.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Direction-looking is an action applying to one visible thing and
requiring light. Understand "look [direction]" as direction-looking.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Carry out direction-looking:
</div>
<div class="codeline">
   let D be the noun;
</div>
<div class="codeline">
   if the location is an indoor room:
</div>
<div class="codeline">
      if D is inside or D is outside:
</div>
<div class="codeline">
         say "You see nothing unusual.";
</div>
<div class="codeline">
      otherwise if D is up:
</div>
<div class="codeline">
         try examining the ceiling instead;
</div>
<div class="codeline">
      otherwise if D is down:
</div>
<div class="codeline">
         try examining the floor instead;
</div>
<div class="codeline">
      otherwise if D is diagonal:
</div>
<div class="codeline">
         say "The [D] corner of the room is an ordinary corner.";
</div>
<div class="codeline">
      otherwise:
</div>
<div class="codeline">
         say "The [D] wall looks like a wall.";
</div>
<div class="codeline">
   otherwise:
</div>
<div class="codeline">
      let R be the room D from the location;
</div>
<div class="codeline">
      if R is a room:
</div>
<div class="codeline">
         assemble the huge-list for R;
</div>
<div class="codeline">
      otherwise:
</div>
<div class="codeline">
         now the huge-list is {};
</div>
<div class="codeline">
      if the number of entries in huge-list is 0:
</div>
<div class="codeline">
         say "You see nothing unusual in that direction.";
</div>
<div class="codeline">
      otherwise:         
</div>
<div class="codeline">
         say "Looking [D], you can see [huge-list with indefinite
articles]."
</div>
</div>
The code above uses a list (a global variable) called the huge-list,
which we’ll create in the next section. The huge-list is not a permanent
thing; we’ll assemble it dynamically each time it needs to be used.
We’ll do this by checking for huge things. A huge thing, as you might
imagine, is something that’s big enough to see from a distance when
outdoors. Nothing in the game will be huge unless the author says it is.

Things that are huge will need to be added to scope in every turn when
the player is in an outdoor room. This will assure that the player can
refer to them in commands.

<div class="codeblock">
<div class="codeline">
A thing can be huge. A thing is usually not huge.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Definition: a room is neighboring if the number of moves from it to the
location is 1.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
After deciding the scope of the player when the location is an outdoor
room:
</div>
<div class="codeline">
   assemble the huge-list;
</div>
<div class="codeline">
   repeat with item running through huge-list:
</div>
<div class="codeline">
      place item in scope.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
The huge-list is a list of things that varies. The huge-list is {}.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
To assemble the huge-list:
</div>
<div class="codeline">
   now the huge-list is {};
</div>
<div class="codeline">
   let room-inv be a list of things;
</div>
<div class="codeline">
   repeat with R running through neighboring rooms:
</div>
<div class="codeline">
      now room-inv is {};
</div>
<div class="codeline">
      repeat with item running through things in R:
</div>
<div class="codeline">
         add item to room-inv;
</div>
<div class="codeline">
      repeat with item running through room-inv:
</div>
<div class="codeline">
         if item is huge:
</div>
<div class="codeline">
            add item to huge-list.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
To assemble the huge-list for (R - a room):
</div>
<div class="codeline">
   now the huge-list is {};
</div>
<div class="codeline">
   let room-inv be a list of things;
</div>
<div class="codeline">
   repeat with item running through things in R:
</div>
<div class="codeline">
      add item to room-inv;
</div>
<div class="codeline">
   repeat with item running through room-inv:
</div>
<div class="codeline">
      if item is huge:
</div>
<div class="codeline">
         add item to huge-list.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Instead of examining a huge thing:
</div>
<div class="codeline">
   if the noun is not in the location:
</div>
<div class="codeline">
      say "[The noun] [are] too far away for you to make out any
detail.";
</div>
<div class="codeline">
   otherwise:
</div>
<div class="codeline">
      continue the action.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Before doing anything other than examining with a huge thing:
</div>
<div class="codeline">
   if the noun is not enclosed by the location:
</div>
<div class="codeline">
      say "[The noun] [are] too far away.";
</div>
<div class="codeline">
      rule fails;
</div>
<div class="codeline">
   otherwise:
</div>
<div class="codeline">
      continue the action.
</div>
</div>
Next, we’ll implement floorless rooms (more or less in the manner
discussed in [Floorless Rooms](#floorless-rooms)). The reason for
including floorless rooms in the example will become apparent in a
moment.

<div class="codeblock">
<div class="codeline">
Limbo is a room. [Because this is the first room mentioned, we will soon
have to make sure the player character starts the game in the Living
Room.]
</div>
<div class="codeline">
 
</div>
<div class="codeline">
A room can be floorless. A room is usually not floorless. A room has a
room called the drop zone. The drop zone of a room is usually Limbo.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
After dropping something in a floorless room (called R):
</div>
<div class="codeline">
   let DZ be the drop zone of R;
</div>
<div class="codeline">
   move the noun to DZ;
</div>
<div class="codeline">
   say "[The noun] plummets down out of sight."
</div>
</div>
The final facet of this example is to let the player throw things from
one room into another (but only when outdoors). First we’ll add a few
more vocabulary words as synonyms for “drop”. We really only want these
words to be used in the new direction-throwing action, but if we don’t
add them to the drop action, Inform will respond to the command TOSS THE
BALL by saying “What do you want to toss the ball?” This would be ugly.

Note also that if there’s any reason in the game why the player won’t be
allowed to drop things – such as being tied up – the game’s code will
need to prevent direction-throwing in that circumstance as well. If you
omit this step, the player will have an unintended way to drop things,
by typing something like THROW RABID GERBIL EAST.

<div class="codeblock">
<div class="codeline">
Understand "hurl [something]", "toss [something]", and "pitch
[something]" as dropping.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Understand "upward" as up.
</div>
<div class="codeline">
Understand "downward" as down.
</div>
<div class="codeline">
Understand "eastward" as east.
</div>
<div class="codeline">
Understand "westward" as west.
</div>
<div class="codeline">
Understand "northward" as north.
</div>
<div class="codeline">
Understand "southward" as south.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Direction-throwing is an action applying to one thing and one visible
thing and requiring light. Understand "throw [something] [direction]",
"hurl [something] [direction]", "pitch [something] [direction]", and
"toss [something] [direction]" as direction-throwing.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
To bounce is a verb. [Here, we add some verbs so we can use them in
brackets in the say statements in the rules we’re about to define. This
will let Inform decide if the verb should be plural or singular in
form.]
</div>
<div class="codeline">
 
</div>
<div class="codeline">
To come (he comes, they come, he came) is a verb.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
[We're not going to let you throw things through a door from one room to
another, on the theory that your aim isn't very good:]
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Check direction-throwing:
</div>
<div class="codeline">
   if the player does not carry the noun:
</div>
<div class="codeline">
      say "You can't throw something you're not holding." instead;
</div>
<div class="codeline">
   otherwise if the noun is huge:
</div>
<div class="codeline">
      say "[The noun] [are] too heavy to throw." instead;
</div>
<div class="codeline">
   otherwise if the location is not an outdoor room:
</div>
<div class="codeline">
      say "[The noun] [bounce] off the wall and [come] to rest on the
floor.";
</div>
<div class="codeline">
      move the noun to the location;
</div>
<div class="codeline">
      rule succeeds;
</div>
<div class="codeline">
   otherwise:
</div>
<div class="codeline">
      let D be the second noun;
</div>
<div class="codeline">
      if the room D from the location is nowhere:
</div>
<div class="codeline">
         try dropping the noun instead.
</div>
</div>
If the direction-throwing action hasn’t been stopped by the check rule,
we know (a) that the player is carrying the noun, (b) that the noun is
small enough to throw, (c) that the player is outdoors, and (d) that
there is a room in that direction, to which the noun can be thrown.

The carry out rule, below, moves the thrown object off into whatever
room exists in the direction the player has thrown the object – unless
the room in that direction is floorless. If the destination is
floorless, the thrown object will instead end up in the drop zone of the
floorless room.

The report rule checks to see where the noun has landed. If the player
has tried to throw it up into a tree (a floorless room), it will by this
time have landed somewhere else. This would most likely be the room the
player is in (if she’s standing at the base of the tree) – but that’s
not guaranteed. The player could be out on the limb of a tree and throw
something south, toward the main part of the tree, thus causing it to
drop to the ground below.

<div class="codeblock">
<div class="codeline">
Carry out direction-throwing:
</div>
<div class="codeline">
   let D be the second noun;
</div>
<div class="codeline">
   let R be the room D from the location;
</div>
<div class="codeline">
   if R is floorless:
</div>
<div class="codeline">
      let DZ be the drop zone of R;
</div>
<div class="codeline">
      now the noun is in DZ;
</div>
<div class="codeline">
   otherwise:
</div>
<div class="codeline">
      now the noun is in R.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
To sail is a verb. To land is a verb.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
To fall (he falls, they fall, he fell, it is fallen) is a verb.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
Report direction-throwing:
</div>
<div class="codeline">
   if the noun is in the location:
</div>
<div class="codeline">
      say "You throw [the noun], and [regarding the noun][they] [sail]
away through the air, but a moment later [they] [fall] back and [land]
beside you.";
</div>
<div class="codeline">
   otherwise:
</div>
<div class="codeline">
      say "You hurl [the noun] [second noun], and [regarding the
noun][they] [sail] away out of sight."
</div>
</div>
And here’s an entirely pointless scenario with a few rooms and objects,
which you can use to test the example. You can try throwing things in
various directions while indoors or outdoors, looking various directions
while indoors and outdoors, and examining huge things that are far away.

<div class="codeblock">
<div class="codeline">
The Living Room is an indoor room. "The front door is north, the kitchen
south."
</div>
<div class="codeline">
 
</div>
<div class="codeline">
The player is in the Living Room. The player carries some galoshes.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
The Kitchen is south of the Living Room. The Kitchen is an indoor room.
"Not much here. You can go north."
</div>
<div class="codeline">
 
</div>
<div class="codeline">
The Yard is an outdoor room. The yard is north of the Living Room. "The
lawn wants cutting. The front door is south, and the hill is east."
</div>
<div class="codeline">
 
</div>
<div class="codeline">
The Hill is an outdoor room. The Hill is east of the Yard. "From the top
of the hill, you can see back west into the yard. There's a tree here
you could climb."
</div>
<div class="codeline">
 
</div>
<div class="codeline">
The buffalo is in the Hill. The buffalo is huge. The description of the
buffalo is "Big and brown." [Absurdly, the buffalo can be picked up and
carried around. This makes it easy to try throwing huge things and so
forth.]
</div>
<div class="codeline">
 
</div>
<div class="codeline">
The cabbage is in the Hill.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
The ferris wheel is in the Hill. The ferris wheel is huge. It is fixed
in place. The description of the ferris wheel is "Big and round."
</div>
<div class="codeline">
 
</div>
<div class="codeline">
The Treetop is a floorless outdoor room. "You're surrounded by leaves."
The Treetop is up from the Hill. The drop zone of the Treetop is the
Hill.
</div>
<div class="codeline">
 
</div>
<div class="codeline">
The Treetop is a floorless outdoor room. "You're surrounded by leaves."
The Treetop is up from the Hill. The drop zone of the Treetop is the
Hill.
</div>
</div>
</div>



[1]: https://github.com/i7/extensions/blob/master/John%20Clemens/Consolidated%20Multiple%20Actions.i7x
[2]: https://intfiction.org/t/i7-giving-orders-to-a-device-format-is-name-order/677
[3]: https://intfiction.org/t/action-names/678
