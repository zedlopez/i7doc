## Chapter 3: Things   {#chapter-3-things}

A lot of the fun of interactive fiction comes from being able to pick up
and use objects in the model world. At the beginning of this chapter,
you’ll learn how to create things. Once you’ve started creating things,
though, you’ll find that leaving them lying around where players can
just pick them up won’t give players much of a challenge. We’ll also
look at ways to hide things in the model world, so that finding a useful
object becomes a puzzle.

Most of the things you’ll create in a game will have uses. Some kinds of
things (such as keys) already have uses that Inform understands. But if
you create a bicycle pump so that the player can blow up a flat tire,
you’ll also need to create an *action*, as described in Chapter 4 of the
*Handbook,* so that the player can use the command INFLATE TIRE WITH
PUMP. Creating actions so that things become useful is an important part
of writing a good game.

Pretty much every object you create in your Inform game is a thing.
Computer science majors would tell you that “thing” is a base class – a
kind, in Inform’s terms – and that many other kinds, such as person and
door, *inherit* from the thing kind. But we don’t need to worry about
that jargon. In this *Handbook*, we’ll usually call an object in your
game a thing only when it isn’t any other kind of thing, such as a door
or container.

### Creating Things   {#creating-things}

The most basic way to create a new thing is to tell Inform that it
exists:

```
The paintbrush is a thing.
```

This is enough to create an object called the paintbrush. But as yet,
the paintbrush is not anywhere in the model world. That is, it won’t
appear anywhere when your players/readers encounter your game/story.
Sometimes this is what you want: You may need to create objects that are
offstage at the beginning of the game, so that your code can move them
onstage later. More often, you’ll write an assertion that will cause the
thing to appear in a certain place at the beginning of the game. You can
do it this way:

```
The Tool Shed is a room.
The paintbrush is in the Tool Shed.
```

Another way to do exactly the same thing is this:

```
The Tool Shed is a room.
The paintbrush is here.
```

I suggest not using “is here,” however. If you need to move paragraphs
or whole sections of your code around for any reason, or if you forget
how you’ve defined the paintbrush and add more code after the Tool Shed
assertion and before the sentence that creates the paintbrush, bad
things can happen. (That is, your code may acquire bugs.) It’s safer
always to tell Inform specifically where a thing is to be placed at the
beginning of the game. This is a safe way to create things, however:

```
The player carries a bowling ball.
The duchess wears a diamond tiara.
```

Inform will understand that both the bowling ball and the diamond tiara
are new things that need to be added to the model world. It will also
understand that the diamond tiara is **wearable** – that it’s something
characters can put on and take off.

Containers and supporters will be discussed in detail later in this
chapter. Briefly, a supporter is a thing that acts like a table, so
objects can be placed on it. This would also work well:

```
The Tool Shed is a room.
The workbench is a supporter in the Tool Shed.
The screwdriver is on the workbench.
```

Now Inform knows that the screwdriver is a thing, and knows exactly
where to put it at the start of the game.

The most important thing about things is that the player can pick them
up and carry them around. This is not true of some other types of
objects: The player won’t be allowed to pick up a door or a person, for
example.

Inform knows almost nothing else about newly created things, though. It
doesn’t know the difference between a screwdriver and a bowling ball. In
order to have these two things behave in different ways in your game,
you’ll have to write some action-processing code. (To learn how to do
this, see Chapter 4 of the *Handbook*.)

### Things vs. Kinds   {#things-vs-kinds}

New Inform writers sometimes get into trouble by using the word “kind”
when it’s not needed. This word has a special meaning in Inform. It
refers to types of objects – what traditional computer programmers call
“classes.” The usual reason to create kinds is so that you can write
code that will apply to several different objects, like this:

```
A fruit is a kind of thing. The banana is a fruit. The orange is a fruit. The plum is a fruit. The apple is a fruit.

Before eating a fruit:
	say "You’re not hungry right now." instead.
```

The Before rule shown above will apply when the player types EAT ORANGE,
or EAT PLUM, or EAT BANANA, or EAT APPLE. But if you should later happen
to create a peach and forget to tell Inform that the peach is a fruit,
the Before rule won’t be applied to EAT PEACH.

Here’s an example, adapted from a post on the newsgroup
rec.arts.int-fiction, of how you can get in trouble using the word
“kind” when you don’t need to:

```
A phaser is a kind of thing. 
A phaser can be either set to stun or set to kill. 
Instead of examining the phaser, say "Your shiny Mark Five phaser. Dual setting - stun and kill. [if the phaser is set to kill]It is currently set to kill.[Otherwise]It is currently set to stun." 
A phaser is usually set to stun. 

The player is carrying a phaser. Understand "Mark", "Five", and "shiny" as the phaser.

[Error: will not compile!]
Instead of setting the phaser to "kill":
	now the phaser is set to kill;
	say "You set your phaser to kill."
```

The problem is that the Instead rule is attempting to change the setting
not of any individual phaser but of the entire *kind.* Inform won’t let
the author do that. There are a couple of ways to solve the problem. We
can rewrite the Instead rule so that Inform knows which phaser to set:

```
Instead of setting a phaser (called P) to "kill":
	now P is set to kill;
	say "You set your phaser to kill."
```

Here’s another way to do exactly the same thing without using the
“called” phrase to create a temporary name for the object:

```
Instead of setting a phaser to "kill":
	now the noun is set to kill;
	say "You set your phaser to kill."
```

Both Instead rules for the phaser will work. Either way, Inform now
understands that it’s supposed to set one particular phaser to kill, and
it’s happy to do so. In general, though, creating a kind and then an
object that has the same name as the kind is best avoided. Sometimes
it’s necessary; for instance, the door kind is built into Inform, and it
would be silly to try to avoid calling a door a door. But if you can
come up with a specific word for your new kinds, a word that is not used
by any of the objects, you’ll create fewer confusing bugs.

Unless you’re planning to have several phasers in your game, there’s no
reason to make phaser a kind in the first place. Instead, make it a
plain old thing. The first sentence in the code below does exactly that:

```
The player carries a phaser. The phaser can be set to kill or set to stun. The phaser is set to stun. The description is "Your shiny Mark Five phaser. Dual setting - stun and kill. [if the phaser is set to kill]It is currently set to kill.[Otherwise]It is currently set to stun." Understand "Mark", "Five", and "shiny" as the phaser.

Instead of setting the phaser to "kill":
	now the phaser is set to kill;
	say "You set your phaser to kill."
```

Now the Instead rule for setting the phaser works the way the original
author of this code intended.

One reason for the confusion here, by the way, is that Inform quite
often ignores “a” and “the” when compiling. There are a few situations
where it notices “a” or “the”, such as when constructing lists, but in
this particular case it pays no attention whatever to the difference
that native English speakers would see between “a phaser” and “the
phaser”.

<div class="sidebar" id="noun-and-second-noun" markdown="1">
#### Noun & Second Noun

Notice the term “the noun” in the code above. The words “noun” and
“second noun” have a special meaning in Inform. The noun is a temporary
value (a variable) that refers to whatever object the player mentioned
in the most recent command.

For instance, if the player types EAT THE PIE,” the pie object becomes
(temporarily) “the noun.” Likewise, the second noun is the second object
in a two-object command, such as STAB TROLL WITH SWORD. Here, the troll
is the noun and the sword is the second noun. You should always use
“noun” and “second noun” in code (though without quotation marks, of
course) when you’re not sure what object the player will be referring
to. (See [Variables](#Ref_variable) for more.)

</div>

### The Names of Things   {#the-names-of-things-1}

When creating objects, it’s a good idea to add an adjective to the name.
When possible, the adjective should be unique, not a word that can also
be used with other objects. This is not required, but failing to do it
can get you into trouble. Here’s a simple example that shows why:

```
The red potion vial is an open container on the table.

The red potion is in the red potion vial. [Error!]
```

This code won’t compile. The compiler complains, “You wrote \'The red
potion is in the red potion vial\': but this asks to put something
inside itself, like saying \'the bottle is in the bottle\'.” The
compiler gets confused because all of the words that can refer to the
red potion can also apply to the vial. The solution is simple: Just give
the vial and potion their own names:

```
The red vial is an open container on the table.

The healing potion is in the red vial.
```

In a real game, we’d need to write more code than this. For one thing,
the way this has been written, the player could pick up the potion,
which would be silly because the potion is probably be a liquid. Inform
doesn’t know that a thing is a liquid unless you do some extra work. If
you’re curious about liquid handling, you can consult [RB 10.2:
Liquids](../RB_10.html#section_2). (Liquids, ropes, and fire are among
the more awkward concepts to implement in interactive fiction. For now,
though, we’re just talking about giving things distinctive names.)

Here’s a more complicated version of the same problem. Let’s suppose
you’ve created three keys in your game – a rusty key, a silver key, and
a third object called simply the key. Inform will let you do this, as
long as you define the plain old key (not an object called “the plain
old key” but the key with no adjectives) first in your source code.
During the course of the game, the player might be carrying all three of
the keys, and might need to unlock a door using the one that you’ve
called simply “key”. This will cause a bug to appear in your game. The
output will look like this:

> <span class="command">unlock door with key</span> \
> Which key do you mean, the rusty key, the silver key, or the key? \
>  \
> <span class="command">key</span> \
> Which key do you mean, the rusty key, the silver key, or the key?

The question above goes by the fancy term *disambiguation*. The parser
is attempting to figure out what the player’s input means. It comes up
with two or more possible meanings, and has no way to decide which is
correct, because the input is ambiguous – the parser doesn’t know which
key object the player is referring to. The command UNLOCK DOOR WITH KEY
could mean several different things, so the parser needs to ask the
player to provide more information. The parser tries to get rid of the
ambiguity by asking the player to add some detail.

As long as the player wants to use the silver key or the rusty key, this
is not a problem: The parser’s question can be answered SILVER or RUSTY
and the game will proceed as planned. But if the player needs to use the
plain key, the one for which there’s no adjective, the player is stuck:
There’s no way to tell the parser that you mean the plain old key, other
than by going into a different room, entering the commands DROP SILVER
KEY and DROP RUSTY KEY, and then returning to the room with the locked
door. To avoid giving your players headaches, be sure to give each key
its own adjective when naming it.

Inform is very unusual among programming languages, by the way, in
allowing you to name objects using spaces between words. Most
programming languages would require that the various key objects above
be named silver\_key and rusty\_key (using the underscore character),
silverKey and rustyKey, or with some other combination of letters. The
text name (what the player reads while playing the game) would be a
separate piece of data. But in Inform, when you call something the
silver key in your source code, you’re creating both a code name (silver
key) and a name for output text purposes (“silver key”). There are times
when the two types of names need to be separate; you’ll learn how to set
that up in [Phrasing and Punctuation](#Ref_privately-named) in Chapter
9.

### Long Names   {#long-names}

Normally, Inform looks only at the first nine letters in each word. The
rest of the letters are ignored. This is true both for the names of
things in your code and for the words in commands that the player types.
Normally nine letters are plenty. (In the very first text-based games,
only the first five or six letters in the player’s commands were read,
and six letters weren’t really enough.) But as [WI 3.1
Descriptions](../WI_3.html#section_1) points out, if you happen to put a
superhero and a superheroine in the same room, the player will quite
likely get the wrong result from the command KISS SUPERHEROINE.

In fact, the confusion can get deeper than that – unlikely, but
possible. Let’s suppose that for some bizarre reason you’ve created the
following four objects:

```
The player carries a superheroism, a superheroine, a superheroich, and a superheroidiot.
```

Here’s the result when the player tries to take inventory:

> <span class="command">**i**</span> \
> You are carrying: \
> four

Inform has created four indistinguishable objects, because it was only
looking at the first nine letters.

There are two ways to get around this problem, if you ever need to. The
easy way requires compiling to Glulx. If you’re not already compiling
your game to Glulx, go to the Settings page in the Inform IDE and click
the Glulx button. Then add the following line near the top of your
source:

```
Use DICT_WORD_SIZE of 12.
```

Now the player will be able to use both SUPERHERO and SUPERHEROINE in
commands, and Inform will be able to tell the difference. You can use as
large a number as you’d like, but if your game is written in English,
it’s hard to see how you would ever need more than the first 12 letters
of each word.

If you need to compile to the Z-machine standard (possibly because you
want your game to be playable on handheld devices), you won’t be able to
change the value of DICT\_WORD\_SIZE, so you’ll need to resort to a
little trickery. The next example is a stripped-down version of some
code I used in my game “A Flustered Duck.” Some leprechauns are having a
picnic in a meadow, and there’s also a single leprechaun (with whom the
player can converse) wandering around playing a fiddle. The trick is,
we’re going to use words shorter than nine letters, but allow both the
player’s input and the game’s output to use the longer words.

```
After reading a command: 
	let N be text; 
	let N be the player's command; 
	replace the regular expression "leprec" in N with "lpc";
	change the text of the player's command to N.

The Grassy Knoll is a room. "Some leprechauns are having a picnic here. One leprechaun is sauntering around playing a sprightly tune on a fiddle."

Some lpchauns are scenery in the Grassy Knoll. The description is "They're enjoying their picnic." The printed name of the lpchauns is "leprechauns".

The lpchaun is a man in the Grassy Knoll. The description is "He's playing a fiddle." The printed name of the lpchaun is "leprechaun".
```

The first block of code strips a few letters out of the player’s
commands. If the player types X LEPRECHAUN, the game will see the
command as X LPCHAUN. Then we use Inform’s handy printed name property
so that the object whose real name is lpchaun will be displayed as
“leprechaun”, and similarly for the lpchauns.

### Initial Appearance   {#initial-appearance}

When you create a new object and put it in a room, it will be mentioned
right after the room description, but in a very basic way. If we’ve
created a banjo, for instance, the room description will end with a
paragraph that reads, “You can see a banjo here.”

Inform objects have a special property called **initial appearance**. If
an object has an initial appearance, this will be used in the room
description until the object has been picked up by the player.

If Inform sees a quoted sentence just after a new object has been
created, it will know that this is the initial appearance of the object.
We could create our banjo like this:

```
The Meadow is a room. "Wildflowers carpet the meadow."

The old banjo is in the Meadow. "A banjo lies forgotten among the wildflowers." The description is "It's a 1938 Selmer 5-string."
```

The sentence “A banjo lies forgotten among the wildflowers” is the
initial appearance of the banjo. The term “initial appearance” is
actually the name of a **property** that objects can have in Inform.
Properties are a type of data that’s attached to an object. The
description of an object is another of its properties, and the printed
name (shown earlier in the example that involved leprechauns) is yet
another.

When we give the banjo an initial appearance, this is what will happen
when the player enters the Meadow:

> **Meadow** \
> Wildflowers carpet the meadow. \
> A banjo lies forgotten among the wildflowers.

Having the line about the banjo off in a paragraph by itself looks a
little odd, but that’s mainly because the room description of the meadow
is so brief. If the room description were three lines long, having a new
paragraph about the banjo would look perfectly natural.

An initial appearance will be used only until an object is picked up for
the first time by the player character. There may be times when you’d
like an object to be referred to in a non-default way in room
descriptions on an ongoing basis, or possibly in several non-default
ways depending on which room it’s in. The following code does that:

```
Rule for writing a paragraph about the shovel:
  	say "[if the shovel is in the Garage]Your shovel lies in the corner against the wall.[otherwise if the shovel is in the Tool Shed]On a shelf is your handy shovel.[otherwise if the shovel is in the Work Site]Your shovel is stuck in the ground here.[otherwise]You seem to have left the shovel lying here.[end if]".
```

### Adding Vocabulary Words with “Understand”   {#adding-vocabulary-words-with-understand}

When you create an object, such as the paintbrush we created earlier in
this chapter, Inform is smart enough to understand two things at once.
First: you, the author, can refer to the object in your code as a
paintbrush, and the compiler will know what you mean. Second: the player
who is playing your game can also call it a paintbrush, and the parser
will know what the player means.

When you first start learning Inform, these two facts may seem to be
almost the same – the object is a paintbrush, and that’s what it’s
called. What could be complicated about that? But in reality, the name
of an object for internal purposes (that is, when you’re writing code)
is not at all the same thing as the word(s) the player can use to refer
to the object or the words that are printed out by Inform as the story
unfolds for the player. They’re often the same, but they don’t have to
be. In fact, Inform allows you to make them completely different if you
need to. (See the section on “The Names of Things” in Chapter 8 of the
*Handbook*.)

After creating an object, you’ll almost always want to add extra
vocabulary words to it – words that the player can use to refer to it.
With a paintbrush, for instance, the player will quite often want to
call it a brush. But the parser won’t understand that word unless you
tell it to:

```
The paintbrush is in the Tool Shed.
    Understand "brush" as the paintbrush.
```

Once you’ve added the second sentence, the player can use the word
“brush” to refer to the paintbrush – but the author can’t. This is a key
concept: The author can only refer to an object using the actual word or
words that are used in the sentence that creates the object.

When you write a description for a new object, you’ll quite often find
that you’re adding extra adjectives. These should always be added as
vocabulary:

```
The paintbrush is in the Tool Shed. The description is “The bristles of the paintbrush are stiff with dried paint.” Understand "brush", "bristles", "stiff", "dried", and "paint" as the paintbrush.
```

If you also have a can of paint in your game (which wouldn’t be
surprising if you’ve created a paintbrush), the word “paint” will end up
being ambiguous. It will be able to refer either to the brush or to the
paint can (and possibly to the paint *in* the can as well), and also to
the command PAINT. Handling all of the possibilities in a case like this
can get a little tricky. We’re not going to go through the whole
troubleshooting process here, but it’s certainly something to be aware
of when you start creating objects whose names and vocabulary words
overlap.

Inform will attempt to keep track of what you mean when writing the
game, and the parser will try to figure out what the player means when
entering the word PAINT. If the parser can’t figure out what the player
meant, it will ask questions. You can help the parser by writing “does
the player mean” rules (see [WI 17.19 Does the player
mean…](../WI_17.html#section_19)).

#### Conditional Vocabulary   {#conditional-vocabulary}

Most of the objects in a game will likely have the same vocabulary words
from one end of the game to the other. But there are situations in which
you may want to switch certain words on or off. For instance, if the
vase gets broken during the game, the player should be able to refer to
it as BROKEN VASE – but not otherwise.

The simplest way to do this is to refer to properties of the object when
listing the vocabulary words:

```
The porcelain vase is in the Museum Lobby. The vase can be broken or unbroken. Understand "broken" and "shattered" as the vase when the vase is broken.

Instead of attacking the vase:
	now the vase is broken;
	now the printed name of the vase is "broken porcelain vase";
	say "You shatter the vase."
```

Notice that the Instead rule both changes the broken/unbroken property
of the vase and changes the vase’s printed name.

For more complex story situations, you may want to create scenes (as
described in Chapter 8 of the *Handbook*) and make the vocabulary words
that the player is allowed to use depend on whether a scene is
happening:

```
Daytime is a recurring scene. Daytime begins when the sun is part of the sky. Daytime ends when the sun is not part of the sky.

Understand "twittering" and "chirping" as the birds when daytime is happening.
```

For more on giving objects sets of words (like broken and unbroken) as
properties, see the section on “Word Properties” later in this chapter.

### Containers & Supporters   {#containers-supporters}

Every object in your model world (except backdrops and doors, which
operate in a slightly different way) is either in a room, or it’s
off-stage. If an object is off-stage, it’s nowhere, at least at the
moment. But even when something is off-stage, it’s still part of the
game, and could be moved into play later on. (See the section “Moving
Things Around,” below, to learn how to do this.) The question of where
things are located is rather interesting, as we’ll discover in the
section “Testing Where a Thing Is.” Before we dig into that question, we
need to introduce two new kinds: containers and supporters. These were
introduced briefly at the end of Chapter 2, in the section “Room
Descriptions.” Now it’s time to take a closer look.

A container is, as you can probably guess, an object that can contain
other things. That is, the player can put things *in* a container. Most
of the time, if you need a basket or a cupboard in your game, you’d make
the basket or cupboard a container.

A supporter is like a table: it’s an object that you can put things
*on*. Inform understands the difference between a supporter and a
container. If the player tries to put something *in* a table, she’ll be
told, “That can’t contain things.” If she tries to put something *on* a
container, such as a cupboard, she’ll be told, “Putting things on the
cupboard would achieve nothing.”

By default, a supporter is assumed to be a piece of furniture: It’s not
scenery (unless you make it scenery), but it’s fixed in place. If you
want to create a portable supporter, such as a tea tray, you need to
tell Inform that it is not fixed in place:

```
The tea tray is a supporter on the buffet. The tea tray is not fixed in place.
```

If the player happens to be carrying the tea tray at the beginning of
the game, Inform will guess correctly that even though it’s a supporter,
it’s not fixed in place. But if it’s not initially carried, you have to
explicitly say that it’s not fixed in place.

There are ways to create an object (such as a chest of drawers) that the
player can put things either in or on; see the section “Objects that
Have Parts,” later in this chapter. Such an object can behave like a
supporter in response to some player commands, and behave like a
container at other times. For the rest of the discussion in the section
you’re reading now, though, we’re going to assume that containers and
supporters are entirely different. The main thing they have in common is
that the player can put movable things on or in them.

Containers have some special properties that are not available for
supporters. A container can be **openable**. If you create a container
but don’t tell Inform that it’s openable, Inform will assume that it’s
permanently open – that it operates pretty much like a basket. On the
other hand, if you tell Inform that your cupboard is openable, then the
commands OPEN CUPBOARD and CLOSE CUPBOARD will work just the way the
player would expect them to (though the cupboard won’t have an actual
door – you can give it a door, but that’s a more complex coding
challenge; for details, see “Objects that Have Parts,” later in this
chapter).

Your game will automatically keep track of whether each container is
opened or closed. If it’s closed, the player won’t be able to see or
take anything that’s inside. On the other hand, if the container is not
only openable but **transparent**, the player will be able to see what’s
inside even when the container is closed, but won’t be able to take
what’s inside. The transparent property is good for creating things like
bird cages and glass-front sideboards.

A container that is openable can start the game either **open** or
**closed**. Inform understands that “not open” means the same thing as
“closed.” So we could create a basic cupboard like this:

```
The cupboard is a closed openable container in the Kitchen.
```

If a container is openable, it can also be lockable. If it’s lockable,
it can start the game either locked or unlocked. And as [WI 3.13 Locks
and keys](../WI_3.html#section_13) explains, things that are lockable
can be given keys.

In fact, Inform is a little pickier than this: by default, you can only
say that something is lockable if it’s a container or a door. If you
want to create a small gold locket as a piece of jewelry, and give it a
key, one easy way to do it would be to make it a container – after which
you’ll probably want to write an Instead rule to prevent the player from
putting anything at all into it (unless putting a small photograph or a
magic bean into the locket is the solution to a puzzle). This is not
difficult to do:

```
The player carries a small gold locket. The locket is an openable container. The locket is lockable and locked. The tiny gold key unlocks the locket.

The player carries a bowling ball and the tiny gold key.

Instead of inserting something into the small gold locket:
	if the locket is closed:
		say "You'd need to open the locket to do that.";
	otherwise if the player does not carry the noun:
		say "You're not holding [the noun].";
	otherwise:
		say "There's not room for [the noun] in the locket."

Test me with "put ball in locket / unlock locket with key / open locket / put ball in locket".
```

Note the use of “inserting something into” in the code above. One of the
common mistakes authors make is trying to write a rule for “putting
something in” something else. Inform lets the player use the syntax PUT
BOWLING BALL IN LOCKET, but the action that this produces is inserting
it into, not putting it in.

But there’s an easier way. By adding a little more code, we can make the
locket lockable and openable even though it’s not a container. The
reasons why this type of code works the way it does are a bit technical.
What you need to know is that before you make something openable or
lockable (unless it’s a container or a door), you have to tell Inform
that it *can be* openable or lockable. Here’s how:

```
The player carries a locket. The locket can be lockable. The locket is lockable. The locket can be openable. The locket is openable. The locket can be open. The locket can be locked. The locket is not open. The locket is locked.

The player carries the tiny gold key. The tiny gold key unlocks the locket.
```

If you do this, you’ll find that the locket can be opened and closed,
locked and unlocked – but it can’t contain things, because it isn’t a
container. The code above doesn’t include a description of the locket
(which should probably change depending on whether it is open or
closed). Nor does the code tell the player what will be discovered upon
opening the locket, which would presumably be important information.

We were talking, a couple of pages back, about a kitchen cupboard. Let’s
make the cupboard a little fancier:

```
The glass-front cupboard is an openable transparent lockable container in the Kitchen. The cupboard is closed and locked. The brass key unlocks the cupboard.
```

In order to allow the player to UNLOCK THE CUPBOARD DOOR, we might want
to give the cupboard an actual glass door. To do that, see [Objects that
Have Parts](#objects-that-have-parts). Another way would be to make the
word “door” a synonym for the cupboard.

Inform assumes that the cupboard is *permanently* openable, and that it
can be opened or closed during the course of the game. But your code can
change a container to not openable during the course of the game. This
is something you will rarely need to do, but someday you might want to
create an openable lockable container that is closed and locked, and
that has *no* key. If the solution of the puzzle is HIT CUPBOARD WITH
HAMMER, you might create a new action called attacking it with and then
write some code along these lines:

```
Carry out attacking the cupboard with the hammer:
	now the cupboard is open;
	now the cupboard is not openable;
	now the cupboard is unlocked;
	now the cupboard is not lockable;
	say "You smash the cupboard door with the hammer, and it springs open."
```

Once this cupboard has been smashed, it’s no longer lockable and no
longer openable.

Inform has a standard way of describing containers and supporters and
their contents, but we can change this if we need to. To look at what
usually happens (unless we write some new code), let’s create a simple
game that has three containers and a supporter. One of the containers
(the cupboard) and the supporter (the table) are scenery. Another
container, the suitcase, is closed and openable. The final container, a
basket, is not scenery and not openable. That is, the basket is
permanently open. Here’s the code for the game:

```
The Living Room is a room. "Your standard American living room, equipped with a table and a cupboard."

The table is a scenery supporter in the Living Room.

The cupboard is a closed openable scenery container in the Living Room.

The basket is a container in the Living Room.

The suitcase is a closed openable container in the Living Room.

The pear is on the table. The apple is in the cupboard. The plum is in the basket. The carrot is in the suitcase. The player carries a banana. 

Test me with "open suitcase / look / take carrot / look / open cupboard / look / take plum / look / take pear / look"
```

If you haven’t used the TEST ME command, this would be a good time to
try it out. Create a new, empty project, paste the code shown above into
it, and click the Go! button. When the game appears in the right-hand
page, enter the command TEST ME. Inform will run through all of the
commands in the “Test me with” line, above. Here’s the output:

> **Living Room** \
> Your standard American living room, equipped with a table and a \
> cupboard. \
> On the table is a pear. \
> You can also see a basket (in which is a plum) and a suitcase \
> (closed) here. \
>  \
> <span class="command">test me</span> \
> (Testing.) \
>  \
> <span class="command">**open suitcase**</span> \
> You open the suitcase, revealing a carrot. \
>  \
> <span class="command">**look**</span> \
> **Living Room** \
> Your standard American living room, equipped with a table and a \
> cupboard. \
> On the table is a pear. \
> You can also see a basket (in which is a plum) and a suitcase (in \
> which is a carrot) here. \
>  \
> <span class="command">**take carrot**</span> \
> Taken. \
>  \
> <span class="command">**look**</span> \
> **Living Room** \
> Your standard American living room, equipped with a table and a \
> cupboard. \
> On the table is a pear. \
> You can also see a basket (in which is a plum) and a suitcase (empty) \
> here. \
>  \
> <span class="command">**open cupboard**</span> \
> You open the cupboard, revealing an apple. \
>  \
> <span class="command">**look**</span> \
> **Living Room** \
> Your standard American living room, equipped with a table and a \
> cupboard. \
> On the table is a pear. \
> You can also see a basket (in which is a plum) and a suitcase (empty) \
> here. \
>  \
> <span class="command">**take plum**</span> \
> Taken. \
>  \
> <span class="command">**look**</span> \
> **Living Room** \
> Your standard American living room, equipped with a table and a \
> cupboard. \
> On the table is a pear. \
> You can also see a basket (empty) and a suitcase (empty) here. \
>  \
> <span class="command">**take pear**</span> \
> Taken. \
>  \
> <span class="command">**look**</span> \
> **Living Room** \
> Your standard American living room, equipped with a table and a \
> cupboard. \
> You can see a basket (empty) and a suitcase (empty) here.

This output shows several things about how Inform handles containers and
supporters. Sometimes the game will add sentences of its own after the
room description that you wrote; other times, it won’t add anything.
Here are the normal rules (which we can change if we need to):

1.  If a container is scenery, it doesn’t get its own paragraph of
    output after the room description – not even when it’s open and
    something is visible inside. If the player wants to see what’s in a
    scenery container, she has to LOOK IN it or SEARCH it. (These two
    commands lead to the same action.)
2.  If a supporter is scenery (as the table is in this game), it gets a
    separate paragraph after the room description, but only if something
    is on it. When nothing is on it (after we TAKE PEAR in this game)
    the table no longer rates a paragraph of its own. Inform assumes
    that things sitting on supporters are more immediately visible than
    things in open containers. But if nothing is on the scenery
    supporter, Inform assumes that it has already been mentioned in the
    room description, and adds nothing.
3.  If a container is not scenery, Inform will normally add a paragraph
    about it after the room description (assuming it’s in the room – not
    if the player is holding it). If the container is openable and
    closed, Inform will add “(closed)” after mentioning it. If it’s open
    and contains something, Inform will list the contents. If it’s open
    and empty, Inform will say “(empty)”.
{: .num}

#### Stealthy Containers   {#stealthy-containers}

The logic shown above is fine as a basic way of designing a game, but
you may run into situations in which it doesn’t work well. For instance,
you might want it to be less than obvious that a closed openable
container is actually a container at all. Getting rid of the “(closed)”
text would solve that. Here’s how:

```
Rule for printing room description details of a closed container:
	stop.
```

Once the closed container is picked up by the player, however, the
“(closed)” will reappear when the player takes inventory. To prevent
that, we need another few lines:

```
Rule for printing the name of a closed container (called C) while taking inventory:
	say "[printed name of C]";
	omit contents in listing.
```

The initial appearance property can also help get us get specific
printouts for containers, as can the printing a paragraph about
activity. Let’s look at a more complete example. We have a hollow log
(an open container) in which is a gold key. We don’t want to make the
log scenery, because the player needs to be able to pick it up and take
it to the river in order to cross the river.

Our first thought might be to write it this way:

```
The Forest is a room. "Tall old trees stand on all sides."

The hollow log is in the Forest.

The gold key is in the hollow log.
```

If we tell Inform that the key is in the log, we don’t even have to
mention that the log is an open container; Inform will figure that out.
(For that matter, if we say that Steve is wearing a hat, Inform will
figure out that Steve is a person without our needing to say so, because
only people can wear things; and also that the hat is wearable.) But
when we compile this code, we’ll find that the key is in plain sight, so
the puzzle will fall flat. Here’s the output:

> **Forest** \
> Tall old trees stand on all sides. \
> You can see a hollow log (in which is a gold key) here.

One way to get rid of the mention of the key is to create an initial
appearance for the hollow log, like this:

```
The Forest is a room. "Tall old trees stand on all sides."

The hollow log is in the Forest. "A hollow log lies fallen next to the path."

The gold key is in the hollow log.
```

The new sentence, “A hollow log lies fallen next to the path,” is *not*
the description of the log. (We haven’t written a description yet.) It’s
the log’s initial appearance. As explained earlier in this chapter, in
the section “Initial Appearance,” Inform will use the initial appearance
we’ve given to the log instead of writing its own paragraph about the
log. But it will only use the initial appearance until the log has been
picked up. If the player picks up the log and drops it again, Inform
will toss out the initial appearance and go back to its standard way of
mentioning the log, thus revealing the gold key to the player.

A slightly better solution is to give Inform a new rule for writing a
paragraph about the hollow log. Here’s how to do it:

```
Rule for writing a paragraph about the hollow log:
	say "[if the location is the Forest]A hollow log lies fallen next to the path[otherwise]A hollow log is lying here[end if]."
```

When we’ve written a “rule for writing a paragraph about”, Inform will
*always* use this rule when adding the log to a room description rather
than construct its own sentence about the log, so the gold key will
remain hidden until the player actually thinks to search the log. (Of
course, the key might fall out when the player picks up the log. That’s
a more complex situation, which I’ll leave you to work out for yourself.
Hint: Try writing an After rule, and include the phrase “for the first
time”.)

The downside of writing a new “rule for writing a paragraph about” is
that if we *do* want the contents of the hollow log to be mentioned at
some point in the game, we’ll have to write a more complex rule that
will tell Inform when we do or don’t want this extra output, and how the
extra text should be put together.

We’re not quite out of the woods yet, though (so to speak). Remember, we
didn’t make our hollow log scenery, because we want the player to be
able to pick it up and move it to another location. While carrying it,
the player might think to take inventory. Here’s the result:

> <span class="command">i</span> \
> You are carrying: \
> a hollow log \
> a gold key

Oops – the gold key has been revealed again. This happens because the
contents of open containers and supporters that the player is carrying
are listed when an inventory list is constructed. To prevent this, we
need to add another new rule. This is like the one mentioned a couple of
pages back, but here we’ll apply it specifically to the hollow log
rather than to all closed containers (because, of course, the hollow log
isn’t closed; it’s just behaving in a mysterious way because it’s a
puzzle):

```
Rule for printing the name of the hollow log while taking inventory:
	say "hollow log";
	omit contents in listing.
```

Sometimes we may want an open container to list its contents. We just
don’t want Inform to print out an annoying reminder that the container
is closed or empty every time it includes the container in a list. [WI
18.10 Printing the name of something](../WI_18.html#section_10) shows
how to handle this. Adapting the code there slightly, we’ll create a
pillbox. While we’re at it, we’ll restrict the pillbox so that it can
only contain pills. This type of restriction is often useful with small
containers. (Another way to prevent the player from putting a bowling
ball into the pillbox would be to use the extension called [Bulk Limiter
by Eric Eve][1].)

```
A pill is a kind of thing. The blue pill is a pill. The red pill is a pill. The yellow pill is a pill.

The player carries a paper clip and a pillbox. The pillbox is a closed openable container. The description is "The pillbox is small and white.” Understand "box", "white", and "pill box" as the pillbox. The blue pill, the red pill, and the yellow pill are in the pillbox.

Rule for printing the name of the pillbox while not inserting or removing or opening: 
	if the pillbox is open:
		if something is in the pillbox:
			say "pillbox (containing [a list of things in the pillbox])";
		otherwise:
			say "empty pillbox";
	otherwise:
		say "pillbox";
	omit contents in listing.

Instead of inserting something into the pillbox:
	if the pillbox is not open:
		say "You can't put anything into the box until you open it.";
	otherwise if the noun is not a pill:
		say "That won't fit into the pillbox.";
	otherwise:
		continue the action.
```

Notice the line above that says “(containing \[a list of things in the
pillbox\])”. This is a handy bit of syntax; Inform can construct lists
during the game if we include code that explains, in a general way, what
should be included in the list. Incidentally, this is one of the
situations where the compiler will notice the difference between “a” and
“the”. If we say “\[a list of things…\]”, the list will be printed out
in the game as “a blue pill, a red pill, and a yellow pill”. But if we
say “\[the list of things…\]”, the list will appear as “the blue pill,
the red pill, and the yellow pill”.

Earlier, when we were writing code for the hollow log, we were trying to
prevent it from revealing its contents. But sometimes we have to help
Inform go the other direction. The contents of open containers will be
listed when the container is mentioned in a list that Inform prints out
– but the contents won’t be mentioned when an open container is simply
EXAMINEd. If an open container is examined, the game won’t bother to
list what’s inside. The player needs to LOOK IN or SEARCH the container
to learn what’s in it. With an ordinary container like a suitcase,
forcing the player to take that extra step is a bit silly. So here’s a
suitcase that will list its contents (and its state) when examined:

```
The suitcase is in the Train Station. The suitcase is a closed openable container. The description is "A vintage item of brown leather luggage.[if open] In the suitcase you can see [a list of things inside the suitcase].[otherwise] It's closed.[end if]".
```

That works pretty well, as long as there’s something in the suitcase.
But if the suitcase is empty, we get the following output:

> <span class="command">x suitcase</span> \
> A vintage item of brown leather luggage. In the suitcase you can see \
> nothing.

That “you can see nothing” is a bit crude. I’d rather have the game say
“The suitcase seems to be empty.” The difficulty is this: Inform won’t
let us embed one if-test inside of another in a double-quoted string.
We’re not allowed to do this:

```
The description is "A vintage item of brown leather luggage.[if there is something in the suitcase][if open] In the suitcase you can see [a list of things inside the suitcase].[otherwise] It's closed.[end if][otherwise] It seems to be empty.[end if]". [Error!]
```

The error report from the compiler is helpful. It says this: “a second
\'\[if …\]\' text substitution occurs inside an existing one, which
makes this text too complicated. While a single text can contain more
than one \'\[if …\]\', this can only happen if the old if is finished
with an \'\[end if\]\' or the new one is written \'\[otherwise if\]\'.
If you need more complicated variety than this allows, the best approach
is to define a new text substitution of your own (\'To say fiddly
details: …\') and then use it in this text by including the \'\[fiddly
details\]\'.” This tells us exactly how to write code that will do what
we want. Here’s one way to do it, using an \[otherwise if\]
construction:

```
The description is "A vintage item of brown leather luggage.[if there is something in the suitcase and the suitcase is open] In the suitcase you can see [a list of things inside the suitcase].[otherwise if open] It seems to be empty.[otherwise] It's closed.[end if]".
```

And here’s another way, using Inform’s handy To Say phrase:

```
The suitcase is a closed openable container. The description is "A vintage item of brown leather luggage. [suitcase-desc details]."

To say suitcase-desc details:
	if the suitcase is open:
		if the number of entries in the list of things inside the suitcase is at least 1:
			say "In the suitcase you can see [a list of things inside the suitcase]";
		otherwise:
			say "It seems to be empty";
	otherwise:
		say "It's closed".
```

Pay close attention to the way the periods at the ends of the sentences
are handled. We want the game to print out exactly one blank line after
the description of the suitcase, so we put the period just before the
closing quote in the *main* description, not in the sentences in the
suitcase-desc details. Notice also the space before “ \[suitcase-desc
details\]”. This ensures that there will be a space between sentences,
no matter which details are printed out.

The same thing happens if the player examines a table – Inform won’t
bother to mention what’s on the table unless we tell it we want that
information to be included in the description. With a table, though,
printing the line “It seems to be empty” in response to an EXAMINE
action would be a bit silly, so the code can be simpler:

```
The billiard table is a scenery supporter in the Billiard Room. The description is "The table is big and green[if there is something on the table]. On the table you can see [a list of things on the table][end if]."
```

Here’s another way to accomplish the same thing. This one moves the
question of whether there’s something on the table into a different
block of code.

```
The billiard table is a scenery supporter in the Billiard Room. The description is "The table is big and green[list-table-stuff]."

To say list-table-stuff:
	let L be the list of things on the billiard table;
	if the number of entries in L > 0:
		say ". On the table you can see [a list of things on the billiard table]".
```

Which of these forms you use is purely a matter of taste. I like the
second one because it makes the logic easier to see at a glance.

#### Sneaky Supporters   {#sneaky-supporters}

There may be times when you’d like to force the player to examine a
supporter before the game reveals what’s on it. By default, Inform
*will* list what’s on a scenery supporter in a room description. If you
don’t like this effect, you can override it globally (that is,
everywhere in your game) like this:

```
The describe what's on scenery supporters in room descriptions rule is not listed in any rulebook.
```

When you add this line, the player will have to examine scenery
supporters in order to see what’s on them – and you’ll have to use the
code given a few paragraphs back to insure that the things on all of
your supporters will appear in response to an EXAMINE command. It’s a
bit rude to expect the player to understand that you’ve set up a little
extra mystery, unless there’s a purpose for the mystery. Usually, less
drastic measures would be preferable.

If you want to force the player to examine the billiard table to notice
the cue ball that’s lying on it, but you want that effect to apply
*only* to the billiard table, not to any other supporter in the game,
the way to do it is, first, *not* to make the table scenery, and second,
to add a “rule for writing a paragraph about.” Here’s an example that
does this. Notice that we’re not mentioning the billiard table in the
room description of the Billiard Room, because the table is not scenery,
so Inform will add a paragraph about it after the room description,
using the new rule we’ve added:

```
The Billiard Room is a room. "Comfortable-looking leather chairs stand against the oak-paneled walls of this room. Overhead, a single hooded light fixture shines down."

The billiard table is a supporter in the Billiard Room. The description is "The billiard table is big and green."

The white ball and the cue chalk are on the table. The indefinite article of the cue chalk is "a piece of". Understand “piece” as the cue chalk.

Rule for writing a paragraph about the billiard table:
	say "A handsomely appointed billiard table dominates the center of the room."
```

This produces the desired result: The player has to X TABLE to notice
the ball and the chalk.

### Looking Under & Looking Behind   {#looking-under-looking-behind}

Experienced IF players know that authors like to hide things under other
things – under a bed, for example. When a player enters a room and sees
a bed, he’s bound to try LOOK UNDER BED before very long. Inform’s
default response is, “You find nothing of interest.” Creating a
non-default response is easy:

```
Instead of looking under the bed:
	say "Nothing but dust bunnies."
```

In [RB 6.6](../RB_6.html#section_6), you’ll find several ideas about how
to hide things under other things. If we want to, we can have the player
“find” something by moving it from off-stage into the room, or directly
into the player’s inventory, like this:

```
The odd sock is a thing. The odd sock can be found. The odd sock is not found.

Instead of looking under the bed:
	if the odd sock is found:
		say "There's nothing else of interest under there, just a few dust bunnies.";
	otherwise:
		now the odd sock is found;
		now the player carries the odd sock;
		say "Under the bed you find an odd sock, which you retrieve."
```

This works nicely, up to a point. For your first game, it may be all you
want or need. But there are at least two potential problems lurking here
(leaving aside the possibility that the player will try to pick up the
dust bunnies and learn that she can’t see any such thing). First, it
won’t be possible to put anything (including the sock) under the bed:

> <span class="command">put sock under bed</span> \
> I didn\'t understand that sentence.

And second, if your game limits the number of items the player can carry
at once, giving the sock to the player automatically (as shown above)
may cause the player to be carrying more than the allowed number of
things. I’ve found that this can trip up Inform’s process of
automatically inserting excess items into the player’s holdall (a handy
bag for carrying excess inventory).

This is a good reason for moving the sock into the room rather than
adding it directly to the player’s inventory. But then the player has to
TAKE SOCK as an extra command, which is a bit annoying. If the player
finds the sock, shouldn’t picking it up happen at the same time?

Another way to hide the odd sock under the bed is to include [Underside
by Eric Eve][2]. This is a handy extension. Once this extension has been
included in your game, hiding the sock under the bed is easier:

```
The double bed is a supporter in the Bedroom. The double bed is fixed in place. An underside called under#bed is part of the double bed.

The odd sock is in under#bed.
```

The name “under#bed” is not special; it’s just a good idea to use a name
that the player is not likely to type.

When an object is in an underside, it won’t be mentioned in a room
description, and it won’t be included in the object list if the player
tries to TAKE ALL.

There is no extension for hiding things behind other things. Most often,
if you want to do this, you’d be hiding something behind a picture on
the wall, or behind a couch, and the way to let the player find it would
be with the command TAKE PICTURE or MOVE COUCH. Inform does not include
looking behind as an action, though. Here’s how to set that up:

```
Looking behind is an action applying to one thing and requiring light. Understand "look behind [something]" as looking behind.

Check looking behind:
	say "You find nothing interesting behind [the noun]."

Instead of looking behind the couch:
	say "It's jammed up against the wall. In order to see what's behind it, if anything, you'll need to pull it out from the wall."
```

Pulling something away from the wall would require another action, as
well as a way to test the position of the couch within the room. Is it
against the wall, or has it been moved? Let’s add that possibility:

```
The couch is in the Living Room. The couch can be moved or not moved. The couch is not moved. The description is "An overstuffed couch stands [if not moved]against the wall[otherwise]in the middle of the room[end if]."
Instead of pushing the couch:
	try pulling the couch.
Instead of pulling the couch:
	if the couch is moved:
		say "It's already out in the middle of the room.";
	otherwise:
		now the couch is moved;
		move the odd sock to the Living Room;
		say "As you wrestle the couch out into the middle of the room, you find an odd sock behind it."
```

Allowing the player to push the couch back against the wall would be a
bit more complicated. For one thing, you’d have to make sure that the
odd sock wouldn’t keep popping back into the room each time the couch
was moved.

A simpler solution might be to implement the LOOK BEHIND action and then
simply drag the hidden object into the game from offstage when the
player uses the command:

```
The Library is a room. "A beautiful tapestry hangs from the wall here."

A beautiful tapestry is scenery in the Library. "Sir Lancelot is depicted in vivid DayGlo stitchery. He seems to be riding on a sheep."

The rusty dagger is a thing. The description is "Though mottled with rust, it looks quite sharp." The dagger can be discovered or undiscovered. The dagger is undiscovered.

Looking behind is an action applying to one visible thing and requiring light. Understand "look behind [something]", "peek behind [something]", and "search behind [something]" as looking behind.

Check looking behind:
	say "There's nothing of any interest behind [the noun]."

Instead of looking behind the tapestry:
	if the dagger is undiscovered:
		now the dagger is in the Library;
		now the dagger is discovered;
		say "As you disturb the tapestry, a rusty dagger falls out from behind it and lands on the floor.";
	otherwise:
		say "You find nothing else of interest behind the beautiful tapestry."
```

If you do it this way, you might want to add the following, as a
courtesy to the player who tries MOVE TAPESTRY or SHAKE TAPESTRY:

```
Instead of pushing the tapestry:
	try looking behind the tapestry.

Shaking is an action applying to one visible thing and requiring light. Understand "shake [something]" as shaking.

Check shaking:
	say "Agitating [the noun] has no visible effect."

Instead of shaking the tapestry:
	if the dagger is undiscovered:
		try looking behind the tapestry;
	otherwise:
		say "A little dust billows out."
```

This is the first place in the *Handbook* where we’ve added new actions
(looking behind and shaking). In Chapter 4 you’ll learn much more about
how to do this.

### Take All   {#take-all}

Since the TAKE ALL command came up in the section on “Looking Under &
Looking Behind,” we may as well take a quick look at how to deal with
it. Experienced IF players have a tendency to type TAKE ALL whenever
they enter a new room, just to see what’s lying around that isn’t nailed
down. This is a useful command, and many players feel it’s their right
to be able to use it. If you disable it entirely, some players may not
be happy with your game. Earlier versions of Inform tried to let the
player take even scenery objects (after which the player would learn
that the scenery objects were not portable) and people (leading to a
report that the person wouldn’t care for that). This was all rather
silly. In the current version of Inform (and most likely in the future
as well), TAKE ALL does not include people or scenery. This is described
in [WI 18.36 Deciding whether all includes](../WI_18.html#section_36).

We might decide to let “all” include a particular scenery item, perhaps
because the player’s attempt to take it will reveal something
interesting. Unfortunately, WI 18.36 fails to provide a correct
explanation of how to re-include something in ALL. Here’s the correct
way to do it:

```
The billiard table is scenery in the Recreation Room. 

Instead of taking the billiard table:
	say "It's much too heavy for you to pick up, but when you try to lift it, it rocks slightly, as if the floor beneath it is uneven."

Rule for deciding whether all includes the billiard table while taking or taking off or removing: it does.
```

We have to include the list of actions (taking or taking off or
removing) because the Inform compiler assembles its lists of the rules
in your game in a particular way (as discussed in the next chapter).
More specific rules are listed before rules that are more general (less
specific). The library’s rule for TAKE ALL lists those actions, so if we
fail to mention them in our rule, our rule will be placed *after* the
standard “rule for deciding whether all includes scenery”. If our
customized rule is placed after the standard rule rule, our rule will
never be used.

### **Enterable Containers & Supporters**   {#enterable-containers-supporters}

Some containers and supporters might be big enough that the player could
reasonably enter them – a chair or bed, for instance. Here is a simple
example that includes both:

```
The Bedroom is a room. "Your basic bedroom. It's equipped with a bed and a chair."

The bed is an enterable scenery supporter in the Bedroom. The chair is an open enterable scenery container in the Bedroom.
```

The player will get able to GET IN BED or SIT ON BED, but not LIE IN BED
or LIE DOWN IN BED, because the action “lie in” has not been defined. If
you aren’t sure how to make a new action, turn to Chapter 4 of the
*Handbook,* “Actions.” The standard command used by the player to get
out of an enterable container is STAND (or STAND UP, or EXIT).
Annoyingly, GET OUT OF BED is not recognized by the parser. In order to
handle this command, we need to write a little extra code:

```
Getting out of is an action applying to one thing.
Understand "get out of [something]" as getting out of.

Carry out getting out of something:
	try exiting instead.
```

When an openable container is enterable, the player will be allowed to
close it from the inside. Inform understands that the inside of a closed
container is dark, so if the player enters the container and then closes
it, the player will be in darkness – unless carrying a light source, of
course.

```
The refrigerator is an openable enterable container in the Kitchen.
The description is "An old white General Electric fridge."
Understand "fridge" as the refrigerator.
The refrigerator is open.
```

By default, the player will be allowed to pick up things that are in the
room (that is, on the floor) even when in or on an enterable container
or supporter. This is not too realistic, so you might want to prevent
it. I’m a little nervous about the syntax of the next bit of code,
because at any given moment either C or S will be nothing … but it seems
to work:

```
Before taking something:
	if the player is enclosed by an enterable container (called C) or the player is enclosed by an enterable supporter (called S):
		if the noun is not enclosed by C and the noun is not enclosed by S:
			say "You can't reach [the noun] from here." instead.
```

The syntax shown above, in which we use the phrases “(called C)” and
“(called S)” to create temporary local values for things so that we can
test them, is one that you’ll use a lot in writing if-tests in Inform.

If the player is on an enterable supporter or in an enterable container,
trying to go somewhere will cause the parser to print out the message
“You would have to get off \[the supporter\] first.” This is realistic,
but a bit annoying, since the player knew what she wanted to do. Here’s
an easy way to fix it, suggested by Michael Callaghan:

```
Instead of going when the player is on a supporter (called S):
	say "(First getting off the [printed name of S])[command clarification break]";
	surreptitiously move the player to the holder of S;
	continue the action.

Instead of going when the player is in a container (called C):
	say "(First getting out of the [printed name of C])[command clarification break]";
	surreptitiously move the player to the holder of C;
	continue the action.
```

### Moving Things Around   {#moving-things-around}

You can expect that during the game, the player will pick things up,
carry them around, and drop them. But sometimes you need to move them
yourself, in your own code. For instance, if the player rubs the magic
lamp, you would probably want to move the genie into the room. The
keyword for doing this is “now”:

```
Instead of rubbing the lamp:
	if the genie is off-stage:
		now the genie is in the location;
		say "Shazam! A genie appears!";
	otherwise:
		say "You make a small squeaking noise by rubbing the lamp."
```

In this case, “the location” refers to the room where the player is. If
you need to move an object to a container or supporter, it’s usually
easiest to refer to the container or supporter by name:

```
now the knockwurst is on the plate;
```

But sometimes you may not know exactly where the object should show up.
That can happen, for instance, if you’re transforming an old shoe into a
jewelled crown. In this case the shoe could be almost anywhere, so you
need to figure out where it is, store that data, and then use the data
to move the jewelled crown onstage:

```
Instead of the player rubbing the lamp:
	if the holder of the old shoe is not nothing:
		let H be the holder of the old shoe;
		move the jewelled crown to H;
		remove the old shoe from play;
		say "You rub the old lamp. Squeak, squeak[if the player is in the location of the jewelled crown]. The old shoe turns into a jewelled crown![else].";
	else:
		say "You rub the old lamp. Squeak, squeak."
```

As the code above shows, you can’t move something off-stage by saying
“now the X is off-stage”. The way to do it is to say “remove the X from
play”. This code also does a little testing to make sure that the old
shoe hasn’t already been moved off-stage. If we didn’t test that, then
rubbing the lamp a second time would produce a run-time error, because
the game would have tried to move the jewelled crown to nothing. As the
Inform 6 *Designer’s Manual* emphasizes, nothing is not a thing. That’s
why we have to use a special phrase (“remove the old shoe from play”) to
put the shoe nowhere.

This code also suggests a way of getting the proper vertical spacing in
the output. Notice the way the punctuation and conditional clauses
(“\[if the player\]”) are organized. Doing it a different way will
produce an ugly, non-standard output.

For an example of how to move a bunch of indistinguishable objects at
once using a loop, see the [dollar bill example](#Ref_dollar_bill).

I once had a beginning student try to add an item to the player’s
inventory (for a discussion of inventory, see below) by saying exactly
that:

```
add the sword to the player's inventory. [Error!]
```

You might think that would work, but it won’t, first because there is no
container in the model world called “inventory” and second because “add”
refers to an arithmetic operation, not to moving an object around in the
world. The way to give the sword to the player as an item being carried
is this:

```
now the player carries the sword.
```

### Inventory   {#inventory}

When the player types INVENTORY, INV, or simply I, Inform will print out
a list of what the player is carrying or wearing. This list can be
formatted in various ways – as a column, as a sentence, and so on. For
details on how to do this, see [RB 6.7:
Inventory](../RB_6.html#section_7), especially [Example 177: Equipment
List](../examples/equipment_list.html).

If you’re writing a game that tries to be realistic, allowing the player
to carry 20 or 30 things at once is a bit silly (unless the player
character is an alien with 20 or 30 hands). Some game authors prefer to
limit the number of items the player can carry at once. As explained in
[WI 3.19: Carrying capacity](../WI_3.html#section_19), we can easily set
this up by saying:

```
The carrying capacity of the player is 5.
```

Players don’t like having a limited carrying capacity, because it’s a
huge hassle to have the game keep telling them, “You’re carrying too
many things already” when they try to pick up something new. The
solution is to put a **holdall**<span id="Ref_holdall" class="anchor" />
container somewhere in the game – preferably in a place where the player
will find it early in the game. The holdall could be a shopping bag, a
backpack, a burlap sack, or whatever fits with your story. Creating a
holdall is easy:

```
The backpack is an open container in the Barn. The backpack is a
player’s holdall.
```

When this container is added, here’s what happens as the player tries to
load down with more objects than the carrying capacity. In this example,
the carrying capacity of the player is 5. The player is already holding
the backpack and the flaming torch.

> You can see a banana, a peach, a kumquat, a pear, an apple, an orange \
> and a bowling ball here. \
>  \
> <span class="command">take all</span> \
> banana: Taken. \
> peach: Taken. \
> kumquat: Taken. \
> pear: (putting the banana into the backpack to make room) \
> Taken. \
> apple: (putting the peach into the backpack to make room) \
> Taken. \
> orange: (putting the kumquat into the backpack to make room) \
> Taken. \
> bowling ball: (putting the pear into the backpack to make room) \
> Taken. \
>  \
> <span class="command">i</span> \
> You are carrying: \
> a bowling ball \
> an orange \
> an apple \
> a flaming torch (providing light) \
> a backpack (open) \
> a pear \
> a kumquat \
> a peach \
> a banana

If the player is carrying the holdall, when the player tries to pick up
too many things at once, Inform will shuffle the excess items into the
holdall automatically, like this:

[Considerate Holdall by Jon Ingold][3] is an extension that improves on
Inform’s basic concept of a holdall. At present (February 2015) it’s not
compatible with 6L38, but editing it turns out to be not a huge problem.
(See Appendix B.) One useful thing that this extension adds is the idea
that the author can insist that certain things ought not to be shuffled
into the holdall at any time. If the player is carrying, say, a small
rodent or a plate of cookies, stashing them in the holdall would
probably be a bad idea. Even without this extension, Inform will
understand that something providing light (such as a flaming torch)
shouldn’t be deposited in the holdall – but it will have no hesitation
about tossing the rodent in with the plate of cookies.

<div class="addendum">
<div class="add-header">
Addendum
</div>
<div class="add-body">
Considerate Holdall remains unavailable for 9.3/6M62.
</div>
</div>

If you want to make your game more realistic, you may want to think not
just about the sheer number of items the player may want to pick up, but
about their bulk. The extension called Bulk Limiter by Eric Eve allows
you to assign a bulk to any object and a bulk capacity to any container.
This extension is handy for a couple of reasons. With a little care, you
can prevent silly things like having the player put a chair in his
pocket. And if there are numerous bulky objects around (say, a chair, a
string bass, and a shipping trunk), you can easily set the game up so
that the player will only be able to carry one of them at a time. Your
code might look something like this:

```
The bulk capacity of the player is 65.
The bulk of the chair is 45.
The bulk of the string bass is 50.
The bulk of the shipping trunk is 40.
```

Bulk Limiter is not a perfect solution to all problems of this sort. It
doesn’t give us any tools with which to handle long, thin objects that
might not fit into a container. Also, if the player is prevented from
picking up something bulky while carrying several things that are small,
Bulk Limiter will just refuse the action; it won’t shuffle the small
things into a holdall automatically.

<div class="sidebar" id="things-to-think-about" markdown="1">
#### Things to Think About

In the simplest interactive fiction games, every portable thing in the
game is useful for solving one puzzle. After the player has figured out
that he can use the bent hairpin to unlock the jewel box, he can safely
discard the hairpin, because it won’t be needed again. Your game will be
more interesting for players if you add variety to this scheme.

* Two or three of the things you create might have multiple uses.
* Two or three of your puzzles might have two solutions using different
  things.
* One or two objects might be *red herrings.* They might not be good for
  anything at all.
* One object or obstacle that appears to be a puzzle might also be a red
  herring. It have no solution at all.

</div>

### Testing Where a Thing Is   {#testing-where-a-thing-is}

In writing a game, it’s often very useful to be able to test where
something is. If the time bomb is in the suitcase, for instance, and the
player is carrying the suitcase or just in the room with the suitcase,
we might want to print out “You hear a faint ticking noise” once every
few turns.

Inform has several words for describing and testing where things are.
It’s important to use the right word, because if you use the wrong one,
your test may fail, causing a bug in your game. These words are ways of
describing [relations](#relations). Relations (see [ WI 13.3: What are
relations?](../WI_13.html#section_3)) are an important and versatile
concept in advanced Inform programming. The relations that relate to
where things are located are the containment, support, incorporation,
carrying, wearing, and possession relations.

Internally, your game has a *containment hierarchy*. This is a fancy way
of saying that Inform knows when object A is inside of or on object B,
while object B is inside of or on object C, while object C is … and so
on. The relationships between objects in the hierarchy will be one or
another of these relations. For instance, if object A is inside object
B, they are related by the containment relation.

A room is always at the top of the hierarchy: it’s not possible for one
room to be inside another room – though we can fake this easily by
creating a new room that’s inside from another room. In this case,
Inform understands that “inside” is just another direction, like north
or down. This fact is mentioned in [WI 3.2: Rooms and the
map](../WI_3.html#section_2).

If the aspirin tablet is in the pill box, the pill box is in the
suitcase, the leather suitcase on the table, and the old oak table in
the Dining Room, the containment hierarchy would look like this:

```
Dining Room
	old oak table
		leather suitcase
			pill box
				aspirin tablet
```

The words “in” and “on” mean just what you think they should – and they
refer only to things that are *directly* in a container (or room) or on
a supporter. In the hierarchy shown above, the table is in the Dining
Room, but the leather suitcase is *not* in the Dining Room. Likewise,
the suitcase is on the table, but the pill box is *not* on the table.
Because Inform distinguishes “in” from “on,” the table is not “on” the
Dining Room, and the suitcase is not “in” the table.

We can test whether the player (or another character) carries an item.
Like on and in, “carries” only refers to things that the player carries
directly. If the player carries the pill box, and the aspirin tablet is
in the pill box, the result of the test “if the player carries the
aspirin tablet” will be false.

Inform’s most general term for testing where a thing is is “enclosed
by”. In the example above, the aspirin tablet is enclosed by
*everything* above it in the containment hierarchy – the pill box, the
leather suitcase, the old oak table, and the Dining room.

We can reverse these terms if we like. We can say, “if the Dining Room
encloses the pill box”. This will be true if “if the pill box is
enclosed by the Dining Room” is true.

The **location** of a thing is always the room, as [WI 3.25: the
location of something](../WI_3.html#section_25)) points out. In the
diagram above, the location of every object (except the Dining Room
itself) is the Dining Room.

We can test whether two objects are sitting next to one another – in the
same container, on the same supporter, carried by the same person, or in
the same room – using the general-purpose term “holder”:

```
if the holder of the pear is the holder of the banana:
```

This condition will be true if they’re both carried by the player, or
both in the same basket, or both on the floor of the room. But if the
player is holding the basket and the pear, while the banana is in the
basket, it will be false.

### Things Can Have Properties   {#things-can-have-properties}

Often, an object can stay the same from the beginning of the game to the
end. If the player finds a rock, for instance, that can be used to
hammer a nail, probably not too much will happen to the rock during the
course of the game. But it sometimes happens that we want to create an
object whose state can change during the course of the game because of
the player’s action. To keep track of what state the object is in, we
need to give it a *property.* “Property” is simply computer programming
jargon for an attribute or characteristic. To put it another way, the
properties of an object are variables that are stored within the object
– variables that may change depending on what the player does with or to
the object.

Properties can be of two types. Some of them are numbers, while others
are words or groups of words. They’re similar in some ways, but let’s
look at them one at a time.

#### Number Properties   {#number-properties}

Attaching a named number to an object (making it a property of the
object) is very simple. To show how it works, we’ll create a lamp that
will run out of fuel after a certain number of turns:

```
The player carries a lamp. The lamp is lit. The lamp has a number called fuel-remaining. The fuel-remaining of the lamp is 50.

Every turn:
	if the fuel-remaining of the lamp is greater than 0:
		decrease the fuel-remaining of the lamp by 1;
		if the fuel-remaining of the lamp is 0:
			now the lamp is not lit;
			if the lamp is enclosed by the location:
				say "The lamp flickers and then goes out."
```

Number properties always have names – in this case, “fuel-remaining.” We
can manipulate them however we like. If this is an oil lamp, for
instance, the player might be able to refill it from an oil can. Here’s
a somewhat oversimplified way to do exactly that:

```
The oil can is here. The oil can can be full or empty. The oil can is full.

Refilling is an action applying to one thing. Understand "fill [something]" and "refill [something]" as refilling.

Check refilling:
	say "[The noun] can't be refilled." instead.

Instead of refilling the lamp:
	if the oil can is enclosed by the location:
		if the oil can is full:
			now the oil can is empty;
			increase the fuel-remaining of the lamp by 50;
			say "You drain the oil can into the lamp[run paragraph on]";
			if the lamp is not lit:
				now the lamp is lit;
				say ", and quite magically the lamp's mantle begins glowing brightly again[run paragraph on]";
			say ".";
		otherwise:
			say "The oil can appears to be empty.";
	otherwise:
		say "You have nothing to fill the lamp with."
```

This code is oversimplified in several ways. For one thing, I’ve ignored
the fact that the player would need a lighted match in order to re-light
an oil lamp after it had burned out. Also, we would expect that the
player would have to be holding the oil can in order to refill the lamp.
The main thing this example is designed to show is the properties
fuel-remaining (of the lamp) and full or empty (of the oil can).

#### Word Properties   {#word-properties}

The easiest way to add word properties to an object is by simply listing
the words. In this case, what we have is an anonymous (nameless)
property. For instance:

```
The player carries a potato. The potato can be cold, warm, or
hot.
```

Presumably the player will be able to do something during the game that
will change the temperature of the potato. It’s good practice always to
tell Inform what condition you want the object to be in at the start of
the game. This removes any possible ambiguity, and makes your code
easier to read:

```
The player carries a potato. The potato can be cold, warm, or hot.
The potato is cold.
```

If you don’t tell Inform which of the conditions you want the object to
start out in, Inform will make an assumption – but its assumption may
not be what you intended. Just to make our lives more interesting, if
you give the potato’s anonymous property only two possible values
(perhaps cold and hot) and fail to tell Inform what state the potato
starts out in, the compiler will put the potato in the *second* of the
two states. But if you give a list of three possible states, Inform will
initialize the potato object in the *first* of the possible states.

The method you use to change the state of an object will, of course,
depend on the nature of the object and also on the type of puzzle you’re
implementing. Here’s a simple example:

```
The blazing fireplace is an open scenery container in the Library.

After inserting the potato into the blazing fireplace:
	now the potato is hot;
	say "You drop the potato into the blazing fireplace, and in a few moments the potato is glowing cherry red and smoldering cheerfully.";
	rule succeeds.

Instead of taking the potato when the potato is hot:
	say "You'd burn your fingers."
```

But letting the player do something that will make the potato hot is
only the first step in implementing the puzzle. If the player should
happen to refer to the object as a hot potato, the parser will report,
“You can’t see any such thing.” So we need to instruct the parser about
the vocabulary. Let’s omit, for now, the option of a warm potato, and
create one that can be either cold or hot:

```
The potato can be cold or hot. The potato is cold. Understand "hot"
as the potato when the potato is hot. The description of the potato is
"It's brown and a bit lumpy[if hot]. It's also glowing with heat[end
if]."
```

If there are several things in the game that might end up being too hot
to pick up because they’ve been put in the fireplace, we might want to
write a more general rule, along these lines:

```
Instead of taking something when the noun is hot:
	say "You'd burn your fingers." [Error!]
```

Unfortunately, this doesn’t work as expected. For some reason, Inform
will assume that every object has the second value of the anonymous
two-state property. Because we said “The potato can be cold or hot,” the
parser will assume that *everything* is hot. We could get around this by
saying, “The potato can be hot or cold,” but here’s a safer way to do
it:

```
A thing can be hot or cold. A thing is usually cold.
```

Now all of the objects in your game will be explicitly cold, so the
general-purpose Instead rule above will work with the potato, the poker,
the gold doubloon, or anything else that you let the player put in the
blazing fireplace.

But let’s suppose that you want some things to have a variable
temperature, while other things don’t need this property. So you decide
to be clever. You create temperature as a kind of value, like this:

```
Temperature is a kind of value. The temperatures are cold, warm, and hot.

The Library is a room. A toad is in the Library. The blazing fireplace is an open scenery container in the Library.

The player carries a potato. The potato has a temperature. Understand "hot" as the potato when the potato is hot. The description of the potato is "It's brown and a bit lumpy[if hot]. It's also glowing with heat[end if]."

After inserting the potato into the blazing fireplace:
	now the potato is hot;
	say "You drop the potato into the blazing fireplace, and in a few moments the potato is glowing cherry red and smoldering cheerfully.";
	rule succeeds.

Instead of taking something when the noun is hot:
	say "You'd burn your fingers." [Error!]
```

If you try this miniature game, it will compile, but when you test it
with the command TAKE TOAD, you’ll get a run-time error:

> <span class="command">take toad</span> \
> \[\*\* Programming error: tried to read (something) \*\*\] \
> Taken.

What has happened, in this case, is that the toad doesn’t have a
temperature property, so trying to test whether it’s hot (using the
Instead rule) can’t possibly work. You might think to try dodging the
problem like this:

```
Instead of taking something:
	if the noun provides the temperature property:
		if the noun is hot:
			say "You'd burn your fingers.";
		otherwise:
			continue the action;
	otherwise:
		continue the action.
```

This looks perfectly sensible – but it won’t compile. Why? If you look
back at the code given a little earlier, you’ll see that temperature
isn’t a property. It’s a kind of value. To you and me, the difference
between the two ideas may appear trivial, but Inform is fussy about
these sorts of things. Fortunately, there’s a solution, which was
suggested by Victor Gijsbers. We need to give the potato’s temperature a
distinct name, so that it isn’t an anonymous property. Once the property
has a name, we can test whether any object possesses that property. The
final version is a bit more wordy, but it works as needed:

```
Temperature is a kind of value. The temperatures are cold, warm, and hot.

The Library is a room. A toad is in the Library. The blazing fireplace is an open scenery container in the Library.

The player carries a potato. The potato has a temperature called the heat. Understand "hot" as the potato when the heat of the potato is hot. The description of the potato is "It's brown and a bit lumpy[if the heat of the potato is hot]. It's also glowing with heat[end if]."

Instead of taking something:
	if the noun provides the property heat:
		if the heat of the noun is hot:
			say "You'd burn your fingers.";
		otherwise:
			continue the action;
	otherwise:
		continue the action.
```

Because we’ve named the property “heat”, we can test whether any object
that the player might refer to during the game possesses the property
(called) heat.

Giving properties to objects is an extremely useful way of controlling
how the objects will function in a game. Number properties are also
useful; for more on this topic, you can consult [ WI 4.12: Values that
vary](../WI_4.html#section12). In this section of the *Handbook* we’ve
concentrated on properties that are lists of adjectives. We’ve seen how
to create such a list within a single object, how to apply it to all
objects, and how to create it as a separate kind of value that may or
may not be applied to any given object. We’ve also looked at how to
change the description of an object based on the current value of a
property and how to let the parser know that a word can be used to
describe the object only when the object’s property has a certain value.
Finally, we’ve shown how to give a property a name of its own, so as to
be able to test whether the object has that sort of property.

### Plurals & Collective Objects   {#plurals-collective-objects}

As mentioned earlier (in Chapter 2), some objects need to be plural –
for example, the tall old trees standing beside the forest path, or the
cows grazing in a nearby field. It’s usually not necessary to make every
tree a separate object. Instead, we make a single scenery object, and
give it the property plural-named. We can do this ourselves, by writing
“The tall old trees are plural-named”, or we can let Inform figure it
out, by using the word “some”. Let’s create a plural-named object that
isn’t scenery:

```
Some scissors are on the sewing table. The description is "The
scissors look quite sharp." Understand "sharp", "blades", and "shears"
as the scissors.
```

Because we said “Some scissors”, Inform will make the scissors
plural-named. So if it needs to mention the scissors – in an inventory
list, for instance – it will say “You are carrying some scissors” rather
than “You are carrying a scissors.”

If we need to create a collective object, such as sand or water, we
can’t use “some” in this way. Here’s the wrong way to do it:

```
Some brackish water is in the pond. [Error!] The water is fixed in place.
```

If the player tries TAKE WATER, the game will respond, “Those are hardly
portable.” Instead, we need to do it like this:

```
The brackish water is in the pond. The indefinite article of the brackish water is "some". The water is fixed in place.
```

When we do it this way, by telling Inform what the indefinite article
is, Inform understands that the water is not plural-named, but that it
should nevertheless say “some water”, not “a water”.

Quite often, we need to write text that will produce outputs for various
objects. In this case, we use “\[the noun\]” or “\[a noun\]” and let
Inform substitute whatever noun is currently being talked about. (The
substitutions “\[the second noun\]” and “\[a second noun\]” work the
same way.) But when we do this, we have to be careful about how we
construct the sentence. This looks correct, but it’s a bug:

```
say "[The noun] is too heavy for you to carry." [Error!]
```

If the noun being referred to at the moment happens to be plural-named,
the output will be wrong:

> <span class="command">take boulders</span> \
> The boulders is too heavy for you to carry.

The old-school solution is to fix this by hand:

```
say "[The noun] [if the noun is plural-named]are[otherwise]is[end if] too heavy for you to carry."
```

Inserting an if-test within text in this way is sometimes an ideal
solution to a tricky problem. But when writing messages that may need to
refer to things that are plural-named it’s almost always more convenient
do this:

```
say "[The noun] [are] too heavy for you to carry."
```

This type of syntax used to require an extension called Plurality by
Emily Short, but it now works fine even without that extension, because
the concepts in Plurality have been built into Inform.

[WI 4.14: Duplicates](../WI_4.html#section14) shows how to create
collections of indistinguishable items. This is occasionally useful. For
example, you might be implementing an old-fashioned money system in
which the player can have a purse containing copper pennies, silver
dollars, and gold eagles. The coins within each group are identical, so
it really doesn’t matter which object the player picks up when using the
command PICK UP PENNY.

But precisely because they’re identical, writing code that will move one
of them somewhere is slightly tricky. The way to do this is to refer to
“a random” object of that kind, in the location where you’re sure one is
to be found. Even if there’s only one object of the kind available, you
still have to refer to “a random” object of that kind.

Here’s a simple example:

```
The Poultry Shop is a room.

A coin is a kind of thing. Understand "coin" as a coin.
A copper penny is a kind of coin.
A silver dollar is a kind of coin.
A gold eagle is a kind of coin.

The player carries three copper pennies, five silver dollars, and two gold eagles.

The shopkeeper is a man in the Poultry Shop. The shopkeeper carries a duck.

Instead of buying the duck:
	if the shopkeeper carries the duck:
		let P be a random copper penny carried by the player;
		if P is not nothing:
			now the shopkeeper carries P;
			now the player carries the duck;
			say "You buy the duck from the shopkeeper for a penny.";
		otherwise:
			say "'I'll need a penny for this handsome duck,' the shopkeeper says.";
	otherwise:
		say "You've already bought the duck."
```

One thing that’s worth noting about this code is that you have to refer
to objects of a kind using the *entire* term you used when creating the
kind. If you write “let P be a random penny” after creating a kind
called “copper penny”, Inform won’t know what you’re talking about.

You may want to spend a moment studying how this Instead rule is
written. We can safely assume that the player is in a room where the
duck is visible, because if there’s no duck, the parser will never need
this Instead rule; it will simply reply, “You can’t see any such thing.”
So the first question to be asked is, does the shopkeeper still have the
duck? Could be yes, could be no. (We will ignore the possibility that
the shopkeeper may have hidden the duck under the counter; we’ll assume
that the only way he’s going to give it up is if you buy it.) The second
question is, does the player still have a penny to spend? Could be yes,
could be no.

Trapping all of the logical possibilities is a big part of IF
programming.

To return to the main topic of this section, once you’ve created some
indistinguishable objects, you’ll quickly discover that the game’s
output looks a bit clumsy:

> <span class="command">drop dollars</span> \
> silver dollar: Dropped. \
> silver dollar: Dropped. \
> silver dollar: Dropped. \
> silver dollar: Dropped. \
> silver dollar: Dropped.

There’s nothing really wrong with this except that it looks like a
leftover from the 1980s. It doesn’t read well. The extension
[Consolidated Multiple Actions by John Clemens][4] addressed this issue
for earlier versions of Inform. It was not initially compatible with
6L38, but Emily Short has updated it. Hopefully it will be available on
the Public Library by the time you read this. Including this extension
in your game has no effect on the internal logic of the game (although
it does require that the game be compiled to Glulx, so it can’t be used
in .z8 games), but it changes the way the action is reported to the
player:

> <span class="command">drop dollars</span> \
> You put down the five silver dollars.

### More about Collections & Kinds   {#more-about-collections-kinds}

Inform lets you make either unique objects or kinds of objects. One
reason to make several objects of a given kind is because they’re
indistinguishable from one another, like the pennies in the section
“Plurals & Collective Objects,” above. But sometimes we want to make
several objects of a single kind that are similar, yet different – for
example, the various kinds of fruit in the section [Things vs.
Kinds](#things-vs-kinds). When we do this, the player may very
reasonably want to perform an action on all of the members of the kind
at once (or at least, on all of the members that are available at that
point in the game). Persuading Inform to report the action in a graceful
way is not guaranteed to be simple.

The extension Consolidated Multiple Actions, as mentioned earlier, can
handle some of these situations, but not all of them. If you want this
extension to be used with any new actions you define in your game,
you’ll need to write a bit of extra code. This rather gross example
shows how to do it:

```
Include Consolidated Multiple Actions by John Clemens.

The Test Lab is a room.

Moe is a man in the Lab.

A glop is a kind of thing. The indefinite article of a glop is "some". Understand "glop" as a glop. Understand "glop" as the plural of glop.

The jelly is a glop. The glue is a glop. The taco sauce is a glop. The player carries the jelly, the glue, and the taco sauce.

Smearing it on is an action applying to two things and requiring light. Understand "smear [things] on [something]" as smearing it on.

Report smearing it on:
	say "You smear [the noun] on [the second noun]."

Last for reporting consolidated actions rule when smearing on:
	say "You smear [consolidated objects] on [the second noun]."
```

The output looks like this:

> <span class="command">smear glop on moe</span> \
> You smear the jelly, the glue and the taco sauce on Moe.

Consolidated Multiple Actions produces the output line – but in order
for it to do its work, you have to do two things. First, your new action
(in this example, the new action is called smearing it on) has to be
defined using the “\[things\]” token, so that it can be used with
multiple objects. Second, the action needs a “for reporting consolidated
actions rule”. Oddly enough, this rule has to be written for the action
“smearing on” rather than the action “smearing it on” – don’t ask me
why.

The third aspect of this example, creating a kind called glop, is only a
nice extra. Even if we hadn’t done this, Consolidated Multiple Actions
could handle a list of objects, like this:

> <span class="command">smear jelly and glue on moe</span> \
> You smear the jelly and the glue on Moe.

There are also times when we would like the player to be able to examine
a group of related objects (such as several objects of the same kind)
and read a single result. The examining action can’t normally be used by
the player to look at more than one object at a time, so the default
response if you try to examine several things is, “You can’t use
multiple objects with that verb.” The method described in the old
edition of the *Handbook* for examining multiple objects no longer
works, because of improvements in the Inform parser. However, a new and
better way to get the same output is described in Example 295, “The Left
Hand of Autumn.” This example shows how to set up a multiply-examining
action that can handle several different lists of items, so let’s see if
we can simplify it a bit. The tricky part (if you’re new to the rather
twisty business of how Inform handles commands, which we’ll get into in
Chapter 4) is making sure the command processing sequence does what we
want it to, and then stops. This is the purpose of the truth state
called group-description-complete in the following code.

```
The Guardhouse is a room.

A guard is a kind of person. Understand "guard" and "man" as a guard. Understand "men" as the plural of a guard. The description of a guard is usually "He's wearing armor and a tarnished tin nametag that says '[the noun].'"

Moe is a guard in the Guardhouse. Larry is a guard in the Guardhouse. Curly is a guard in the Guardhouse.

Guard list is a list of objects which varies. Guard list is { Curly, Larry, Moe }.

When play begins: 
	sort guard list.

Understand "examine [things]" or "look at [things]" as multiply-examining. Multiply-examining is an action applying to one thing.

Understand "examine [things inside] in/on [something]" or "look at [things inside] in/on [something]" as multiply-examining it from. Multiply-examining it from is an action applying to two things. 

Group-description-complete is a truth state that varies. 

Carry out multiply-examining it from: 
	try multiply-examining the noun instead. 

Check multiply-examining when group-description-complete is true: 
	stop the action. 

Carry out multiply-examining: 
	let L be the list of matched things; 
	if the number of entries in L is 0, try examining the noun instead; 
	if the number of entries in L is 1, try examining entry 1 of L instead; 
	describe L; 
	say line break; 
	now group-description-complete is true. 

Before reading a command: 
	now group-description-complete is false. 

The silently announce items from multiple object lists rule is listed instead of the announce items from multiple object lists rule in the action-processing rules. 

This is the silently announce items from multiple object lists rule: 
	unless multiply-examining or multiply-examining something from something: 
		if the current item from the multiple object list is not nothing, say "[current item from the multiple object list]: [run paragraph on]". 

Definition: a thing is matched if it is listed in the multiple object list. 

To describe (L - a list of objects): 
	sort L; 
	if L is guard list: 
		say "They're wearing armor and nametags, which identify them as Moe, Larry, and Curly."; 
	otherwise: 
		say "You see [L with indefinite articles]."
```

For a simple example that shows how to consolidate the output messages
when a collection of objects can get into different states, see the
[Broken Eggs example](#broken-eggs).

### Objects That Have Parts   {#objects-that-have-parts}

In real life, most objects are made up of various parts. For instance,
an electric stove has heating elements (burners), perhaps an oven built
into it, and knobs for turning the burners on and off. Inform lets us
model a complex object like a stove by defining the other objects that
are its parts.

With simple objects such as a knife or a cup, there’s usually no need to
create separate objects to model the parts. We can just make the names
of the parts refer back to the main object, like this:

```
The player carries a knife. The description is "It’s a shiny Bowie knife with a sharp three-inch blade and a black leather hilt." Understand "shiny", "Bowie", "sharp", "blade", "black", "leather", and "hilt" as the knife.
```

If the player types X BLADE or X HILT, the game will simply print out
the description of the knife. That may be all that we need. But with a
more complex object, adding parts is a good way of designing it. The
basics of how to do this are well explained on [WI 3.23: Parts of
things](../WI_3.html#section23). [Example 36:
Brown](../examples/brown.html) shows how to make parts that can be
detached and reattached. Unless our code detaches a part of an object,
it will always be part of the object. If the larger object is picked up
or dropped by the player, all of its parts will travel along with it
automatically.

One of the advantages of using parts is that in Inform, any single
object can be either a container or a supporter, but not both. If our
model world includes an object like a chest of drawers, we need to make
the chest itself a supporter (because the player may want to put things
on top of it), and make its drawers openable containers. Making the
drawers parts of the chest is a wise precaution: If you should later
change the design of the game to allow the chest of drawers to be moved
from place to place, the drawers will come along with it automatically.

[RB 8.4](../RB_8.html#section_4) has some examples showing how to make
furniture. [Example 83: Yolk of Gold](../examples/yolk_of_gold.html),
has a complete implementation of a three-drawer dresser, with the added
feature that the player will always find what he’s looking for in the
last drawer he opens, no matter which drawer it is.

There are two ways to make something part of something else. We can say:

```
The blade is part of the knife.
```

…or we can say:

```
The knife incorporates the blade.
```

Parts are detachable and attachable objects. This fact can be extremely
handy. Let’s suppose, for instance, that in your game you want the
player to be able to put a stamp on a postcard:

```
The player carries a postcard and a stamp. Understand "card" and "post card" as the postcard. Understand "postage" as the stamp. The description of the postcard is "A plain white postcard[if the stamp is part of the postcard] with a stamp on it[end if]."

Instead of tying the stamp to the postcard:
	if the stamp is part of the postcard:
		say "You already did that.";
	otherwise:
		now the stamp is part of the postcard;
		say "You lick the stamp and affix it to the postcard."

Test me with "x card / fasten stamp to card / x card / take stamp".
```

You may notice that the action provided by Inform is called tying it to.
The player is unlikely to try TIE STAMP TO POSTCARD, but the command
would work. The words ATTACH and FASTEN are used by Inform’s parser as
synonyms for TIE. If we want the player to be able to use the command
PUT STAMP ON CARD, however, we’ll have to do just a little more work:

```
Instead of putting the stamp on the postcard:
	try tying the stamp to the postcard.
```

The main point of the code above is that after the stamp has been
attached to the postcard, the player will get this output:

> <span class="command">take stamp</span> \
> That seems to be a part of the postcard.

In addition, when the player picks up the postcard and carries it
around, the stamp will now be brought along for the ride. To learn how
to detach parts of objects, see the [Mr. Potato Head
example](#mr-potato-head).

### Reading Matter   {#reading-matter}

Inform’s standard rules assume that READ means the same thing as
EXAMINE. This is not a bad assumption for a simple game. In the case of
a roadside sign, the description of the sign would probably include the
text printed on the sign, so there’s no need to have a special reading
action. But in the case of a book or even a note on a piece of paper, we
may want to make reading a separate action. Here’s how to do it:

```
A thing has some text called the reading-material. The reading-material of a thing is usually "".

The book is in the Library. The description is "A first edition of [italic type]In Praise of Folly[roman type], by Erasmus." Understand "praise", "in praise of", "folly", and "erasmus" as the book. The reading-material of the book is "A fascinating discussion of the idiocies to which the human mind is susceptible. After reading it, you feel quite humble, and even more foolish than before".

Understand the command "read" as something new.

Reading is an action applying to one thing and requiring light.
Understand "read [something]" as reading.

Check reading:
	if the reading-material of the noun is "":
		say "Nothing is printed on [the noun].” instead.

Carry out reading:
	say "[reading-material of the noun]."
```

If your game also includes things like roadside signs, for which you
want READ to give the same result as EXAMINE, you could change the Check
rule like this:

```
Check reading:
	if the reading-material of the noun is "":
		try examining the noun instead.
```

Another way to do it would be to leave the Check rule saying “Nothing is
printed on \[the noun\]” and add this for any signs:

```
Instead of reading the roadside sign:
	try examining the roadside sign.
```

My first idea, in designing this example, was to start by saying, “A
thing can be legible or illegible. A thing is usually illegible.” But
after thinking about it for a minute, I realized I could simplify the
code. All the Check Reading rule needs to do is find out whether the
reading-material of the noun is “” (that is, whether it’s empty).
Anything that has text in its reading-material can now be read. Note
also that the reading-material of the book ends without a period. This
is because the period is at the end of the quoted bit in the Carry Out
Reading rule.

Another thing we might want to do in a game is create a book (or even a
computer) in which the player can look things up. The best way to do
this is by creating an action that uses the topics we want the player to
look up – see [Actions with Topics](#actions-with-topics).

### Writing on Things   {#writing-on-things}

A few years back, when I was teaching an IF programming class to some
younger students, One of them asked how to create a notepad that the
player could write things on. A real software notepad, in which you
could select words and sentences with the mouse, would be almost
impossible to create in an Inform game. But creating an in-game object,
such as a piece of paper or an old-fashioned slate, that the player can
write on is not terribly difficult.

An object like this might even be part of a puzzle: You could use it to
let the player leave a message for another character. After writing this
section of the *Handbook,* I expanded its ideas into the [Notepad
extension][5]. The extension includes an example showing how to let a
character respond to written commands. The example below is more basic
than the extension; it simply creates a slate that the player can write
on or erase. First we’ll create a new kind of thing called a notepad.
Then we’ll change the command READ (which normally triggers the
examining action) and add two new actions – writing it on and erasing.

```
A notepad is a kind of thing. A notepad has a text called memo. The memo of a notepad is usually "".

Understand the command "read" as something new.

Reading is an action applying to one thing and requiring light. Understand "read [something]" as reading.

Check reading:
	if the noun is not a notepad:
		say "Nothing is written on [the noun]." instead;
	otherwise if the memo of the noun is "":
		say "At the moment, [the noun] is blank." instead.

Carry out reading:
	if the memo of the noun is not "":
		say "On [the noun] you find the words '[memo of the noun].'";
	otherwise:
		say "Nothing is written on [the noun]."

Writing it on is an action applying to one topic and one thing and requiring light. Understand "write [text] on [something]" as writing it on.

Check writing it on:
	if the second noun is not a notepad:
		say "You can't write anything on [the second noun]!" instead.

Check writing it on when the second noun is the slate:
	if the player does not carry the chalk:
		say "You'd need some chalk to do that." instead.

Carry out writing it on:
	let T be  text;
	let T be the topic understood;
	now the memo of the second noun is T;
	say "Writing '[T]' on [the second noun]."

Erasing is an action applying to one thing and requiring light. Understand "erase [something]" as erasing.

Check erasing:
	if the noun is not a notepad:
		say "There's nothing on [the noun] to erase." instead;
	otherwise if the memo of the noun is "":
		say "At the moment, nothing is written on [the noun]."

Carry out erasing:
	now the memo of the noun is "";
		say "You erase what was written on [the noun]."

The Lab is a room. A piece of chalk is in the Lab.

The player carries a fish. The description of the fish is "Scaly."
The player carries a slate. The slate is a notepad. The description of the slate is "Black."

Test me with "read fish / read slate / write E=mc2 on fish / write E=mc2 on slate / take chalk / write E=mc2 on slate / read slate / erase fish / erase slate / read slate".
```

Most of this example could be copied straight across into your own game.
One detail that’s specific to the example is checking whether the player
is carrying the chalk before letting her write on the slate. If your
game uses a piece of paper as the notepad object, simply change the
piece of chalk to a pencil.

### Mechanical Marvels   {#mechanical-marvels}

Inform provides a kind of thing called a device<span id="Ref_device"
class="anchor" />. The idea is, if you want to create something that can
be switched on or off, you can call it a device. Inform will then
understand that the commands SWITCH ON and SWITCH OFF can be applied to
it (along with a few synonyms, such as TURN ON and TURN OFF). A device
keeps track of whether it’s switched on or switched off, so this
property can be tested in your code:

```
if the electric razor is switched on:
	now the player is clean-shaven;
	[…and so on…]
```

The only other thing a device does, by default, is this: If the player
examines it, the game will report whether it’s currently switched on or
switched off. That’s okay if the device is something like an electric
fan, which has a large black plastic on/off switch with the words ON and
OFF printed on its mounting. It’s less desirable if the device has no
visible switch and doesn’t look any different when it’s switched on. In
that case, we might prefer to prevent Inform’s automatic mention of the
device’s on/off state. This can be done by removing the rule that causes
the state to print out, like this:

```
The examine devices rule is not listed in any rulebook.
```

If you do this, it’s up to you to write a description for each device
that will alert the player to the device’s state:

```
The description of the electric razor is "It's a Remington cordless[if switched on]. At the moment it's humming faintly[end if]."
```

If you want the on/off state to not be mentioned with respect to only
one device, unlisting the examine devices rule is like unscrewing a
screw with a shovel. Instead, do this:

```
The examine devices rule does nothing when the noun is the electric razor.
```

(Note: This procedure only works from 6L02 onward; if you’re using an
older version of Inform, you’re on your own.) Another odd thing about
Inform’s default implementation of devices – well, let’s stick with the
electric razor for a minute. The command SWITCH RAZOR means the same
thing as SWITCH RAZOR ON. I personally prefer to have the command SWITCH
RAZOR operate as a toggle: Giving the command when the razor is off
should turn it on, and giving the command when the razor is on should
turn it off. I managed to figure out one way to do this, and then Emily
Short suggested a better way. In the interest of providing a more
complete tutorial, let’s look at them both.

My method requires a side trip to [WI 17.3: Overriding existing
commands](../WI_17.html#section3), where you’ll learn how to detach the
word “switch” from the switching on action.

```
Understand the command "switch" as something new.
```

The tricky thing is, when we do this, SWITCH ON and SWITCH OFF won’t
work either, because we’ve detached the word “switch” from *all*
commands. So in addition to creating a new action (which we’ll call
toggling), we also have to replace the grammar for SWITCH that we want
to work the way it did before.

Here’s the final version of my code:

```
Understand the command "switch" as something new.
Understand "switch [something] on" and "switch on [something]" as switching on.
Understand "switch [something] off" and "switch off [something]" as switching off.

Toggling is an action applying to one thing and requiring light. Understand "toggle [something]" and "switch [something]" as toggling.

Check toggling:
	if the noun is not a device:
		say "[The noun] can't be toggled on and off."

Carry out toggling:
	if the noun is switched on:
		try switching off the noun instead;
	otherwise:
		try switching on the noun instead.
```

Now the command SWITCH RAZOR will alternately switch the razor on and
off.

Emily’s method is much simpler, and illustrates a cool feature of Inform
programming:

```
Understand "switch [a switched on thing]" as switching off.
```

That’s it – that’s the whole answer. Emily explains it this way:
“Because ‘a switched on thing’ is more specific than ‘a thing’, this
understand line will be sorted early in the parse list and will be
matched first if it applies \[to the player’s input\]. Switched off
things will continue to be caught by the existing understand line. The
clever use of adjectives in understand tokens is a useful technique to
have in one’s Inform programming repertoire. It’s possible to tuck some
complicated logic into the parser without having to write a separate
action for each possible variation.”

The default response when a device is switched on or off is this:

> <span class="command">switch on razor</span> \
> You switch the electric razor on.

This is functional, but with some devices, we might want something more
descriptive. If you simply write a “Report switching on” rule for your
device, it will run – and then the standard report switching on rule in
the library will run, resulting in a double output:

> <span class="command">switch on razor</span> \
> The razor begins humming faintly. \
> You switch the electric razor on.

This is obviously undesirable. Here’s how to get rid of it for a
specific device:

```
Report an actor switching on (this is the new report switching on rule):
	if the action is not silent:
		if the noun is the razor:
			say "The razor begins humming faintly.";
		otherwise:
			say "[The actor] [switch] [the noun] on." (A).

The new report switching on rule is listed instead of the standard report switching on rule in the report switching on rulebook.
```

With this code in place, your own report for the action of switching on
the razor will be the only output displayed in response to the action.

Creating buttons that can be pushed and levers that can be pulled is
almost too simple to be worth mentioning:

```
The silver lever is a part of the shiny blinking plastic box.

Instead of pulling the silver lever:
	say "Clunk! You pull the lever, and a silver dollar drops into the hopper.";
	let SD be a random silver dollar in the money bin;
	now SD is in the hopper.
```

[Example 298: Safety](../examples/safety.html) shows how to make a
spinning dial on a safe, but the example is hardly complete. For one
thing, the dial doesn’t exist as a separate object that can be examined.
And because it can’t be examined, there’s no way to find out what number
it’s currently set to. A question on the newsgroup rec.arts.int-fiction
(back when it was still used as a forum for IF discussion, before
IntFiction became the central hub) included some code for a dial that
could be set to any number from 1 to 8. I modified the posted code
slightly and came up with this dial:

```
The rotary dial is part of the safe. The dial has a number called current setting. The current setting of the dial is 1. The dial has a number called max setting. The max setting of the dial is 8. The description of the dial is "The rotary dial has eight numbers, 1 through [max setting]. At the moment it's set to [current setting]."

Instead of turning the dial:
	increase the current setting of the dial by 1;
	if the current setting of the dial > max setting of the dial:
		now the current setting of the dial is 1;
	say "You turn the dial to [current setting of the dial]."

Understand "set [something] to [number]" as setting the state of it to. Setting the state of it to is an action applying to one thing and one number. Understand "turn [something] to [number]" or "turn [something] to setting [number]" or "turn [something] to position [number]" or "adjust [something] to [number]" or "adjust [something] to position [number]" or "adjust [something] to setting [number]" as setting the state of it to.

Check setting the state of it to:
	if the noun is not the rotary dial:
		say "You can't set [the noun] to a number." instead;
	if the number understood < 1, say "The lowest setting is 1." instead;
	if the number understood > max setting of the dial, say "Sorry, the dial can only be set from 1 to [max setting of the dial]." instead.

Carry out setting the state of it to:
	now the current setting of the noun is the number understood;
	say "You turn the dial to [number understood]."
```

Combining this code with Example 298 would require a little more work.
In a real game, you might want to create three dials of this type, and
mount them side by side on the door of the safe. This would force the
player to figure out what three-digit number to dial. You might also
want to write some code that would interpret DIAL 123 as a command to
set the first dial to 1, the second dial to 2, and so on. I’ll leave
this as an exercise for you to try on your own. The main things to
notice about the code given above are:

1.  A new action, setting the state of it to, can be used to SET DIAL TO
    3 (or any other number between 1 and the max setting of the dial).
2.  The command TURN DIAL will increment (add 1 to) the setting of the
    dial.
3.  If the dial is already at its max setting, TURN DIAL will rotate it
    around to 1 again.
{: .num}

Many other kinds of mechanical contrivances might be useful in your
game. If you want to create a tricycle that the player can ride, for
instance, you’ll want to look at the extension called Rideable Vehicles
by Graham Nelson, which is now built into Inform. In Appendix C of this
*Handbook,* you’ll find an example of a device (the “Omega Machine”)
that will respond to commands.

### Smelling & Listening   {#smelling-listening}

Inform includes the commands “smell \[something\]” and “listen to
\[something\]”, but they don’t do anything. The output is “You smell
nothing unexpected” or “You hear nothing unexpected.”

An important part of writing good fiction (of any kind, not just
interactive fiction) is letting your readers use all of their senses.
Adding an odor or sound to a single object with an Instead rule is easy:

```
Instead of smelling the garbage:
	say "It smells awful!"
```

This will work if the player types SMELL GARBAGE. But the player might
just type SMELL. As explained on [WI 7.7: the other four
senses](../WI_7.html#section7), this command is redirected to smelling
the location (the room) – and again, by default, the game replies, “You
smell nothing unexpected.” If the garbage is in the location, this
response is just plain wrong. If the garbage is fixed in place, we can
give the room an Instead rule so that it will respond to the SMELL
command:

```
Instead of smelling the Alley:
	say "It smells of garbage."
```

But we’ll have to do that for every room where there’s an odor, and if
some of the things that have odors are getting moved around during the
game, keeping track of them in order to list the odors will get messy.

Fortunately, it’s not hard to improve Inform’s handling of smelling and
listening. The *Recipe Book* provides several good examples of ways to
add sounds to a game, so in the *Handbook* we’ll concentrate on odors.
In the code below, we’re going to give every thing in the game a scent
(which is a text in quotes). By default, this text will be empty. But
now we can add a scent as a property of a thing, rather than needing to
write a whole new Instead rule. A single Instead rule (Instead of
smelling something) will handle any object the player tries to SMELL.

The other feature we’ll add is this: We’ll define a thing as smelly if
its scent is not “” (that is, when the scent property is not empty).
When there is something smelly in the room, typing SMELL will list the
smelly things in the room.

```
A thing has some text called the scent.

Definition: A thing (called the odor-bearer) is smelly if the scent of the odor-bearer is not "".

Instead of smelling something:
	if the noun is smelly:
		say "[scent of the noun][paragraph break]";
	otherwise if the noun is the player:
		say "You don't smell too sweaty today.";
	otherwise:
		say "It smells like an ordinary [noun]."

Instead of smelling a room:
	let L be the list of smelly things enclosed by the location;
	if L is empty: 
		say "You smell nothing unexpected."; 
	otherwise: 
		say "You smell [a list of smelly things enclosed by the location]." 

The Kitchen is a room.
The banana is in the Kitchen. The scent of the banana is "It smells sweet and ripe."
The loaf of bread is in the Kitchen. The scent of the bread is "Ah -- fresh-baked bread."
```

Here’s the output when the player is in the Kitchen:

> <span class="command">smell</span> \
> You smell a banana and a loaf of bread.

There are other ways to implement smelling. This is normal in writing
interactive fiction – the author can usually solve the same problem by
using several different techniques. Below is a simple example game that
I’ve adapted from an example uploaded to the [IF Wiki][6]). It differs
from the code shown above in a number of ways.

First, it implements the smelling action in a more complete way. Because
it uses Carry Out and Report rules rather than Instead rules, it has to
start by removing the block smelling rule from the Standard Rules.
Second, it gives distinct odors to rooms rather than just listing any
smelly objects that are in the room. Third, it has the beginnings of a
puzzle, in the form of a spacesuit that will block smelling. Fourth, the
odor of the sewage is so powerful that it will prevent you from smelling
the flower.

```
[First we'll create the property for all things and rooms.]
A thing has a text called odor.
A room has a text called odor.

Report an actor smelling (this is the new report smelling rule):
	if the actor is the player:
		if the action is not silent:
			if the odor of the noun is not empty:
				say "[the odor of the noun][paragraph break]";
			otherwise:
				say "[We] [smell] nothing unexpected." (A);
	otherwise:
		say "[The actor] [sniff]." (B).

The new report smelling rule is listed instead of the report smelling rule in the report smelling rulebook.

[The player might try 'smell the odor', so we'll allow that by creating a backdrop:]
The ambient-odor is a backdrop. It is everywhere. The description is "The odor is impalpable."
Understand "odor", "odour", "stench", "stink", "fragrance", "reek", and "smell" as the ambient-odor.

Instead of doing anything other than smelling or examining with the ambient-odor:
	try examining the ambient-odor.

Instead of smelling the ambient-odor:
	try smelling the location.

Street is a room. "You are in a street. The sewer is below you." The odor is "You pick up a faint odor from below."
A flower is here. The description is "It's just a nice flower. You don't know what type." The odor is "It smells wonderful."
A spacesuit is here. It is wearable. Understand "space suit" and "suit" as the spacesuit. The description is "Spacesuits are wonderful things, but they make EVERYONE look fat."

Sewer is below Street. "You are in a sewer. The street is above you."
Some sewage is here. It is fixed in place. The description is "Horrible smelly sewage is everywhere in the sewer." The odor is "It reeks."

[Finally we'll add some rules to restrict smelling.]
Instead of smelling when the spacesuit is worn and the noun is not yourself and the noun is not the spacesuit:
	say "You can't smell anything outside the spacesuit while wearing the spacesuit."
Instead of smelling in the presence of the sewage when the spacesuit is not worn and the noun is not the sewage:
	say "The disgusting reek of the sewage overwhelms your nose. You can't smell anything else."
```

In passing, you might want to take note of the lists of conditions in
those last two Instead rules. This syntax is not used much in the
*Handbook,* but it’s good to know about it.

### Transforming One Thing into Another   {#transforming-one-thing-into-another}

In a game that includes magic, you might want to turn an object into
another object. (Maybe this would happen when you cast a spell on the
object using my Spellcasting extension.) The easy way to do this in
Inform is to create both objects but leave one of them offstage at the
beginning of the game. When it’s time to transform the object, simply
whisk it offstage and replace it with the other object. Here’s the
classic story situation, more or less:

```
The Creekside is a room. "A burbling creek runs through the forest here."

The toad is an animal in the Creekside. "An ugly, warty toad squats on a rock near the creek." The description is "He's ugly and green." Understand "ugly" and "green" as the toad.

The princess is a woman. "A beautiful princess stands before you!" The description is "She's the most beautiful woman you've ever seen." Understand "beautiful" and "woman" as the princess.

Instead of kissing the toad:
	now the princess is in the location of the toad;
	now the toad is nowhere;
	say "As your lips touch the ugly toad, it shimmers and sparkles and turns into a beautiful princess. 'My goodness,' the princess declares. 'Thank you!'"

Instead of kissing the princess:
	say "The princess smiles modestly and pushes you away. 'Maybe later,' she suggests. 'After we get to know one another better.'"
```

Initially the princess is nowhere. The Instead rule does three things.
First, it makes a note about where the toad is. This is a good idea,
because in a real game the toad might be moving around, and it would be
a bug if you kiss the toad in the throne room and have the princess pop
up back at the creekside. Then the rule gets rid of the toad and moves
the princess to the room where the toad was.

If we’re transforming one inanimate object into another, we’ll want to
do it just a bit differently, because an inanimate object might be on a
supporter or in a container. If you’re transforming a gold crown into an
old shoe, for instance, and if the crown is on a table, you don’t want
the shoe to appear on the floor of the room – you want it to show up on
the table. To take care of this, we need to refer to “the holder” of the
crown. The holder will always be the crown’s immediate location:

```
Instead of casting shazam at the crown:
	now the old shoe is in the holder of the crown;
	remove the crown from play;
	say "The crown emits an unhappy crinkling, shriveling sort of noise, and turns into an old shoe."
```

### New Ways to Use Things   {#new-ways-to-use-things}

Inform’s model of how things exist (and can be used) in the world is
very simple. Sometimes you’ll want the player to be able to do something
new or unexpected with a thing. In this section we’ll borrow some ideas
from Chapter 4, “Actions,” and show you how to allow new kinds of
actions with the objects in your game. For details on how Check, Carry
Out, Report, and Instead rules work, consult Chapter 4. The main purpose
of the section you’re now reading is to show how to do interesting
things with the new objects you’ve created.

This section was inspired by an old post on rec.arts.int-fiction, which
I spotted while poking around in the [IF Wiki][6]). The list of new
actions suggested by Jan Thorsby in that post was short but suggestive:
holding an object close to or against another object, holding an object
up in the air, threatening an NPC with an object, or tipping a bookshelf
forward so that the thing on the top shelf will fall down. I’ll leave
you to explore the process of threatening an NPC for yourself. The other
three actions are illustrated below.

The number of new things you might want players to be able to do is
probably infinite. Some of them will turn out to be easy to set up;
others may be surprisingly tricky for you to implement. The key, in each
case, is to think logically and try to handle all of the things a player
might do. You’ll also need to consider all of the states that your
objects might get themselves into. For example, you may know that you
only want your new tipping action to apply to one object in the game –
but once players know that the TIP command works, they’ll surely try it
on anything and everything. So you need to write a check rule for your
new action that will handle any and all of players’ attempts with a
sensible-sounding refusal message. You may also want to write an in-game
clue to suggest that tipping something might be a good action to try.
For instance, in a description of an object: “It looks as if it might
tip over in a strong breeze.”

#### Holding Something Up in the Air   {#holding-something-up-in-the-air}

The player might very reasonably want to hold an object up in the air so
as to make it visible to an NPC who is far away. (If the NPC is in the
same room, a standard command of the form SHOW JEWEL TO PRINCESS should
do the job.) You might want to hold up a white sheet, for instance, if
you’re marooned on an island and trying to attract the attention of a
passing ship. Below is a simple example game that implements this
action. Notice the long list of input grammar that is allowed. You’d
probably want to add even more grammar lines to this list if you’re
using this action in a game.

The key point in this example is that the sheet has to be held aloft for
three consecutive turns on the beach in order to signal the passing
ship. If the player drops the sheet or walks west into the jungle, the
sheet is no longer aloft, and the count drops back to zero. Taking care
of details like these will add realism to your game.

The details are taken care of by the after dropping something and after
going rules, and by the new property called aloft. Every object in the
game can be aloft or not – but most of them won’t be, so this new
property will only be useful in a few cases.

Why make aloft a general property of all things, when you’re only going
to be using it for one object? Because it reduces the chance of bugs,
and makes your code easier to maintain and expand. If you should later
be writing a different section and decide that the player needs to hold
a torch aloft, you don’t have to go back and revise anything, because
the torch already has that property.

```
A thing can be aloft. A thing is usually not aloft. A thing has a number called the aloft-count. The aloft-count of a thing is usually 0.

The Beach is a room. The player carries a white sheet.

Elevating is an action applying to one thing. Understand "hold [something preferably held] up", "hold up [something preferably held]", "wave [something preferably held]", "elevate [something preferably held]", "hold [something preferably held] aloft", "hold [something preferably held] in the air", "hold [something preferably held] in air", and "hold [something preferably held] up in the air" as elevating.

Check elevating:
	if the noun is not held:
		say "You'll need to pick up [the noun] first.";
		rule fails.

Carry out elevating:
	now the noun is aloft;
	say "You hold [the noun] high in the air."

After dropping something:
	now the noun is not aloft;
	now the aloft-count of the noun is 0;
	continue the action.

After going:
	repeat with item running through things carried by the player:
		now item is not aloft;
		now the aloft-count of item is 0;
	continue the action.

The Jungle is west of the Beach.

Every turn:
	if the white sheet is aloft and the location is the Beach:
		increase the aloft-count of the white sheet by 1;
	if aloft-count of the white sheet is 4:
		end the story saying "A passing ship spots your signal, and steers in toward shore. You're saved!"
```

#### Tipping Something   {#tipping-something}

Placing an object out of reach – on a high shelf or down at the bottom
of a well, for instance – is a standard puzzle in IF (see Chapter 6,
“Puzzles”). Some high shelves are fixed to the wall, but some might be
the top shelf in a heavy bookcase that can’t be moved, but can be rocked
or tipped. In the example below, note that the pushing action (which is
part of Inform’s standard library) has been remapped to the new rocking
action.

```
The Living Room is a room. "The only furniture here is a tall bookshelf."

The bookshelf is a scenery supporter in the Living Room. "It's so tall you can't possibly reach the top shelf -- and oddly enough, there's only one shelf, the top one." Understand "top", "shelf", and "bookcase" as the bookshelf.

The Ming vase is on the bookshelf. The description is "A priceless vase!"

Instead of putting anything on the bookshelf:
	say "You can't reach the top shelf."

Instead of doing something other than examining when the noun is not nothing and the noun is on the bookshelf:
	say "You can't reach [the noun], as the shelf is too high."

Rocking is an action applying to one thing and requiring light. Understand "tip [something]", "rock [something]", "shake [something]", "tip [something] forward", and "rock [something] forward" as rocking.

Check rocking:
	say "There's no need to agitate [the noun]."

Instead of rocking the bookshelf:
	if the Ming vase is on the bookshelf:
		now the player carries the Ming vase;
		say "You give the shelf a good shake … and the vase teeters forward, reaches the edge, and plummets! Fortunately, you're able to catch it just before it hits the floor.";
	otherwise:
		say "There's nothing else up there."

Instead of pushing the bookshelf:
	try rocking the bookshelf.
```

#### Holding Something Against Something Else   {#holding-something-against-something-else}

This example creates a new action, holding it against. This action has
two Report rules. The thing you need to know is that when your game is
being compiled, Inform assembles all of the rules, including those in
the standard library, those in any extensions you have included, and any
you have written yourself, into rulebooks. *Both* of our new rules will
end up in the report holding it against rulebook – but Inform has some
very specific criteria (let’s not call them rules, as that would be
confusing) about how to do this. It puts more specific rules near the
top of the rulebook, and more general rules later in the rulebook.

As a result, the Report holding the stethoscope against the wall rule
will be earlier in the “report holding it against” rulebook. When this
rulebook is being consulted (after the player has used the command HOLD
STETHOSCOPE AGAINST WALL, for instance), Inform will consult the
rulebook *until one of the rules makes a decision*. Then it will stop.
For this reason, we’ll end the specific rule with the line “rule
succeeds.” This will prevent the more general rule from being applied.

```
The Cell is a room. "A dank, rat-infested cell. Faint murmurings can be heard from the other side of the wall."

A stethoscope is here. The stethoscope is wearable. Understand "scope" as the stethoscope.

Report wearing the stethoscope:
	say "You insert the ear-pieces into your ears.";
	rule succeeds.

The wall is scenery in the Cell. The description is "Solid cement blocks."

Holding it against is an action applying to two things. Understand "hold [something] against [something]", "press [something] against [something]", and "apply [something] to [something]" as holding it against.

Check holding it against:
	if the player does not enclose the noun:
		say "You'll need to be holding [the noun] in order to do that.";
		rule fails.

Report holding it against:
	say "You press [the noun] against [the second noun] for a moment, but nothing seems to have been accomplished by this."

Report holding the stethoscope against the wall:
	if the player wears the stethoscope:
		say "You press the stethoscope against the wall. [one of]After a moment you hear a man's voice as distinctly as if he were in the cell with you: 'Good thing he doesn't know I hid the key in the light fixture!'[or]In the next room, two men are discussing horse racing. Since you already know where the key is hidden, there's probably no need to keep listening.[stopping]";
		rule succeeds.
```

Notice the non-default message that’s printed out when the player wears
the stethoscope. Also notice the use of “\[one of\] … \[or\] …
\[stopping\]” to insure that the conversation about the hidden key is
printed out only once.



[1]: https://github.com/i7/extensions/blob/10.1/Eric%20Eve/Bulk%20Limiter-v9.i7x
[2]: https://github.com/i7/extensions/blob/10.1/Eric%20Eve/Underside-v6.i7x
[3]: https://github.com/i7/archive/blob/master/Jon%20Ingold/Considerate%20Holdall.i7x
[4]: https://github.com/i7/extensions/blob/9.3/John%20Clemens/Consolidated%20Multiple%20Actions.i7x
[5]: https://github.com/i7/extensions/blob/10.1/Jim%20Aikin/Notepad-v3.i7x
[6]: https://ifwiki.org/
