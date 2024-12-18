## Chapter 6: Puzzles   {#chapter-6-puzzles}

In the short section on puzzles in Chapter 1, I pointed out that a few
games are “puzzleless,” but that most games have a few puzzles, or a lot
of them. The point of including puzzles is that the player becomes a
sort of collaborator in the unfolding of the story. The story will only
move forward when the player takes some action.

Almost any sort of action might be required – watering a tiny plant, for
instance, might turn it into a giant beanstalk that can be climbed. But
possibly the most basic form of puzzle in IF is the locked door. The
player doesn’t yet have the key that unlocks the door, and has to hunt
for the key. Unlocking and opening the door will give the player access
to a new room, or perhaps to an entirely new region of the model world
containing dozens of rooms.

The way I look at it, every puzzle in every game, no matter what form it
might take, is ultimately not very different from a locked door. You
can’t see what’s on the other side until you find the key, whatever the
key is. What’s on the other side might be a physical location or a
series of new events. The “key” might be an apple that you need to give
to the wicked witch so she’ll go to sleep so you can rescue the children
in the oven. In some sense, the apple is a key, although the code you’ll
write to handle the command GIVE APPLE TO WITCH will probably look
somewhat different from the code for UNLOCK DOOR WITH KEY.

In this chapter we’ll take a look at many of the common types of
puzzles, and suggest a few ways to implement them. This is not, I hasten
to add, a complete inventory of puzzle types. It’s intended merely to
introduce a few ideas that new IF writers may not have considered.

IF authors have written lots of essays and tips about puzzles. Stephen
Granade has a good short essay on [Making Better Puzzles][1]). Graham
Nelson’s manual on programming Inform 6, the [*Designer\'s Manual, 4th
edition*][2] (DM4), has a very good section on [the design of
puzzles][3]. (In case you’re unfamiliar with Inform 6, perhaps I should
add that nothing else in the DM4 will be of much use to you as an Inform
7 author – at least not until you start writing I6 inclusions, an
advanced type of programming not covered in this *Handbook.*)

I like to include some easy puzzles in a game, and a few hard ones. But
as a player, I prefer the easy ones, because I’m very bad at
puzzle-solving. While playing other people’s games, I often get stuck.
Many authors feel that it’s a good idea to help players by including
some form of hint system in the game. You’ll find some advice on how to
set up a hint system in [Chapter 10, Advanced
Topics](#chapter-10-advanced-topics). Other authors feel that providing
hints spoils the game, or is just too much trouble.

### Mapping   {#mapping}

Creating and maintaining a map that shows the layout of the game isn’t
much of a puzzle, but it definitely qualifies. The player who neglects
to create a pencilled map on which she notes that there’s a south exit
from the Library is quite likely to miss something important in the
game.

Many games today include a full list of available exits (or at least, of
the obvious exits ― see below) as part of the room description. In some
older games, this convention wasn’t adhered to: exits might not be
mentioned at all. Trying all of the available compass directions, only
to be told over and over, “You can’t go that way,” is not much fun,
which is why this type of puzzle isn’t much used anymore.

The classic example of a mapping puzzle is a maze. A maze is a set of
rooms (usually between ten and fifty of them) in which the player can
move freely, but in which navigation is difficult for some reason. Most
players don’t like mazes, because mazes can be mind-numbingly repetitive
to solve.

The original game of Adventure had two mazes. The room descriptions
within each maze were all identical (and no exits were listed), so just
LOOKing wouldn’t tell you where you were. The connections between rooms
in a maze is likely to be “twisty,” which means that if you go north
from room A and arrive in room B, going south from room B quite likely
won’t take you back to room A. Some room connections may even fold back
on themselves: When you go east from room A, you may end up back in room
A! This type of navigation system is easy to set up in Inform (see
“Twisty Connections” in Chapter 2 of the *Handbook*).

The time-honored way to map this type of maze is to drop an object in
each room as you go along. The pattern of dropped objects then allows
the player to differentiate the rooms from one another and work out the
navigational routes. If you put this type of maze in a modern game, it’s
safe to say you’ll amuse nobody. But there are many ways to make mazes
interesting (at least, they’ll be interesting to people who don’t mind
mazes). In “A Flustered Duck,” I included a maze that could only be
mapped while the player character is wearing a blindfold. When the
blindfold is not worn, the connections between rooms are entirely random
and the room descriptions are all identical – but when the PC is wearing
a blindfold, he can find distinct room connections using his sense of
touch.

### Blocked Passageways   {#blocked-passageways}

A locked door is obviously a type of blocked passageway. In “The Craft
of Adventure,” Graham Nelson observes, “Almost invariably games close
off sections of the map (temporarily) by putting them behind locked
doors, which the player can see and gnash her teeth over, but cannot yet
open. And almost every variation on this theme has been tried: coded
messages on the door, illusory defenses, gate-keepers, the key being in
the lock on the wrong side, and so on. Still, the usual thing is simply
to find a key in some fairly remote place, bring it to the door, and
open it.”

Quite often you’ll find several locked doors in a game, and several
keys. This can be at least mildly amusing, because the player usually
has the wrong key. Finding a good place to hide the key isn’t always
easy. Experienced players will try LOOK BEHIND and LOOK UNDER with any
object (such as a bed, painting, or rug) that looks as if it might
conceal a small object. You can also expect players to SEARCH anything
(such as a couch with cushions) that looks to be a likely place where
something might be hidden. For more on how to set this up, see Chapter
3, “Things.”

Popular variants on the locked door include chasms too wide to leap
across (with or without a bridge too flimsy to support your weight),
doors guarded by uncooperative characters who won’t let you pass (see
“The Uncooperative Character,” below), and secret doors. The secret door
appears not to be a door at all (see “Hidden Items,” below), so the
“unlocking” process is mainly a matter of finding the door.

The inventory-blocking passage is a related type. In this puzzle, you
can traverse a passageway freely ― but not while carrying certain items.
And of course, you’ll almost certainly need those items once you get to
the far side of the passageway, so this can also be considered an
inventory manipulation puzzle. A fiendish inventory-blocking passageway,
which (unless my memory is playing tricks on me) dates clear back to
“Adventure,” is a passage through which a powerful wind is blowing – a
wind that will blow out your lamp or candle. This puzzle is a cross
between the inventory-blocking passageway and the darkness puzzle (see
below).

It’s worth noting, however, that not all cases in which inventory can’t
be carried through a passage are puzzles. In some games, the author
chooses to manage the player’s inventory by making each area of the map
self-contained. Inventory items may be dropped automatically when you
use the passageway, or the passageway may remain blocked until you get
rid of what you’re carrying. (It may not always be obvious, though
perhaps it ought to be, whether the blockage is a puzzle or just the
author’s inventory management system at work.)

The ultimate blocked-passageway puzzle is a single room from which there
appears to be no exit at all (except perhaps a locked door to which you
lack the key). This room is often a prison cell, but other variations
are common. The solution may involve inspecting all of the items in the
room *very* carefully or conversing with someone who is on the other
side of the wall.

### Darkness   {#darkness}

The need to bring a light source into a dark room or rooms is a puzzle
that dates clear back to “Adventure,” which of course was set in a
system of caves (see [Dark Rooms](#dark-rooms)). To solve a dark room
puzzle, the player has to find and carry an object that provides light.
Today, most rooms in most games are lighted by default, but dark rooms
still show up in quite a few games. The light source that’s needed may
be unusual, or may last for only a limited number of turns – a burning
match, for instance – making the dark room a timed puzzle. (See “Timed
Puzzles,” below.)

A variant of the dark room puzzle is a dim room, in which you can see
some things, probably large ones, but not small things. You might be
unable to read written materials in the dim room, for instance.

Objects dropped in dark rooms can’t be picked up again. This fact
requires careful thought; it’s possible to make your game unwinnable
without meaning to – for instance if the player drops the matches in the
dark room before finding the candle. If you don’t want to allow the game
to become unwinnable, you’ll need to write a rule that will prevent this
from happening:

```
Instead of dropping the candle:
	if the player is in a dark room:
		say "Better keep your hands on the candle for now. You may need it later.";
	otherwise:
		continue the action.
```

### Hidden Items   {#hidden-items}

Experienced players of IF know to EXAMINE everything that’s mentioned in
the room description, or in a description of another object. So it’s
fair to tuck clues to various puzzles in descriptions. Quite often, the
room will contain an object which is itself scenery, but which will
reveal further details when examined. The description of a wall panel,
for instance, might suggest to the player that the panel is a secret
door. Or maybe the panel looks entirely innocent when examined, but if
the player examines the rug he’ll learn that a semicircular mark on the
rug curves out from the wall panel. (If you’re going to do that, be sure
to mention the rug in the room description.) The details are “hidden”
only in a technical sense, because you have to examine something else in
order to notice them, so this is only barely a puzzle. Many games that
award points don’t award any points for examining things, because the
action is just too easy and obvious.

Examining won’t always reveal hidden items, however. As a player, you’ll
want to get in the habit of looking under and behind anything large.
Containers may need to be searched in order to reveal what’s hidden in
them. By default, Inform will list the contents of any open container
when the player examines the container, but as an author you might want
to make the puzzle a tiny bit more difficult. If you do this, though, it
would be a courtesy to the player to provide a clue that more action
needs to be taken. Here’s a not very subtle example, in which “almost
anything might be buried down there” serves as a clue:

```
The Living Room is a room. "Your comfy living room."

The big old box is an open container in the living room.The description is "It's just a big old box[one of] full of junk. There's so much stuff that almost anything might be buried down there[or][stopping]."

The pile of old junk is in the box. The description is "A horrible mass of rusty old junk." Understand "rusty" as the junk.

Instead of taking the junk:
	say "You have no need to burden yourself with a pile of old junk."

The jewel-encrusted bracelet is a thing. The description is "Diamonds and sapphires and rubies, oh my!"

Instead of searching the box for the first time:
	try searching the junk.

Instead of searching the junk for the first time:
	say "Down among the rusty junk, you spot a priceless jewel-encrusted bracelet!";
	now the bracelet is in the box.
```

The result, when the game is played, looks like this:

> **Living Room** \
> Your comfy living room. \
> You can see a big old box (in which is a pile of old junk) here. \
>  \
> <span class="command">x box</span> \
> It\'s just a big old box full of junk. There\'s so much stuff that \
> almost anything might be buried down there. \
> In the big old box is a pile of old junk. \
>  \
> <span class="command">look in box</span> \
> Down among the rusty junk, you spot a priceless jewel-encrusted \
> bracelet! \
>  \
> <span class="command">x box</span> \
> It\'s just a big old box. \
> In the big old box are a jewel-encrusted bracelet and a pile of old \
> junk.

The LOOK IN command causes the same action as SEARCH.

A sorting puzzle probably qualifies as a subtype of the hidden item
puzzle. In a sorting puzzle, there are a great many similar or seemingly
identical objects, all available at the same time. Your goal is to find
a way to distinguish the one you want from all of the others. For an
especially fiendish example of this, you might want to download and play
the game “69,105 Keys.” It’s a one-room game with a locked vault, and,
you guessed it, 69,105 keys, only one of which opens the vault.

### Items Out of Reach   {#items-out-of-reach}

Putting an important object on a high shelf or at the bottom of a narrow
hole, where the object can be seen but not touched, is a common puzzle.
The player may need to stand on a chair to reach the shelf, or find a
giant magnet on a rope to retrieve the iron key from the hold. Sometimes
the solution is to go around to an entirely different location, from
where the shelf or hole bottom is reachable. Sometimes the solution is
to shake the shelf so that what’s on it will fall off.

### Locked Containers   {#locked-containers}

As with a locked door, the usual way to open a locked container is to
find the key. Sometimes the locked container has a glass door, so that
what’s in it can be seen but not reached. (The way to do this in Inform
is to make the container *transparent*. This word has a special meaning
to the compiler and the parser.) Once in a while the solution is simply
to break the container.

### Combination Locks   {#combination-locks}

Either a door or a locked container may have a combination lock instead
of a physical key. The most straightforward type of combination lock
puzzle is, perhaps literally, a combination lock. It may have a single
dial that needs to be turned to three or four numbers in succession, or
a row of dials each of which needs to be set to a specific number. The
number of possible combinations is likely to be large, so the only
practical way to solve the puzzle is to find the piece of paper on which
some thoughtful or absent-minded person has scribbled down the
combination.

A more interesting combination lock puzzle can be created by scattering
clues around. For instance, the dials might be of various colors, and
each dial might have a number of symbols on it. Somewhere in the model
world you might find the color red associated with a bird, which would
be a clue that the red dial should be turned to the bird symbol. ([Blue
Lacuna by Aaron Reed][4] has a puzzle of this type.)

Large mechanisms such as revolving rooms can operate as combination
locks: To use one or more of the exits from the room, you’ll need to
figure out how the buttons and levers change the orientation of the
room. In another variant, the buttons and levers might not be in the
same room as the lock mechanism itself: To solve the puzzle, you may
need to travel from room to room to see what happened when you moved the
lever.

In a more general sense, any puzzle that requires the player to perform
two or more actions in a specific order qualifies as a combination lock.
If the game includes a muzzle-loading rifle, for instance, the player
will need to pour the powder into the barrel, place a patch on the end
of the barrel, put the ball in the patch, and then use the ramrod to
push the ball and patch down into the barrel. If the player puts the
bullet into the barrel first and then the powder, the rifle won’t fire.
(The real procedure also requires measuring the powder, tapping the
stock against the ground to settle the powder, and using a bullet
starter before the ramrod to get the ball started down the barrel. But
that may be too much detail for a game.)

### Manipulation Difficulties   {#manipulation-difficulties}

Many games include objects that are too heavy to lift, too hot, too
slippery, or difficult to handle for some other reason. This type of
puzzle offers many opportunities for the author. Providing a handy oven
mitt for picking up the hot object might be too obvious: you might want
to give the player a baseball glove instead.

Figuring out how to operate machinery can be easy, or almost endlessly
complicated. In [The Craft of Adventure (PDF)][5], Graham Nelson
comments, “In some ways the easiest puzzles to write sensibly are
machines, which need to be manipulated: levers to pull, switches to
press, cogs to turn, ropes to pull…. They often require tools, which
brings in objects. They can transform things in a semi-magical way (coal
to diamonds being the cliché) and can plausibly do almost anything if
sufficiently mysterious and strange: time travel, for instance.”

Among the things one may find in a game that pose manipulation
difficulties – and also implementation difficulties for the author – are
fire, water, rope, and chemicals of all kinds. [Chapter 10 of the
*Inform Recipe Book*](../RB_10.html) has some good examples of how to
create puzzles of this type. You might want the player to mix three
chemicals to create a new substance, for instance. Mixing would
naturally require a container that the ingredients can be put into. (The
cocoa mug puzzle in [Lydia’s Heart][6] was easily the most complex and
difficult puzzle to write in the game, and I’m still not sure it’s free
of bugs. The puzzle had three ingredients – a paper envelope full of
powdered cocoa, a sleeping pill, and some water. The water could be
either hot or cold, and once the pill or powder was combined with the
water, it couldn’t be extracted again. This kind of thing can be fun if
it’s well done, but it’s treacherously easy to do it badly.)

Here’s a simpler example of [a manipulation difficulty puzzle, which was
suggested by a post from Susie on the newsgroup][7]. The player can only
see things while wearing glasses. To implement this, we need to
intercept both the LOOK and EXAMINE actions. It also seems advisable to
stop the player from picking things up while not wearing the glasses.
But if we do that, we also have to be careful to allow her to pick up
the glasses while not wearing them – otherwise, dropping the glasses
will make the game unwinnable.

```
The player is wearing some glasses. The description is "They're as thick as bottle-bottoms." Understand "bifocals" and "spectacles" as the glasses.

Instead of looking when the player is not wearing the glasses:
		say "Unfortunately, you're as blind as a bat without your glasses."
Instead of examining something when the player is not wearing the glasses:
	try looking instead.

Instead of taking something when the player is not wearing the glasses:
	say "You grope around, but you can't find a darn thing."

Instead of taking the glasses when the player is not wearing the glasses:
	if the player does not enclose the glasses:
		say "You grope around blindly and somehow find your glasses.";
		now the player carries the glasses;
	otherwise:
		say "You've already got them."
```

Because the instead rule about taking the glasses is more specific than
the instead rule about taking something, it will be listed earlier in
the instead rulebook. This is what we want: The player will be able to
pick up the glasses.

A subtype of manipulation difficulties is what we might call the
strapped-to-a-table puzzle. I’ve seen this puzzle presented at the
beginning of a game, but it might happen at any point, especially after
the player character has been knocked unconscious. The puzzle is, you
don’t seem to be able to do *anything.* The repertoire of actions
normally allowed in IF is all (or seemingly all) disabled. In Emily
Short’s one-room game “Glass,” for instance, you’re a bird on a perch.
Your wings have been clipped, so you can’t even fly. Eventually the
player discovers that there’s one thing that the bird *can* do. But I’ll
let you discover for yourself what it is.

### Enigmas   {#enigmas}

A commentator on rec.arts.int-fiction (I’ve forgotten who) made an
interesting distinction between puzzles and problems. Problems, he
maintained, are difficulties that are intrinsic or sensible in the world
of the story. By that definition, most of what we’ve been looking at in
this chapter are problems, not puzzles. A puzzle-type puzzle, in
contrast, is something that doesn’t have any business being in the world
of the story: It’s there strictly to give the player some mental
gymnastics. If we’re going to keep using the word “puzzle” in a broader
sense, to refer to all of the problems that the PC may face during the
story, we might call this type of puzzle an enigma.

The ultimate example of an enigma is the game [Gostak by Carl
Muckenhaupt][8]. In this game, *all* of the nouns and verbs, including
the ones you use in commands, have been replaced by nonsense words of
the author’s own devising. The puzzle is to figure out how to read the
text of the game and issue commands. [Roger Firth’s Letters from
Home][9] is also an enigma-based game, with only a thin veneer of story.

### Deceptive Appearances & Unusual Usages   {#deceptive-appearances-unusual-usages}

An object with a deceptive appearance is different from an object whose
description is poorly written (see “Inadequate Implementation,” below).
The initial description of an object might be vague because the PC has
never seen anything like it and doesn’t know what it is, or because only
part of it is present, thus giving it an enigmatic shape, or because it
is in an odd condition.

As a simple example, consider an object called “a wadded-up piece of
paper”. This is quite likely a deceptive appearance. If you try READ
PAPER, you’ll probably be told, “You can’t read a wadded-up piece of
paper!” However, commands like SMOOTH PAPER and UNFOLD PAPER will
probably change the name of the item to “a slightly wrinkled note”,
after which READ PAPER or READ NOTE will reveal what’s written on it.

A variant of the unusual usage puzzle is what we might call the
unexpected action puzzle. This isn’t quite the same as a guess-the-verb
puzzle, because the author has done it on purpose. Suppose, for
instance, that you’ve got a little glass bottle with some tablets in it.
The top of the bottle is stuck tight, so OPEN BOTTLE simply doesn’t
work. However, BREAK BOTTLE might be the intended solution of the
puzzle. This particular example also fits in the locked container
category. A better example might be an object described as “a small
tarnished piece of metal.” The command POLISH METAL might turn this
object into a mirror which which you could direct a beam of light. To
implement this, you’d also want to change the object’s printed name
property. A better solution, especially if the mirror is going to be
useful as a solution to a later puzzle, is to whisk the tarnished piece
of metal off-stage and replace it with a new object that has been
waiting in the wings. The rubbing action already has “polish” as a
synonym, so we can write this:

```
The player carries a small tarnished piece of metal. The description is "It's rather corroded."

The polished hand mirror is a thing. The description is "A gleaming smooth mirror, small enough to fit in the palm of your hand."

Instead of rubbing the piece of metal:
	now the piece of metal is nowhere;
	now the player carries the polished hand mirror;
	say "As you rub the corrosion from the piece of metal, its true identity is revealed: It's a hand mirror!"
```

### Assembly Required   {#assembly-required}

Sometimes objects have been taken apart, and the player has to put them
back together in order to use them. In Chapter 3 of this *Handbook* we
looked at a postcard and a stamp. The stamp could be attached to the
postcard. If this is a puzzle, maybe the player would then have to put
the postcard into a slot in the Post Office. If the stamp hasn’t been
attached, the message will never be delivered.

Another simple example would be a length of metal pipe that can be
inserted into an appropriately positioned hole in a machine. When the
player does this, the piece of metal becomes a crank that can be turned.

The relationships among the parts may be obvious – a lightbulb that
needs to be put in a lamp, for instance. Or the player may be called on
to improvise by assembling objects that have no obvious relationship to
one another.

[The King of Shreds & Patches][10] has a very nice assembly puzzle in
the form of a flintlock pistol that has to be loaded before it can be
fired. The materials (powder, lead balls, and so on) are all readily at
hand, but the player has to figure out how to manipulate them. What’s
especially nice about this puzzle is that once the player has done it
the first time the hard way, the command LOAD PISTOL can be used as a
shortcut to do it again.

### Mechanisms   {#mechanisms}

Mechanical devices that have to be switched on, or that need power to
operate, are common. A mechanical device may have several buttons or
levers, and it may not be obvious what the buttons and levers do. They
might seem to do nothing, or do nothing in the room that the player is
in while having an important effect in a different room. Or the result
of pressing a button or pulling a lever might be delayed for a few
turns.

A mechanical device may have a gauge or data readout whose meaning is
not clear. If you pull the red lever, for instance, the green dial might
change to read “3”. In this case, you may have to figure out what
several levers do, and what the readings on the dials mean.

### Vehicles   {#vehicles}

A vehicle in which the player can travel around will seldom be a puzzle
in its own right. More often, it’s an example of one or two other types
of puzzles ― mapping and manipulation difficulties. That is, you’ll need
to figure out how to use the vehicle, which may involve finding the lost
steering wheel or just understanding what the red and green buttons do;
and then learn, probably by pressing the red button, where it can take
you. On occasion you may have to fuel the vehicle, which would come
under the heading “Assembly Required.” You may find that some objects
can’t be carried in the vehicle, which would be an inventory-blocked
passageway, or that the vehicle is required in order to carry certain
objects from place to place – again, an inventory-blocked passageway.
You may need to get out of the moving vehicle at a specific moment,
which would be a timed puzzle.

Conveyances such as wheelbarrows, that have to be pushed from place to
place, are used, again, mainly as a way of handling inventory objects.

### Consulting Information Sources   {#consulting-information-sources}

In many games, key pieces of information are hidden in a large book, or
possibly in a computer terminal of some sort. To get at the information,
the player uses a syntax like LOOK UP KING HENRY IN HISTORY BOOK or LOOK
UP POISONS IN COMPUTER. The solution to this sort of puzzle is to keep
trying topics until you find an input that the information source
responds to. Or the player may need to find another piece of information
somewhere that says, in essence, “King Henry is listed on page 447 of
the history book.” Once the player is in possession of this information,
TURN TO PAGE 447 should reveal the information.

Alternatively, the information may simply be written on a piece of paper
in the game, or scrawled on a blackboard, and the puzzle is to find it.
In some games, the information on the paper or blackboard is incomplete
or difficult to understand. It may be written in code, or the paper on
which it’s written may have been torn up, forcing the player to collect
the scraps in order to decipher the complete message.

Not all of the information sources in games are in the form of
encyclopedias, computers, and carelessly dropped notes. If you see any
murals, mosaics, paintings, or tapestries in a game, pay close attention
to the images depicted on them. Likewise carvings. Sound and video
playback devices are a bit less often used, but they do show up from
time to time. The player may need to TURN ON TAPE PLAYER, for instance,
followed by an esoteric command like FAST-FORWARD TO 447.

With an informal type of information source, it’s usual that you won’t
know immediately whether you’re getting useful information or just
background on the story. This is especially true of NPCs, who may ramble
on about all sorts of topics, their conversation containing disguised or
ambiguous information.

### The Uncooperative Character   {#the-uncooperative-character}

People and animals can function as puzzles in several different ways.
Guards and guard dogs, for instance, can be relied on not to let the
player pass through a tempting doorway. The door isn’t locked, but it
might as well be. The player has to figure out a way to distract or make
friends with the guard. Almost any character can act as a guard – a
fussy librarian, for instance, who won’t let the player into the
computer room until the player shows her a library card.

Instead, a character might have an object that the player needs, and the
puzzle might be how to get him or her to hand it over. Some characters
can do things the player character can’t, in which case the puzzle is
how to get the character to follow instructions and perform some action.
The player might be unable to retrieve an object at the bottom of a
pool, for instance, not knowing how to swim – but a friendly dolphin
might be willing to obey orders. (How a dolphin would pick something up
… I’ll leave you to work that out for yourself.)

### Timed Puzzles   {#timed-puzzles}

Generally speaking, time passes in IF only when you issue a command. (A
few games include real-time events, but this is not common.) In a timed
puzzle, something is happening, and you need to interact with it within
a specified number of turns. You may need to figure out the proper
command, or even issue a whole sequence of commands, within a fixed
time-frame.

The simplest type of timed puzzle is, of course, a lighted fuse attached
to a bomb. Also simple (and dating back to the very first IF) is the
light source that will expire after a fixed number of turns, perhaps
because it’s a battery-powered flashlight. The player who is left in a
dark room when the battery dies is likely to be in serious trouble. In
the early days of IF, games sometimes required that the PC eat and/or
sleep on a regular schedule; failure to do so would have bad
consequences. Eating and sleeping are no longer common in modern games,
because they’re not very interesting.

The rowboat puzzle in “King of Shreds & Patches” is a complex timed
puzzle. You’re in a boat on a river, and the boat is being carried
downstream by the current. Unless you visualize clearly how the boat is
moving and issue the correct navigation commands, you’ll be unable to
reach the dock before the small hole in the bottom of the boat causes
the boat to sink.

If you fail to take the proper action in a timed puzzle, the game will
almost certainly become unwinnable, and quite likely will end in a
sudden and spectacular way. Timed puzzles are, by their nature, somewhat
more cruel than other types of puzzles, because the possibility of
losing the game is more immediate.

A relative of the timed puzzle is what might be called a
course-of-events game. In a game of this sort, you may be able to get
from the start of the story to the end by typing ‘z’ over and over – no
action is required, as the course of events will unfold without your
taking any action at all. However, if you do that, you may well miss the
point of the story entirely, or fail to reach the most desirable ending.
Your opportunity to influence the course of events (and thereby steer
the course of the story) will have passed unnoticed. The puzzle lies in
figuring out exactly how your actions may influence the course of
events. Asking certain questions of a character at certain times, for
instance, may have a large effect – but it may not be obvious what to
ask, or when. Emily Short’s short game “Glass” provides an excellent
example of this type of puzzle.

### Inadequate Implementation   {#inadequate-implementation}

This isn’t really a type of puzzle, except in the technical sense: It’s
a design flaw ― and a serious one. In an inadequate implementation
puzzle (which can be of almost any type), the player lacks necessary
information because the author has neglected to include it, either in
the output text or in the software code. The “puzzle” boils down to
making random guesses or reading the author’s mind, which is pretty much
the same thing.

The most common subtype of the inadequate implementation puzzle is
called a guess-the-verb puzzle. You (the player) can see exactly what
you need to do to solve the puzzle, but the author has failed to write
code that handles any of the obvious and appropriate commands that you
try. Very few things are more infuriating for an IF player than trying
‘stab guard with sword’, ‘cut guard with sword’, ‘kill guard’, ‘attack
guard with sword’, and so on, being met in each case with a blank
refusal by the game, only to find that the correct syntax is ‘swing
sword’ while you’re in the room with the guard.

Another subtype is the inadequately described room or object. Describing
the manner in which a complex mechanical puzzle is constructed is not
easy, and it’s a place where many authors fall down on the job.

In his excellent essay [The Craft of Adventure][11], Graham Nelson
points out a related pitfall ― the in-joke puzzle. You may know what
scatological phrase is suggested by using the Greek letters in the name
of a certain fraternity as an acronym, or that Petrarch wrote sonnets
about a woman named Laura, or the month for which the birthstone is
topaz (it’s November), but it’s unlikely your players will make the
connection.

In writing your game, it’s vital that you think carefully about the
design of your puzzles.

First, have you given the player enough information to enable her to
solve the puzzle? Remember: Something that’s obvious to you (the author)
may be mystifying to anyone who can’t read your mind.

Second, have you considered and built into your game all of the commands
you can think of that a player might use while working on a puzzle?
Almost as bad as guess-the-verb puzzles are misleading responses from
the parser. Here’s an example:

> <span class="command">hit guard</span> \
> Violence isn’t the answer to this one. \
>  \
> <span class="command">hit guard with stick</span> \
> You smack the guard in the head with the stick, and he goes down like \
> a sack of potatoes. Congratulations! Now you can steal the jewels from \
> the vault!

Inform’s default response to HIT GUARD is just plain wrong in this case,
because violence *is* the answer to this one.



[1]: http://brasslantern.org/writers/iftheory/betterpuzzles-a.html
[2]: http://inform-fiction.org/manual/html/contents.html
[3]: http://inform-fiction.org/manual/html/s50.html
[4]: https://aareed.itch.io/blue-lacuna
[5]: https://mirror.ifarchive.org/if-archive/info/Craft.Of.Adventure.pdf
[6]: https://ifdb.org/viewgame?id=7t22wbllftv7nuiw
[7]: https://groups.google.com/g/rec.arts.int-fiction/c/5vue1RyLZEk/m/vPTSk7_0AvUJ
[8]: https://ifdb.org/viewgame?id=w5s3sv43s3p98v45
[9]: https://ifdb.org/viewgame?id=7d5kjxqadyuyfgzu
[10]: https://ifdb.org/viewgame?id=9ntef9expou18abv
[11]: https://ifarchive.org/if-archive/info/Craft.Of.Adventure.txt
