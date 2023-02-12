# Chapter 5: Creating Characters

Stories are about people. Because
interactive fiction is a form of storytelling, it’s almost inevitable
that you’ll want to include a few people in your game. A story with no
people in it probably won’t be very interesting or fun – at least not
for very long. If your players can’t do anything but wander around
picking up treasures and fighting off monsters, before too long they’ll
start to get bored. Besides, even a monster is a person, loosely
speaking.

Using Inform, you can add people (or talking animals, or whatever
sort of odd characters you’d like) to the games you write. Creating
lifelike characters is an important skill to learn, and it may be the
most complicated part of writing IF. In this chapter we’ll cover the
basics of creating characters and also look at a few advanced techniques
that you’ll probably want to use as your story develops.

Programming a non-player character (the abbreviation “NPC” is used
throughout the interactive fiction community to refer to a non-player
character) is complicated because people are complicated. Think about
the differences between interacting with your Uncle Fred and interacting
with a bowling ball. Uncle Fred does things on his own – that is, he
initiates activities. A bowling ball doesn’t. Uncle Fred may observe you
and comment on something you’re doing. A bowling ball won’t. Uncle Fred
may respond to you differently depending on whether he’s happy or sad,
or on whether he’s upset with you. A bowling ball will respond exactly
the same whether it’s red or black or zebra-striped. (If it’s lopsided,
all bets are off.)

The ways that people interact with one another are also complicated:
Uncle Fred might respond differently if you shout or whisper, but a
bowling ball won’t. To make matters worse, shouting and whispering are
not modeled in most IF conversation systems.

Whoever plays your game will naturally hope (or worse, expect) that
the player character will be able to interact with other characters the
same way the player herself would interact with a real person. Sadly,
that degree of realism is just about impossible to achieve using today’s
interactive fiction programming tools. The parser is designed to accept
in puts in the form <VERB> <NOUN> <PREPOSITION>
<NOUN>. Anything more complicated is not likely to work well. The
only wrinkle that is usually added to this system is that the player may
be able to give commands to an NPC. The syntax for this begins with the
name (or other identifier, such as “dragon” or “frog”) of the NPC, then
a comma, then the usual syntax. For instance, BOB, PUT THE BOMB ON THE
TABLE.

Why not design a parser that will accept more complex interactions
with NPCs? This turns out to be a difficult problem in computer science.
Various people have tried it, but so far, the results have not been
inspiring. Technically, it’s possible to write a game that will respond
to whatever complicated player inputs you’d like. If you want your game
to respond to ASK EMILY WHETHER EMILE’S DOG IS STILL TOO SICK TO HUNT
FOR THE SQUIRREL, you can do it using the “after reading a command”
activity, as explained in [WI 18.33: Reading a command](../WI_18.html#section_33). But there are several problems with
this type of trick, including the problem of letting the player know
that such a complex input is possible. I don’t recommend that authors go
down that road in their first or second game.

Even while sticking within the limitations of “normal” IF
programming, we can employ various tricks to make our characters seem
more real. The characters may be just the software equivalent of
cardboard, but players will enjoy meeting and talking with them.

Before we start talking about specific programming techniques, we
need to talk about how you might want to use characters in your
interactive story. What roles or functions might they take on?

<div class="sidebar">

### Believable Characters

Characters will seem more believable if the player’s interaction with
them is limited. This could be because the NPC plays a limited role in
the story, or does not know the PC (player character): It’s a lot easier
to make a guard believable than a girlfriend! You can also limit the
interaction with a character by moving the character onstage and
offstage again quickly. Characters who have a single-minded obsession
with one thing (for instance, a king who only cares about whether you’re
a spy) are easier to create than characters who are just hanging out.
But the latter sort (Emily Short’s Galatea, from the game of the same
name) can be vivid and memorable.

</div>


## Overview

To begin with, your players will probably want to be able to talk to
the other characters. There are several ways to set up a conversation
system. Each method has advantages, and also weaknesses, as we’ll
see.

One common reason to want to have a conversation with a character is
to try to learn something useful. If you’re writing a game about
criminals, for instance, ASK POLICEMAN ABOUT BURGLAR might be an
important command for the player to try. Another reason to have a
conversation is because you hope to cause the character to do something.
If the player types TELL POLICEMAN ABOUT BURGLAR, the policeman might
rush off to arrest the burglar – a real change in the world of the story
that won’t take place unless the player gives that command.

The player character may need help doing something, and may want to
ask another character for help. For instance, a player character who has
only normal strength might want to enlist the aid of a weight-lifter to
move a boulder. So the player may need a way to give instructions to
other characters. ASK REGINALD TO LIFT THE BOULDER could be an important
part of the game.

Characters may have possessions that the player needs. One common
type of instruction is to ask for an object. If you ASK MARY FOR DIAMOND
NECKLACE, she might refuse to part with it, or she might give it to you,
depending on how the game is written.

Some characters are stationary – they’re always in one room. Other
characters may wander around the map. They may follow the PC, or run
away when the PC approaches.

Characters will sometimes carry out simple tasks on their own, such
as stealing things from the player or even killing the player.

When a character is in the same room as the player, the character may
seem more lifelike if it’s carrying out some sort of “stage business,”
engaging in a minor activity every turn, or once every few turns, just
to remind the player that there’s someone else in the room. If the
character is doing this type of stage business, nothing is likely to
change in the room (although it could – the butler might be polishing
the silverware for 20 turns, and at the end of that time the description
of the silverware might change to say that it’s spotless and shining).
All that usually happens is that the game prints out a brief message
describing a nonexistent action.

If your story takes place in a world where there’s lots of fighting
(swordfights or laser guns, your choice!), you may want the player to
engage in hand-to-hand combat with other characters.

Groups of characters require special handling. If your player
character is facing a crowd of angry villagers armed with torches and
pitchforks, you probably don’t want to create a hundred different
villager characters. For one thing, it’s a lot of work, and you won’t
gain much in terms of realism or a more dramatic story. A better method
will usually be to create a single “crowd” object (which might not be a
person at all, as far as Inform is concerned) and then create a single
“spokesperson” man or woman, an actual Inform NPC object, who will
engage in any conversation or other activities. On the other hand, if
you’re writing an Agatha Christie type of murder mystery, you may want
to have as many as six or seven individual characters (the suspects) all
sitting around in the drawing room at the same time. Inform provides
some fascinating tools with which to allow these characters to relate to
one another. (See [Relations](#relations).)

## The Player Character

Pleasantly little needs to be said about creating the player
character (PC). Your PC can have any identity you might like, from a
mile-high evil robot to a small, cuddly bunny rabbit. Or the PC could be
a sort of blank – a shadow character that the actual player can project
his or her own personality into.

To start creating a PC, all you need to do is write a
description:

```
The description of the player is "In the absence of a mirror, you're
not quite sure what you look like today."
```


In games that are puzzle-oriented rather than people-oriented, that
may be all you need to do. Depending on the character you’ve chosen,
though, you may want to write non-standard messages for situations in
which the PC either does something, or doesn’t. For instance, your PC
might be very timid. In that case, the PC would naturally hesitate to do
certain things that another PC might have no trouble doing:

```
Instead of taking the spider, say "You can't bring yourself even to
get near it."
```


At the other extreme, the PC might be rambunctious, ill-mannered, or
just plain evil. He might enjoy breaking things, for instance. This fact
could lead you to write code like this:

```
Some dishes are in the Lab. The dishes can be broken or unbroken. The dishes are unbroken. The printed name of the dishes is "[if broken]broken [end if]dishes". Understand "broken" as the dishes when the dishes are broken.

Instead of attacking the dishes:
	if the dishes are broken:
		say "You already took care of that little chore.";
	otherwise:
		now the dishes are broken;
		say "You smash the dishes with gusto!"
```


The point of this code is to respond to the command BREAK THE DISHES
with the line, “You smash the dishes with gusto!” Customizing Inform’s
standard outputs is a simple way of giving a specific character to the
PC.

In the early days of interactive fiction, a number of games were
released in which the PC changed identity during the course of the game
– essentially, switching from one body to another. This isn’t done too
often anymore, but if you want to do it, it isn’t difficult. All you
need is a couple of lines of code. In the silly little example below,
we’ll use pressing a button to cause the PC to swap bodies with an NPC.
In a real game, you might use a magical device of some sort, or have the
PC wake up from a dream and discover that she’s really someone else.

```
The Test Lab is a room. "Many devious tests are conducted here."

Bingo is an animal in the Lab. The description is "[if the player is Bingo]You are[otherwise]Bingo is[end if] a peppy-looking cocker spaniel."

Bob is a man in the Lab. The description is "[if the player is Bob]You are[otherwise]Bob is[end if] a heavyset, muscular man."

The player is Bob.

Linda is a woman in the Lab. The description is "[if the player is Linda]You are[otherwise]Linda is[end if] a sultry and curvaceous beauty."

The red button is in the Lab.

Instead of pushing the red button:
	if the player is Bob:
		now the player is Linda;
		say "A strange tingly feeling overtakes you. You feel much more feminine than before.";
	otherwise if the player is Linda:
		now the player is Bingo;
		say "Your head spins. When you recover, things seem to have changed. The world is larger, and you're covered with fur.";
	otherwise:
		now the player is Bob;
		say "You feel odd for a moment Yes, you're human again, and muscular, and male."
```


In a real game, many other messages and rules would have to test
whether the player is Bob, Linda, or Bingo, and change the results of
the player’s commands based on the PC’s identity.

## Creating an NPC

Creating a new non-player character is easy. Assuming we’ve created a
room called the Billiard Room, we can then write:

```
Troy is a man in the Billiard Room. The description is “Troy looks
devilishly handsome in his tuxedo, but you’re not sure you trust him.”
Troy is wearing a tuxedo.
```


The assertion, “Troy is wearing a tuxedo” both creates an object (the
tuxedo) and lets Inform know that the tuxedo is wearable. (If you
actually want the player to wear the tuxedo at some point in the story,
you’ll have to write some code for getting it away from Troy. By
default, characters won’t let go of things they’re wearing or
carrying.)

In fact, the sentence “Troy is wearing a tuxedo” lets Inform know
that Troy is a person, because only people and animals can wear things.
By default, an object that you say is wearing something will be male and
a person, not an animal. So we can delete the words “a man” in the code
above and get exactly the same result. I suggest always saying that an
NPC is a man or a woman, however, because if you should later change
your mind about having the NPC wear something and delete the sentence
about the tuxedo, the NPC will no longer be a man, just a thing.

If you use this code in a game, you’ll find that when the player
enters the billiard room, the game reports, “You can see Troy here.” As
you’ll recall from Chapter 3, we can improve the output by giving the
Troy object an initial appearance*.* The initial appearance is
formatted exactly like a room description – it appears immediately after
we create Troy, and is written as a double-quoted sentence that stands
by itself. The sentence below that begins, “Troy is leaning
nonchalantly” is an initial appearance.

```
Troy is a man in the Billiard Room. “Troy is leaning nonchalantly
against a corner of the billiard table, pretending not to notice you.”
The description is “Troy looks devilishly handsome in his tuxedo, but
you’re not sure you trust him.” Troy is wearing a tuxedo.
```


Now, when the player enters the billiard room, the room description
will include, instead of the boring line “You can see Troy here,” the
much more colorful line, “Troy is leaning nonchalantly against a corner
of the billiard table, pretending not to notice you.” I’d recommend
always giving an NPC an initial appearance.

At present, Troy doesn’t do much. But even at this stage, Inform
understands that a person is different from most other types of objects.
Here’s a transcript of what can happen in the billiard room with no more
code for Troy than what we’ve written above:

{::options parse_block_html="false" /}
<div class="game-output">
<div class="command"><span class="prompt">&gt;</span>kiss troy</div>
<p>Troy might not like that.</p>
<div class="command"><span class="prompt">&gt;</span>kiss tuxedo</div>
<p>You can only do that to something animate.</p>
<div class="command"><span class="prompt">&gt;</span>take troy</div>
<p>I don't suppose Troy would care for that.</p>
<div class="command"><span class="prompt">&gt;</span>take tuxedo</div>
<p>That seems to belong to Troy.</p>

</div>
{::options parse_block_html="false" /}


As you can see, Inform automatically understands that kissing is
something that the player character can do to people (or to animals),
but not to inanimate objects. If we try to take a person, the default
error message prevents it – and if we try to take something that a
person is wearing or carrying, we get a different error message.

Incidentally, if you need the player to be able to kiss an inanimate
object – perhaps you’ve created the Pope as a character, and the player
is expected to kiss the Pope’s ring – you’ll find that a simple Instead
rule won’t do the job. A Before rule won’t work either. This is because
the Inform library defines the kissing action more or less like
this:

```
Understand “kiss [someone]” as kissing.
```


The grammar token “[someone]” won’t match an inanimate object; it
will only match a person. So an Instead or Before rule will never have a
chance to get into the act: the command KISS RING will be rejected by
the game’s parser. The same thing happens, by the way, with the GIVE TO
and SHOW TO actions, though those are less likely to cause problems,
because it’s hard to think of a reason why you would want the player to
be able to show or give something to an inanimate object!

We’ll borrow a bit from Chapter 4 of the *Handbook*,
“Actions,” and show how to make it possible to kiss something inanimate.
We don’t need to define a separate kissing action for inanimate things –
all we need to do is add a grammar line and define a default “you can’t
do that” message:

```
Understand "kiss [something]" as kissing.

Instead of kissing something which is not a person:
	say "[The noun] [don't] look very sanitary."
```


Now we can write an instead rule that will allow the player to pay
osculatory obeisance to Troy’s tuxedo:

```
Instead of kissing the tuxedo:
	say "Troy graciously allows you to kiss his tuxedo."
```


The distinction between “[someone]” and “[something]” is worth
mentioning because it allows us to write new actions that will also
apply only to people. For instance, we might want the player to be able
to flatter other characters. Causing the flattery to affect the
character would take a bit more code, but we can create a basic
flattering action like this:

```
Flattering is an action applying to one thing. Understand "flatter [someone]" and "praise [someone]" as flattering.

Check flattering:
		say "[The noun] blushes modestly."

Instead of flattering Troy:
	say "Troy grins at you. 'Well, sure. Anything nice you say about me, I gotta believe you mean it.'"
```


Now the player can flatter any character in the game, thereby
producing the response in the Check rule above. But flattering Troy will
produce a different response, and the parser won’t let the player
flatter inanimate objects. Care is required when writing default
responses, however, because an animal will match the grammar token
“[someone]”. If you’ve got a talking tortoise in your game, you don’t
want the tortoise blushing modestly when flattered!

If you have several male characters in your game, you can handle this
for all of them at once by writing:

```
Understand "man" as a man.
```


<div class="sidebar">

### “Man” & “Woman”

If you create an NPC by saying, for instance, “Troy is a man,” the
parser won’t understand the word “man” as referring to Troy. This is
because the name of a kind is not understood as referring to specific
objects of that kind unless you say it is. You have to add the
vocabulary by hand:

```
Troy is a man in the Billiard Room. Understand "man" as Troy.
```


</div>


## Mr. & Mrs.

In the U.S., we always put a period after abbreviations like Mr.,
Mrs., Ms., and Dr. In Britain no periods are used. But even if Graham
Nelson weren’t British, the period has some uses in Inform that would
make it tricky to handle those abbreviations.

In source text, Inform understands the period as being the end of a
sentence. So you can’t create a character this way:

```
Mrs. Smith is a woman in the drawing room. [Error!]
```


Inform will think “Mrs” is a separate sentence – a sentence that
makes no sense. The solution is to leave out the period when creating
Mrs. Smith:

```
Mrs Smith is a woman in the Drawing Room. "Mrs. Smith is a stout
woman of mature years." Understand "stout" and "woman" as Mrs Smith.
```


You can refer to her as “Mrs. Smith” in the description, or in any
other output text that you write, but as far as Inform is concerned,
she’s Mrs Smith. To fix this, we need a special rule:

```
Rule for printing the name of Mrs Smith: say "Mrs. Smith".
```


One problem remains: If the player types X MRS. SMITH, the parser
won’t know what the player means. Inform won’t allow periods to be used
in Understand text, so we can’t do this:

```
Understand "stout", "woman", and "Mrs." as Mrs Smith. [Error!]
```


Also, if the player types a command that includes a period, the
parser will understand it as two separate commands. For example, the
player can move quickly from room to room (assuming she knows the route)
like this:

{::options parse_block_html="false" /}
<div class="game-output">
<div class="command"><span class="prompt">&gt;</span>n. e. n. nw</div>

</div>
{::options parse_block_html="false" /}


As far as the parser is concerned, those are four separate commands.
This is a handy feature found in most modern IF interpreters. In the
example above, X MRS. SMITH would produce the description of an object
whose name includes the word “Mrs”, because the parser would understand
the first command as X MRS – but SMITH would look to the parser like a
separate command, one that is not likely to be understood. To prevent
this, we have to use an advanced feature of Inform – the “after reading
a command” activity. As soon as the player hits the Return/Enter key to
issue a command, we’re going to look for an input that matches “MRS.”
and replace it with “MRS” before the parser gets a chance to process it.
While we’re at it, we’ll fix the other common abbreviations too:

```
After reading a command:
	let T be text;
	let T be the player's command;
	replace the regular expression "mrs\." in T with "mrs";
	replace the regular expression "mr\." in T with "mr";
	replace the regular expression "ms\." in T with "ms";
	replace the regular expression "dr\." in T with "dr";
	change the text of the player's command to T.
```


I’m not going to try to explain every line in that code, because
regular expressions are an advanced topic, not something we’ll explore
in detail in the *Handbook*. If you’re curious, you can learn
more by reading [WI Chapter 20: Advanced Text](../WI_20.html). If you don’t have the patience for that,
just copy the code above exactly, and it will do the job. (If you’re
retyping it, don’t skip the backslash characters before the periods, or
skip the hard-to-see periods themselves.)

[Punctuation Removal by Emily Short](https://github.com/ganelson/inform/blob/master/inform7/Internal/Extensions/Emily%20Short/Punctuation%20Removal.i7x) is an extension providing
simple way of getting rid of the periods in the player’s input. This
extension, which is bundled with Inform, allows us to skip typing the
messy code above, and simply write:

```
Include Punctuation Removal by Emily Short.

After reading a command:
	resolve punctuated titles.
```


Punctuation Removal can do several other useful tricks. You’ll find
it in the Extensions tab in the IDE.

## Conversations, Part I: talk to

The easiest way to let your
players talk to NPCs is by creating a “talk to” action. Here’s a code
sample that will produce a simple conversation:

```
Talking to is an action applying to one visible thing. Understand "talk to [someone]" or “converse with [someone]” as talking to.

Check talking to: say "[The noun] doesn't reply."

Instead of talking to Troy:
	say "[one of]'Hi, there,' you say confidently.[paragraph break]'What's happening?' he replies casually.[or]'I've been meaning to ask you about that tuxedo,' you comment. 'Where did you get it?'[paragraph break]'My tailor is quite exclusive,' Troy replies, inspecting his cuff. 'He would never consent to clothe riffraff like you.'[or]'You really are a stuck-up snob, aren't you?' you say hotly.[paragraph break]Troy laughs heartily. 'I was just yanking your chain. I bought it at Macy's for $60 at a clearance sale. I'll give it to you if you like.'[or]You decide against talking any further with Troy right now.[stopping]".
```


The most interesting thing about this code is what happens in the
long “say” block. This is set up to give Inform some alternative
outputs. The structure looks like this: “[one
of]…[or]…[or]…[or]…[stopping]”. This structure is covered down
near the bottom of [WI 5.7: Text with random alternatives](../WI_5.html#section_7); also see [Text Insertions](#text-insertions).

When you use this type of code, the player can type TALK TO TROY,
read the first response (up to “[or]”), then type AGAIN (or just G) to
read the second response, and so on. The last response (the one just
before “[stopping]” should always be used to indicate to the player that
there’s nothing further to be gained by trying to talk to the character.
Note also the use of “[paragraph break]” for the outputs that are
separated into paragraphs. The output will look like this:

{::options parse_block_html="false" /}
<div class="game-output">
<div class="command"><span class="prompt">&gt;</span>talk to troy</div>
<p>"Hi, there," you say confidently.</p>
<p>"What's happening?" he replies casually.</p>
<div class="command"><span class="prompt">&gt;</span>g</div>
<p>"I've been meaning to ask you about that tuxedo," you comment. "Where
did you get it?"</p>
<p>"My tailor is quite exclusive," Troy replies, inspecting his cuff.
"He would never consent to clothe riffraff like you."</p>
<div class="command"><span class="prompt">&gt;</span>g</div>
<p>"You really are a stuck-up snob, aren't you?" you say hotly.</p>
<p>Troy laughs heartily. "I was just yanking your chain. I bought it at
Macy's for $60 at a clearance sale. I'll give it to you if you
like."</p>
<div class="command"><span class="prompt">&gt;</span>g</div>
<p>You decide against talking any further with Troy right now.</p>

</div>
{::options parse_block_html="false" /}


The good thing about a talk to conversation system is that it’s easy
to set up. The bad thing is that it’s quite limited. If the player wants
to ask or tell the character about three or four different things that
may be significant to the story, a talk to system may not do the job.
It’s possible to set up a TALK TO system with logic tests in the Instead
rule – tests such as “if the cellar has not been visited” could produce
two different streams of conversation depending on whether the cellar
has been visited. But if the conversation is going to move the story
forward, it’s up to the player to use the AGAIN command several times in
order to make sure the conversation is finished, and then perhaps start
a new conversation later.

Another problem is that if the player should try TALK TO TROY only
twice, go to a different room, return a hundred turns later, and try
TALK TO TROY again, the conversation will continue as if there had been
no interruption. This is not realistic.

One easy way to make TALK TO work more flexibly uses Inform’s scenes
feature (see Chapter 7 of the *Handbook*):

```
Instead of talking to Troy during Cocktail Hour:
```


A different but also handy use for the TALK TO command might be to
have your game print out some suggested topics for conversation. This
use of the TALK TO command doesn’t produce any actual conversation; the
conversation would occur in an ASK ABOUT or TELL ABOUT command, which is
the subject of the next section.

{::options parse_block_html="false" /}
<div class="game-output">
<div class="command"><span class="prompt">&gt;</span>talk to bishop</div>
<p>You could ask the bishop about the crypt, about the impending
eclipse, or about the Uzi he’s carrying.</p>

</div>
{::options parse_block_html="false" /}


This list of possible topics can be fixed, or you can write some code
that will put it together while the game is being played. After the
player has asked about the crypt, for instance, this topic might
disappear from the list of suggested topics, that topic being exhausted.
An extension called [Conversation Suggestions by Eric Eve](https://github.com/i7/extensions/blob/10.1/Eric%20Eve/Conversation%20Suggestions-v6.i7x) will give you a
framework for setting up topic suggestion lists of this sort. (Note that
Conversation Suggestions is not compatible with the simple TALK TO code
suggested above.)

## Conversations, Part II: ask/tell/give/show

Personally, I favor the ask/tell/give/show conversation system.
(Other game authors disagree.) I feel it gives a good compromise between
realism and challenging the player to figure out what’s important and
therefore worth having a conversation about.

This system is based on five commands:

ASK NPC ABOUT X

TELL NPC ABOUT X

SHOW X TO NPC

GIVE X TO NPC

ASK NPC FOR X

The give to, show to, and ask for actions are included in Inform. To
use them in their basic form, all you need to do is write a few Instead
rules. The ask about and tell about actions are included in Inform in a
limited way: You can ask about or tell about topics (which are just
strings of text), but not about objects that exist in the game unless
you set up topics that have the same vocabulary as the objects. We’ll
take a close look at all of these commands, and show ways to make them
more flexible.

The simplest command to add to your game is give to. Continuing the
earlier example game, with Troy in the Billiard Room, we can do
this:

```
The player carries a plum.

In the Billiard Room is a hammer.

Instead of giving the plum to Troy:
	say "Troy inspects the plum carefully, accepts it, and pops it into his mouth.";
	remove the plum from play.

Instead of giving something to Troy:
	say "Troy sneers at you. 'I'm not interested,' he says coldly."
```


If you add this code to your game, you’ll discover a couple of
things. First, Troy will eat the plum, but will sneer at any other gift
you may offer. (And incidentally, Inform knows that “offer” is a synonym
for “give”.) Second, if you try GIVE HAMMER TO TROY, the parser will
cause you to pick up the hammer first before the giving action is
attempted. This is called implicit taking. It’s a handy feature, because
it saves the player a bit of trouble: You don’t need to PICK UP THE
HAMMER first before giving it to Troy. (See [Action Processing
Summary](#action-processing-summary) to learn a
bit more about implicit actions.)

If the implicit taking fails (for instance, if you try to give an NPC
a canary when the canary is in a locked cage), the giving action will
never be attempted. Inform assumes that the PC can only give something
to an NPC while actually holding it.

This makes sense for the giving action (though you’d need to write
some extra code in order to allow the player to give an NPC a poisonous
snake while the snake is curled up inside a cage). But the same
condition applies to the showing action, and here it makes a bit less
sense. What if I want to show an NPC the beautiful sunset? By default,
Inform will try to have the player take the sunset first, and of course
that won’t work.

We can get around this limitation by writing a Before rule (instead
of an Instead rule), like this:

```
Before showing the tuxedo to Troy:
	say "'Yes,' he replies sarcastically. 'I've already noticed that I'm
wearing it.'" instead.
```


Now you can show the tuxedo to Troy without having the parser try to
have you take the tuxedo (which of course Troy won’t let you have).

### Topics of Conversation

Inform’s default handling of ASK ABOUT and TELL ABOUT is good in one
way, but bad in another way. These commands are implemented so as to
handle topics, but they don’t know about objects in the game. Let’s
suppose we want the player to be able to ask Troy about that interesting
tuxedo. Here’s the basic way to do it:

```
Instead of asking Troy about "tuxedo":
	say "'Oh, you've noticed my tuxedo,' he replies. 'I'm rather fond of
it.'"
```


This is fine as far as it goes. The good news is, we can ask Troy
about abstract topics, such as the meaning of life, using exactly the
same syntax. The meaning of life doesn’t have to be an actual object in
our model world. The disadvantage is that the parser will only match the
*exact* word or words in the topic. A quick look at the output
will show why this can be a big problem:

{::options parse_block_html="false" /}
<div class="game-output">
<div class="command"><span class="prompt">&gt;</span>ask troy about tuxedo</div>
<p>"Oh, you've noticed my tuxedo," he replies. "I'm fond of it."</p>
<div class="command"><span class="prompt">&gt;</span>ask troy about the tuxedo</div>
<p>There is no reply.</p>

</div>
{::options parse_block_html="false" /}


The Instead rule above didn’t include “the tuxedo” as a text, and
Inform has no idea that the topic “the tuxedo” is the same as the topic
“tuxedo.” Topics are not handled with the same kind of automatic
intelligence as objects, because it wouldn’t be practical for the parser
to do so.

We can get around this limitation in a couple of ways. First, we can
do it by letting Inform know about all of the ways we think the player
might refer to the tuxedo. But it quickly gets a bit awkward:

```
Understand "tuxedo", "the tuxedo", "his tuxedo", "suit", "the suit",
and "his suit" as "[tuxedo]".

Instead of asking Troy about "[tuxedo]":
	say "'Oh, you've noticed my tuxedo,' he replies. 'I'm rather fond of
it.'"
```


Here we’ve created a new grammar token, “[tuxedo]”, and provided an
understand rule that spells out the words and phrases we want the player
to be able to use. But of course, the careful author will already have
given a vocabulary list to the tuxedo itself:

```
Troy is wearing a tuxedo. The description of the tuxedo is "Troy's
tuxedo is a handsome bit of custom tailoring." Understand "Troy's",
"handsome", "custom", "tailoring", "suit", and "attire" as the
tuxedo.
```


Wouldn’t it be nice if we could use that same vocabulary list while
asking or telling Troy about the tuxedo? Inform lets us do this, and
with only a bit more work. We need to create two new actions, quizzing
it about and informing it about. These will use the same command words
(ask and tell) as Inform’s built-in actions, but we’ll set them up to
respond to “[something]”, that is, an in-game object, instead of an
abstract topic.

```
Quizzing it about is an action applying to two things. Understand "ask [someone] about [something]" and "quiz [someone] about [something]" as quizzing it about.

Check quizzing it about:
	say "[The noun] shrugs unhelpfully."

Informing it about is an action applying to two things. Understand "tell [someone] about [something]" and "inform [someone] about [something]" as informing it about.

Check informing it about:
	say "'That's interesting,' [the noun] says, stifling a yawn."

Instead of quizzing Troy about the tuxedo:
	say "'Oh, you've noticed my tuxedo,' he replies. 'I'm rather fond of it.'"
```


Notice that we’ve changed the Instead rule so that it now applies to
the quizzing it about action, not to the built-in asking it about
action. Now the player can ask and tell any character about any object
in the model world, and use or not use THE in the input.

But there’s still one big limitation we have to be aware of: The
grammar token “[something]” will only match things that are visible in
the room – that is, objects that are in scope. If we want to be able to
ask and tell characters about objects that are not present, we need to
change “[something]” in the grammar for our new actions to “[any
thing]”. We also need to change the definitions of our actions so that
instead of applying to two things, they apply to one thing and one
visible thing.

The reason for the latter change may not be obvious, but if you try
editing your code to refer to “[any thing]” but don’t change “thing” to
“visible thing”, you’ll see that the action doesn’t work properly.
**Important concept:** Technically, “a thing” is shorthand
for “a currently visible, touchable thing”. That’s what you’ll be typing
most often, so Inform lets you save a little typing. But when you say
“visible thing,” Inform understands that you’re referring to something
that’s visible somewhere or other in the world, whether or not it’s
touchable. This may seem backwards, because – well, it *is*
backwards.

Here are the final versions of our new actions:

```
Quizzing it about is an action applying to one thing and one visible thing.
Understand "ask [someone] about [any thing]" and "quiz [someone] about [any thing]" as
quizzing it about.

Informing it about is an action applying to one thing and one visible
thing. Understand "tell [someone] about [any thing]" and "inform
[someone] about [any thing]" as informing it about.
```


Using this code, we can let the player ask characters about any
object in the model world. We can also create, if we like, offstage
things that can be used for conversation. These things don’t need to be
anywhere in the model world, and they don’t need any properties other
than their vocabulary:

```
Weather is a thing. Understand "clouds", "rain", and "wind" as
weather.
```


But the idea of talking to an NPC about something that’s not in scope
raises a new complication: What if the NPC has never seen the object and
thus knows nothing about it? For that matter, what if the player
character has never seen the object (or at least, not in this particular
run-through of your game) and thus doesn’t officially know that it
exists? To deal with these questions, we need a way to track characters’
  knowledge.

Fortunately, there’s already an extension package that does some of
the heavy lifting for us. Now that you’ve learned the basics of how to
create an ask/tell/give/show conversation system, you can forget about
the details unless you happen to need them for some reason. Download and install
[Conversation Responses by Eric Eve](https://github.com/i7/extensions/blob/10.1/Eric%20Eve/Conversation%20Responses-v7.i7x). This extension provides a
simpler way to write conversation topics. It also lets you write
greetings and farewells.

I also like [Eric Eve’s Conversational Defaults](https://github.com/i7/extensions/blob/10.1/Eric%20Eve/Conversational%20Defaults-v3.i7x) (which requires
[Conversation Framework by Eric Eve](https://github.com/i7/extensions/blob/10.1/Eric%20Eve/Conversation%20Framework-v12.i7x), so you’ll need to download and install that too,
along with [Epistemology by Eric Eve](https://github.com/ganelson/inform/blob/master/inform7/Internal/Extensions/Eric%20Eve/Epistemology.i7x), which tracks what the player
character knows about). Conversational Defaults makes it easier to set
up default responses, which will be printed out in the game when you
haven’t written a response for a specific ask or tell action. With only
a little effort, you can use Conversational Defaults to make your
characters seem somewhat more lifelike than if the player only
encountered the standard line, “There is no reply.” With Conversational
Defaults, we can give an NPC a bunch of possible outputs when he or she
doesn’t have a real response, and instruct Inform to select a response
at random. Here’s a short sample game that shows how to do this:

```
Include Conversational Defaults by Eric Eve.

The Test Lab is a room. The description is "Many devious tests are conducted here."

The zombie is a man in the Lab. "There's a dead guy sort of standing here. A zombie, from the look of him." The description is "The zombie looks really ill. Really, really ill." Understand "dead", "guy", "man", and "ill" as the zombie.

default ask-tell response for the zombie:
	say "[one of]The zombie shrugs minimally[or]The zombie scratches his cheek and grunts unintelligibly[or]'I can't remember hardly anything,' the zombie says[or]The zombie only leers at you menacingly for a moment before sliding back into his usual morose lethargy[at random]."
```


The effect we’re creating above – having the zombie give a variety of
different “non-responses” when asked or told about something for which
the author hasn’t written a real response – goes a long way toward
  making an NPC seem a bit more real.

If your story needs a lot of conversation, you might also want to
consider the extension [Threaded Conversation by Chris Conley](https://github.com/i7/extensions/blob/10.1/Chris%20Conley/Threaded%20Conversation-v9.i7x). This is a
complex and sophisticated package based on earlier work by Emily Short.
Among other things, it provides a method for the author to suggest
topics of conversation to the player during the story, in a smooth and
context-sensitive way. For instance, the story might suggest, “You could
ask Dave about the lighthouse or the police van.” After the player has
asked Dave about the lighthouse, it would disappear from the
suggestions, leaving only the police van – unless some new topic had
been revealed by Dave’s reply about the lighthouse, in which case the
next conversation prompt might be, “You could ask about the police van
or the flying reptiles.”

## Conversations, Part III: Character Knowledge

During the course of a game, an NPC might learn something, and what
the NPC knows might change how he or she responds during a conversation.
For instance, let’s suppose the PC has witnessed Aunt Mary’s house
burning down, and is now in conversation (in a different location) with
Uncle Jack. Uncle Jack won’t know about the fire until the player tells
him – so the command ASK JACK ABOUT MARY might need two different
outputs, depending on whether or not Uncle Jack knows that Aunt Mary is
now without a home.

[Epistemology by Eric Eve](https://github.com/ganelson/inform/blob/master/inform7/Internal/Extensions/Eric%20Eve/Epistemology.i7x) won’t take care of this
for us, because it’s intended to track what the PC knows, not what an
NPC knows. In this example, though, we’re going to use Conversation
Responses by Eric Eve. Conversation Responses includes Epistemology,
which is convenient for this example, because the player can’t ASK JACK
ABOUT MARY unless the player has previously seen or is familiar with the
Aunt Mary object. Both the “seen” and “familiar” properties are defined
in Epistemology.

```
Include Conversation Responses by Eric Eve.

Aunt Mary is a woman. Aunt Mary is familiar.

The fire is a thing. The fire is familiar. Understand "blaze" and "conflagration" as the fire.

The Living Room is a room.

Uncle Jack is a man in the Living Room.

Jack-knows-about-fire is a truth state that varies. Jack-knows-about-fire is false.

Response of Jack when asked about the fire:
	if Jack-knows-about-fire is false:
		say "'Have you heard about the fire?' you ask.[paragraph break]'My goodness, no!' he replies. 'Tell me about it!'";
	otherwise:
		say "'I only know what you told me,' he says."

Response of Jack when told about the fire:
	if Jack-knows-about-fire is false:
		say "'I saw Aunt Mary's house burn down,' you tell Uncle Jack.[paragraph break]'Oh, no!' he cries. 'All those lovely antiques, burnt to a crisp!'";
		now Jack-knows-about-fire is true;
	otherwise:
		say "'I already told you about the fire, didn't I?' you say.[paragraph break]'Yes, yes,' Uncle Jack says, shaking his head sadly."

Response of Jack when asked-or-told about Mary:
	if Jack-knows-about-fire is true:
		say "'What do you suppose will happen to Aunt Mary now?' you ask.[paragraph break]'I guess she'll have to move in with her daughter,' Uncle Jack replies.";
	otherwise:
		say "'Isn't it too bad about Aunt Mary?' you comment.[paragraph break]'My goodness,' Jack exclaims. 'Did something happen?'[paragraph break]'Yes, her house burnt down,' you tell him.";
		now Jack-knows-about-fire is true.
```


In this example I’ve created Jack-knows-about-fire as a truth state
that varies. In a game where the software needs to keep track of an
NPC’s knowledge on a variety of subjects, keeping the data in a table
(see [Tables](#tables)) might be easier.

If you study this code for a minute, the way it works should become
clear. The player can ask or tell Jack about the fire. The player can
either ask or tell Jack about Mary. These conversations test whether
Jack-knows-about-fire is true. If it’s false, Jack’s response is
different. If the player tries asking Jack about the fire before Jack
knows about it, Jack will ask for more information.

## Conversations, Part IV: Menu-Based Conversation

In a menu-based conversation, the player who starts talking with an
NPC is presented with a menu of options, and selects one of the
responses by number. The output might look something like this:

{::options parse_block_html="false" /}
<div class="game-output">
<div class="command"><span class="prompt">&gt;</span>talk to madelyn</div>
<p>You could:</p>
<p>[1] compliment Madelyn on her hair.</p>
<p>[2] complain that the gunfire in the street kept you awake all
night.</p>
<p>[3] ask Madelyn why Uncle Jack was sent to prison.</p>
<p>[4] say goodbye.</p>
<div class="command"><span class="prompt">&gt;</span>1</div>
<p>“You have really lovely hair,” you tell Madelyn.</p>
<p>“Do you like it?” she replies, patting a stray strand into place.
“I’m not sure avocado green is really a good color on me.”</p>

</div>
{::options parse_block_html="false" /}


By typing a “1” at the prompt, the player selects the first item in
the conversation menu. What usually happens is that after the output of
item 1 is printed, the menu comes back again, but now with item 1
removed. Eventually, there will be nothing left in the menu except “say
goodbye.” The player will select that item, read the output, and the
conversation is finished.

One advantage of this type of conversation system is that it can read
in a more realistic way than bare commands like TELL MADELYN ABOUT HAIR
and ASK MADELYN ABOUT UNCLE JACK. Another advantage is that the player
is automatically directed toward topics of conversation that may be
interesting or important to the story. But there are two problems.
First, setting up this type of conversation system is not quite as easy
as creating an ask/tell system. Second, the player will most likely just
go through all of the possible topics one by one to see what they say.
This process is called “the lawnmower effect,” because it turns the
game-play into a rather boring mechanical process of mowing down
everything on the menu.

If you look in [RB 7.8: Saying Complicated Things](../RB_7.html#section_8), you’ll find several examples of
conversational systems. [Example 282: Sweeney](../examples/sweeney.html) provides a hybrid system
in which the player can ask or tell about topics, but will sometimes be
prompted with a numbered list of items. The Recipe Book doesn’t give an
example of a full menu-based conversation system, reporting that “they
can be long-winded to set up, and therefore none are exemplified here,
but several have been released as extensions for Inform.” [Quip-Based Conversation by Michael Martin](https://github.com/i7/extensions/blob/10.1/Michael%20Martin/Quip-Based%20Conversation-v5.i7x) is an example of this approach.

## Giving Orders to Characters

The standard command that players can use to give orders to NPCs is
in the form BOB, EAT THE PANCAKE. The NPC’s name is what grammarians
call a “noun of address,” and is followed by a comma. If you want your
game to respond to the alternate forms ASK BOB TO EAT THE PANCAKE and
TELL BOB TO EAT THE PANCAKE, one easy way to do it is with an “after
reading a command” rule. This type of rule intercepts the player’s input
before it reaches the parser. You can change the player’s input in
whatever way you like. This could be a sneaky way of creating an
infuriatingly difficult puzzle, but here we’ll use it in a more friendly
way:

```
After reading a command:
	let T be text;
	let T be the player's command;
	replace the regular expression "tell bob to" in T with "bob,";
	replace the regular expression "ask bob to" in T with "bob,";
	change the text of the player's command to T.
```


The main thing to be aware of here is that if your NPC can be
referred to as “Bob”, “Uncle Bob”, “Uncle”, or “man”, the After Reading
a Command rule needs to process *all* of those possible inputs
separately, because the parser hasn’t yet had a chance to figure out
what object the player’s command is referring to. The words “man” and
“woman” will be especially sticky, because you might have several
different NPCs in your game that can be referred to as “man” or
“woman”.

Inform won’t let you rewrite the rule so that it reads “After reading
a command in the presence of Bob”. But you can do it this way:

```
After reading a command:
	let T be text;
	let T be the player's command;
	if Bob is in the location:
		replace the regular expression "tell bob to" in T with "bob,";
		replace the regular expression "ask bob to" in T with "bob,";
		replace the regular expression "tell man to" in T with "man,";
		[…and so on for any other words that can refer to Bob…]
	change the text of the player's command to T.
```


Now the player can give orders to an NPC using a variety of normal
phrases. But there’s a better way, which was suggested by Emily Short.
This uses Inform’s ability to match regular expressions – frankly not a
topic that belongs in a handbook for new authors. (If you’re curious,
have a look at [WI 20.6 Regular expression matching](../WI_20.html#section_6). The code below will handle giving orders
to all of the characters in your game:

```
After reading a command: 
	let N be  text; 
	let N be the player's command; 
	replace the regular expression "\b(ask|tell|order) (.+?) to (.+)" in N with "\2, \3"; 
	change the text of the player's command to N. 
```


But by default, NPCs will refuse to follow orders. If you want an NPC
to obey the player, you need to write a **persuasion
rule**, as explained in [WI 12.4: Persuasion](../WI_12.html#section_4). A persuasion rule can be as specific or
as broad as you like – you can have all NPCs obey orders, or only have
one NPC obey one specific order. Here’s how to do it with two specific
actions. We’re going to allow Uncle Jack to take the jewels or give them
to the player:

```
Persuasion rule for asking Uncle Jack to try taking the jewels:
	persuasion succeeds.
Persuasion rule for asking Uncle Jack to try giving the jewels to the player:
	persuasion succeeds.

Instead of Uncle Jack giving the jewels to the player:
	now the player carries the jewels;
	say "Jack hands you the jewels.";
	rule succeeds.
```


This code assumes that the jewels are in scope. (Perhaps Uncle Jack
is already carrying them.) If you need an NPC to give the player
something that has only been talked about, but that isn’t in the room at
the moment, you have a slightly more complex problem. The easy way to
deal with this is to have the NPC carry the object, but make it a
concealed possession, as explained in [WI 3.24 Concealment](../WI_3.html#section_24):

```
Troy is a man in the Billiard Room. Troy carries a banana.

Rule for deciding the concealed possessions of Troy: if the particular possession is the banana, yes; otherwise no.

Persuasion rule for asking Troy to try giving the banana to the player:
	persuasion succeeds.

Instead of Troy giving the banana to the player:
	say "Troy gives you the banana.";
	now the player carries the banana;
	rule succeeds.
```


When the banana is concealed, the player won’t be able to X BANANA,
but the banana will still be in scope, so TROY, GIVE ME THE BANANA will
work as expected.

## Giving Orders that Involve Going Elsewhere

At times, you might want the player to be able to give an NPC an
order that requires going somewhere else and doing something there. The
basic difficulty in this case is, in effect, that once the NPC has gone
somewhere else, he or she can’t “hear” the player character. A secondary
difficulty, which will arise once we solve the first one, is that when
the NPC is carrying out an action in a different location, the parser
will report it to the player, even though the NPC is invisible. The
solution to the latter requires the extension called [Scope Control by
Ron Newcomb](https://github.com/i7/extensions/blob/10.1/Ron%20Newcomb/Scope%20Control-v2.i7x). (Ron also contributed to the development of this
example.)

Here’s a simple game in which the player can order Jeeves the butler
to go somewhere else and do something – specifically, go north, get the
cheese, and then go south again.

```
Include Scope Control by Ron Newcomb.

The Dining Room is a room. The Kitchen is north of the Dining Room. 
Jeeves is a man in the Dining Room. There is a cheese in the Kitchen. 

A persuasion rule for asking someone to try doing something: 
	persuasion succeeds. 

The block giving rule is not listed in the check giving it to rules. 

The subject is a person that varies. 

Before asking someone to try doing something:
	now the subject is the person asked. 

Before reading a command: now the subject is the player. 

After deciding the scope of the player while parsing for persuasion: 
	place the subject in scope. 

Unsuccessful attempt by someone doing something when the location of the actor is not the location: 
	do nothing. 

Before answering someone that something when the location of the noun is not the location, stop the action. 

Test me with "Jeeves, n then get cheese then s then give me the cheese". 
```


In a real game, we probably wouldn’t want to use such a sweeping
persuasion rule. The variable called “the subject” is changed to Jeeves
when the player gives Jeeves an order. Then the subject is placed in
scope. As a result, Jeeves will “hear” all of the orders even when he’s
in a different room. The two last rules (Unsuccessful attempt and Before
answering someone) prevent Jeeves’ actions from being reported if he’s
in a different room.

## Moving Characters Around

People don’t always stay in one place. In the real world, people do
sometimes stay put for long periods of time – for instance, the
librarian sitting behind her desk, who won’t leave for hours. Other
times, though, people move from one place to another. There are several
ways to imitate that behavior in interactive fiction.

A classic effect in the early days of IF was to have an NPC wander at
random around the map. This isn’t very realistic, because people usually
have reasons for going places, but at least it adds a little variety to
the game. An example of an NPC who might be expected to behave this way
would be a butler moving from room to room in a large mansion.

In the simple example below, we’ll create a square 3x3 grid of rooms
and then create an NPC who wanders at random. If you can’t tell from the
code what the map will look like, switch to the Index World tab after
  compiling the game.

```

A boring room is a kind of room. The description of a boring room is usually "Not much to see or do here."

Room 1 is a boring room. Room 2 is a boring room. Room 3 is a boring room. Room 4 is a boring room. Room 5 is a boring room. Room 6 is a boring room. Room 7 is a boring room. Room 8 is a boring room. Room 9 is a boring room.

Room 4 is south of room 1. Room 7 is south of room 4.

Room 2 is east of room 1. Room 3 is east of Room 2.

Room 5 is east of Room 4 and south of Room 2. Room 6 is east of Room 5 and south of Room 3. Room 8 is east of Room 7 and south of Room 5. Room 9 is east of Room 8 and south of Room 6.

Bob is a man in Room 3.

Every turn:
	let D be a random direction;
	try Bob going D.
```


As a result of the Every Turn rule, Bob will try going some direction
or other in every turn, but if no room exists in the random direction,
the “try” statement will fail. Bob will stay where he is. If the player
is in a room when Bob arrives, the game will report the fact. Likewise,
if Bob and the player are in the same room, the game will report when
Bob succeeds in leaving. The output might look like this:

{::options parse_block_html="false" /}
<div class="game-output">
<p class="bold">Room 5</p>
<p>You can see Bob here.</p>
<p>Bob goes south.</p>
<div class="command"><span class="prompt">&gt;</span>z</div>
<p>Time passes.</p>
<div class="command"><span class="prompt">&gt;</span>z</div>
<p>Time passes.</p>
<p>Bob arrives from the south.</p>

</div>
{::options parse_block_html="false" /}


This is okay as far as it goes, but the outputs (“Bob goes south” and
“Bob arrives from the south”) are not very interesting. If you turn on
rules reporting using the RULES command, you’ll learn that these outputs
are coming from the “describe room gone into rule.” You can’t find this
rule by searching *Writing with Inform*. Nor is it visible in the
Index Rules area. However, you can find it by going to File/Open
Extension/Graham Nelson/Standard Rules. It’s more than 60 lines
long.

Replacing the entire rule would require quite a bit of tinkering; I
wouldn’t want to try it, because I’d probably end up adding bugs. If all
we really want is to make your characters’ arrivals and departures a
little more interesting, here’s a simple way to do it. Note that this
doesn’t handle complex situations, such as when the NPC is in a
vehicle.

```
Report someone (called the traveler) going:
	if the traveler is in the location:
		say "[one of]Here comes old [actor] again[or][The actor] saunters up to you[or]The ominous creaking of floorboards announces the arrival of [the actor][at random]." instead;
	otherwise:
		say "[one of]At the sound of a thin scream in the distance, [the actor] dashes away[or]You suddenly notice that [the actor] has wandered off somewhere[or][The actor] evaporates in a thin puff of acrid smoke[at random]." instead.
```


This code doesn’t tell the player which direction the character
arrives from or departs to; that would require more tinkering. But now
we have a way to add a little variety to the output.

[RB 7.13](../RB_7.html#section_13) provides
several examples of different ways to move NPCs around. Possibly the
most interesting of these is shown in [Example 185, “Latris Theon”](../examples/latris_theon.html).
Inform includes a path-finding algorithm – a built-in procedure that
will allow an NPC to calculate the best route from his or her current
location to any other location. Applying this to the example given
earlier is not difficult: Replace the last two blocks (“Bob is in Room
3” and the Every Turn rule) with the following code:

```
Bob is a man in Room 3. The destination of Bob is Room 3. Persuasion rule for asking Bob to try going vaguely: persuasion succeeds.

Every turn when the destination of Bob is not the location of Bob:
	let the right direction be the best route from the location of Bob to the destination of Bob;
	try Bob going the right direction.

A person has a room called destination.

Understand "go to [any room]" as going vaguely.

Going vaguely is an action applying to one visible thing.

Carry out someone going vaguely: 
    change the destination of the person asked to the noun.

Report someone going vaguely: 
    say "[The person asked] looks amused, but accepts the commission to go to [the noun]."

Carry out going vaguely: 
    say "You're too thoroughly lost."
```


We’ve done a few new things here. First, “A person has a room called
destination.” Since Bob is a person, he now has a destination. Initially
we make his destination Room 3, so he’s happy to stay where he is. He’s
no longer going to wander around at random. Next, we include a
persuasion rule, so that Bob will respond to an order to go vaguely.
(The persuasion rule will cause BOB, GO TO ROOM 7 to work the way we’d
like it to.) The rest of the new code is directly copied from “Latris
Theon.”

Notice also the difference between the two Carry Out rules. One
applies to *someone* going vaguely (in other words, not the
player character), while the other applies to the PC.

[Example 274, “Odyssey”](../examples/odyssey.html) is in the same section of the *Recipe
Book*. This shows how to move an NPC along a route that we’ve
created in advance. The NPC’s travel will be interrupted temporarily if
the player chooses to interact with her. One refinement I’d suggest
adding to this example, if you try it out, would be to define a scene
called Athena Traveling. (See [Scenes](#scenes) and [Chapter 10 of ](../WI_10.html)*Writing with Inform*[, Scenes](../WI_10.html).)
I would then change the Every Turn rule like this:

```
Every turn when Athena Traveling is happening:
	if Athena is active:
```


This will allow you to keep Athena (or whatever NPC you’re using) in
one place until some specific event occurs. For instance, you might do
this:

```
Athena Traveling is a scene. Athena Traveling begins when the player
carries the laurel wreath.
```


Now Athena will stay put (perhaps lurking in her temple) until the
player picks up the laurel wreath. When that happens, she’ll set out on
  her journey.

The extension called [Patrollers by Michael Callaghan](https://github.com/i7/archive/blob/master/Michael%20Callaghan/Patrollers.i7x) provides some
extra tools with which to write NPCs who move from place to place.

## Characters Who Follow the Player

Writing a character who will find the player and then follow the
player around like a faithful puppy is not difficult. [Example 39, “Van
Helsing”](../examples/van_helsing.html) (again from [RB 7.13](../RB_7.html#section_13))
shows how to do it. We can adapt this code slightly to the example above
by getting rid of the code that allows the player to order Bob around,
replacing it with this:

```
Bob is a man in Room 3.

Every turn:
	if the location of Bob is not the location of the player:
		let the way be the best route from the location of Bob to the location of the player;
		try Bob going the way;
	otherwise:
		say "'Hey, I'm bored,' Bob says. 'Let's go for a ramble.'"
```


The same suggestion I gave for the “Odyssey” example (just above)
applies here. You probably don’t want Bob following the player from the
very beginning of the game. To make Bob behave in a way that fits your
story, you would need to define a Scene, and then say “Every turn when
Too-Friendly-Bob is happening”. Then write a sentence that defines when
Too-Friendly-Bob begins.

[Simple Followers by Emily Short](https://github.com/i7/extensions/blob/10.1/Emily%20Short/Simple%20Followers-v7.i7x) provides easy
ways to create NPCs who will follow the player (or other NPCs) and will
start or stop following on command. However, this extension doesn’t work
the other way: it doesn’t let the player follow characters who have left
the room.

## Characters the Player Can Follow

There are at least two ways (and maybe more) to set up a game so that
the player needs to follow another character. First, the NPC may be
standing in the room, saying, “Come on, follow me!” or something of the
sort, in which case the command FOLLOW BOB would likely be implemented
so as to move both the PC and the NPC to whatever room the NPC has in
mind. Second, the NPC may just have left the room, and the player may
now be wanting to follow the NPC to see whither he is bound.

The second situation is trickier than the first. This is because of
the way Inform handles scope. As explained in the [previous discussion of scope](#Ref_scope), the player can normally only refer to objects
that are in the same room (and also visible – an object in a closed
container is invisible, for instance, unless the container is
transparent). If the NPC has left the room, he won’t be in scope, so
FOLLOW BOB will produce the unhelpful output “You can’t see any such
thing.” Well, duh – that was why I wanted to follow him!

[Example 302, “Actaeon”](../examples/actaeon.html) (from [RB 7.13](../RB_7.html#section_13)), shows how to allow the PC to follow an NPC who
has left the room. This example is easy to customize, but it’s worth
including some of the code here to point out a couple of features. We’ll
start with the setup from [Boring Bob](#Ref_boring_bob), in which
Bob is meandering around a featureless grid of nine rooms. This time,
though, we’ll start him in Room 1, so the player can start following him
immediately.

```
Bob is a man in Room 1.

Every turn:
	let current location be the location of Bob;
	let next location be a random room which is adjacent to the current location;
	if Bob is visible, say "Bob saunters off toward [the next location].";
	move Bob tidily to next location;
	if Bob is visible, say "Bob saunters in from [the current location]."

Following is an action applying to one visible thing. Understand "follow [any person]", "chase [any person]", and "pursue [any person]" as following.

A person has a room called last location.

Check following:
	if the noun is the player:
		say "You run around in circles briefly, but there doesn't seem to be much point in that, so you stop." instead;
	if the noun is visible, say "[The noun] is right here." instead;
	if the last location of the noun is not the location, say "It's not clear where [the noun] has gone." instead.

Carry out following:
	let the destination be the location of the noun;
	if the destination is not a room, say "[The noun] has gone where no one can follow." instead;
	let aim be the best route from the location to the destination;
	say "(heading [aim])[line break]";
	try going aim.

To move (pawn - a person) tidily to (target - a room):
	now the last location of the pawn is the holder of the pawn;
	move the pawn to the target.
```


If you look at the Every Turn rule here, or just try it out in a test
game, you’ll find that Bob moves to a new room in every turn. In the
examples earlier in this chapter, Bob would choose a random direction
every turn – but if there was no room in that direction, he wouldn’t
move. The line above, “let next location be a random room which is
adjacent to the current location;” causes Bob to choose a random room
that actually exists, and move to it.

We have to move Bob in a tidy way, or “tidily” (an ugly word, but
useful), so that he’ll keep track of where he was last.

If you comment out the last line in the Check Following rule, the
player will be able to follow Bob even after several turns have elapsed.
The result may turn out to be slightly unrealistic, however, because the
PC won’t necessarily take the route that Bob took. Instead, the PC will
choose the best route to wherever Bob happens to be *now.* If Bob
has traveled around to the other side of the map – if he left heading
south but is now in a room to the north – this code will cause the PC to
go north, which is rather odd, and doesn’t accord well with the meaning
of the word “follow.” That’s probably why the original code in this
example only allows the follow command to be used immediately after the
NPC has left the room. Storing an NPC’s entire route, so as to allow the
player to follow (perhaps by tracking footprints or dropped breadcrumbs)
would be a lot more work, and would probably be unrealistic unless the
NPC is leaving a trail of breadcrumbs, so we’ll leave it as a coding
challenge for advanced Inform authors.

## Stage Business

A character will seem more “alive” if she spontaneously does things
on her own, or seems to. Sometimes the character will do something that
changes the model world (see “Character Actions,” below). But sometimes
we just want to print out a reminder to the player – a message that
doesn’t actually do anything, but that makes the scene seem more lively.
I call these reminder messages “stage business.”

In this example, Janice is the maid. She will seem to do something
without really doing anything:

```
The Living Room is a room. "This fussy old-fashioned living room is filled with heavy furniture."

Janice is a woman in the Living Room. "Janice is busy tidying up." The description is "Janice is wearing a maid's uniform. She's bustling about, doing all sorts of things."

Every turn when the player is in the Living Room:
	if a random chance of 1 in 3 succeeds:
		say "Janice [one of]flicks dust off of the grand piano[or]runs the vacuum cleaner[or]plumps up the cushions on the sofa[or]straightens a painting[or]polishes the mirror above the mantel[at random]."
```


The Every Turn rule will only run when the player is in the room with
Janice. (If Janice were moving around the house, we’d need to change
this rule a bit). About 1/3 of the time, a random message will be
printed indicating that Janice is busy doing her job.

## Character Actions

A good way to make a character seem more alive is for the character
to react in some way when the player does something. This reaction could
range from a simple comment to an explosive act.

Let’s suppose that old Alexander Button seems to be asleep in his
chair. But he isn’t asleep, really. If you pick up the piece of paper on
the table, he’ll snatch it away from you:

```
Alexander Button is a man in the Living Room. "Old Alexander [if Alexander carries the will]eyes you keenly[otherwise]seems to be asleep[end if]." The description is "He must be at least 90[if Alexander carries the will]. He's wide awake, and looking at you in a doubtful way[otherwise]. He seems to be asleep[end if]."

The end table is a scenery supporter in the Living Room.

The will is on the end table. The description is "A legal-looking piece of paper. You can't read what's on it, because it's upside down."

After taking the will:
	now Alexander carries the will;
	say "Alexander's eyes fly open. 'So … snooping, eh?' He snatches the will away from you."
```


To get Alexander to react, we use an After rule. An After rule is a
good idea here, because it allows Inform to do its usual processing of
the TAKE PAPER command. Only if the command succeeds – if it’s possible
for the player to take the will – will Alexander react.

The NPC action above was triggered by a taking action. Sometimes, we
may want a character to react to something he or she sees. For instance,
the character might demand that the player give him an object the player
is carrying. Here’s a short game that shows how this might work:

```
The Dusty Street is a room. "The unpaved street of Tombstone, Arizona, runs east and west here. The Red Dog Saloon is to the north."

The Red Dog Saloon is north of the Dusty Street. "The sour smell of spilled whiskey permeates this rough-hewn room, which is dim after the sunlit glare of the street."

Sheriff Earp is a man in the Red Dog Saloon. "Wyatt Earp is standing at the bar." Understand "Wyatt" as Sheriff Earp. The description is "Earp looks lean and mean. He's wearing a badge."

The player carries a six-gun. Understand "gun" and "revolver" as the six-gun.

Every turn:
	if the player carries the six-gun and Sheriff Earp can see the six-gun:
		say "[one of]'I see you're packin['] a weapon,' the sheriff says. 'Packin['] a weapon in town is illegal. Best you hand it over.'[or]'Well, are you gonna give me that six-gun, or ain't you?' Earp stares at you meaningfully.[stopping]".

Instead of going in the Red Dog Saloon:
	if the player carries the six-gun and Sheriff Earp can see the six-gun:
		say "'Best you not be walkin['] out of here with that firearm,' Earp says. He adjusts his own gunbelt slightly, as if he's thinking he may have to draw down on you.";
	otherwise:
		continue the action.

Instead of giving the six-gun to Sheriff Earp:
	now Sheriff Earp carries the six-gun;
	say "You hand over the gun. 'Thanks,' Earp says. 'You can go now. But don't be startin' any trouble, you hear?'"

Test me with "i/ n / s / give gun to Earp / s / i".
```


In this example, the work is being done by the Every Turn rule and
the Instead Of Going rule. The player can do anything in the saloon (in
a real game, this might include ordering a drink or sitting down to play
poker, actions that would likely cause the sheriff to become more and
more insistent), but can’t leave until he has given the gun to the
sheriff.

## Combat

I’ve never used the extension called Armed by David Ratliff, but a
couple of my students have found it useful. The version on the Inform 7
website doesn’t work with current versions of Inform, as it was written
in 2008. Fixing it is not terribly difficult. The phrase “end the game”
has to be changed to “end the story”, instances of “change … to” have to
be changed to “now … is”, and you may want to fix a misspelled word or
two. The biggest stumbling block is that one of the Check rules in
Armed, called the can’t take it with you rule, uses the word “ignore”.
This feature is no longer supported. I was able to work around the
problem by replacing that rule with this new code:

```
Check an actor taking (this is the new can't take people's possessions rule):
	let the local ceiling be the common ancestor of the actor with the noun;
	let the owner be the not-counting-parts holder of the noun;
	while the owner is not nothing and the owner is not the local ceiling:
		if the owner is a person and the owner is not dead:
			if the actor is the player:
				say "[regarding the noun][Those] [seem] to belong to [the owner]." (A);
			stop the action;
		let the owner be the not-counting-parts holder of the owner;

The new can't take people's possessions rule is listed instead of the can't take people's possessions rule in the check taking rulebook.
```


In case you’re curious, I created this code by copying the original
can’t take people’s possessions rule in Standard Rules and adding the
words “and the owner is not dead” to line 5.

Armed creates several kinds of weapons, allows you to set the maximum
amount of damage that will be inflicted by a weapon, and computes the
health of each character based on the amount of damage they’ve suffered.
If you only want to add some weapons to your game, it might be easier to
do it yourself, because Armed prints out the health of each character
when the character is examined, and the health of the player character
when the player takes inventory. If most of your game doesn’t involve
combat, the printout of characters’ health is likely to be a bit
distracting.

If all you need to do is set up one encounter in which some combat
takes place, here’s some code that will get you started. Note that we
need to create an action called “attacking it with”. Inform’s standard
library includes attacking, but not attacking it with. In the code
below, we’ve set it up so that if the player tries ATTACK THE DUKE
without naming a weapon, we don’t get Inform’s default response,
“Violence isn’t the answer to this one.” Since violence *is* the
answer to this one, it’s important not to confuse the player.

```
The Drawbridge is a room. "Fortunately for you, brave knight, the drawbridge has not been raised. The castle lies before you to the east."

The Castle is east of the Drawbridge.

The Duke is a man in the Drawbridge. "The evil duke stands before you, blocking your way menacingly with a rapier." The description of the duke is "He has an evil glint in his eye."

Instead of going east from the drawbridge when the Duke is in the Drawbridge:
	say "'You shall not pass!' cries the duke."

The player carries a sword and a sofa cushion.

The Duke’s dead body is a thing.

Check attacking the duke:
	say "With your bare fists? Surely you can think of a better way!" instead.

Attacking it with is an action applying to two things and requiring light. Understand "attack [something] with [something]" and "hit [something] with [something]" as attacking it with.

Check attacking it with:
	if the second noun is the sofa cushion:
		say "'Do not mock me thus, vile varlet!' shouts the duke." instead;
	else if the second noun is not carried by the player:
		say "You're not holding [the second noun]." instead.

Report attacking it with:
	say "Your aggressive action has no visible result."

Instead of attacking the duke with the sword:
	if a random chance of 1 in 3 succeeds:
		say "You hack the duke to pieces with the sword!";
		remove the duke from play;
		now the duke’s dead body is in the location;
	otherwise:
		say "The duke parries your clumsy thrust expertly with his rapier."
```


We’re using randomness in the Instead rule above to allow the attack
to succeed sometimes and fail other times. In a real game, you might
want to include a small chance that the duke will kill the player. Since
we may want to do any of three things in our Instead rule, we can’t use
the “if a random chance … succeeds” syntax, since that only allows for a
positive or negative result. Instead, we’ll do it by creating a
temporary variable, X, and assigning it a random value. Replace the
Instead rule above with this one:

```
Instead of attacking the duke with the sword:
	let X be a random number from 1 to 5;
	if X is 1:
		say "You hack the duke to pieces with the sword!";
		remove the duke from play;
		now the duke’s dead body is in the location;
	otherwise if X is 2:
		say "The point of the duke's rapier enters your rib cage.";
		end the game in death;
	otherwise:
		say "The duke parries your clumsy thrust expertly with his rapier."
```


## Moods

Real people can get into a variety of moods – friendly, bored,
hostile, romantic, frightened, twitchy, and so on. The extension Mood
Variations by Emily Short provides an easy way to switch characters from
one mood to another in the course of conversation. It’s meant to be used
with a conversation package such as Eric Eve’s Conversation Framework,
but you don’t need to actually use the features in Conversation
Framework or Conversation Responses if you don’t want to; you just need
to include one of them so that Mood Variations can make use of a
variable called the current interlocutor. Mood Variations is set up to
make it easy to switch a character’s mood in the course of conversation,
using the syntax “[set hostile]” within a quote. This will always set
the mood of the person the player is currently talking to. To change a
character’s mood outside of quotes, you need to write something like,
“now the current mood of Bob is hostile”.

Here’s a short game, which makes not a bit of sense, but may give you
a quick idea of what’s possible if you include Mood Variations. The
“asked-or-told about” syntax is defined in Conversation Responses.
Notice that the first thing we do is define a list of moods. This will
include all of the moods that *any* character can get into in the
game. We don’t create a separate list of moods for each character.

```
Include Conversation Responses by Eric Eve.
Include Mood Variations by Emily Short.

The moods are friendly, neutral, bored, hostile, and frightened. The current mood of a person is usually neutral.

The Test Lab is a room. "Many devious tests are conducted here."

The player carries an apple and a pear.

Susan is a woman in the Lab. Dave is a man in the Lab.

Response of Susan when asked-or-told about the pear:
	if the current mood of Susan is neutral:
		say "[set friendly]'That's quite a pear, there,' Susan replies.";
		now the current mood of Dave is hostile;
	otherwise if the current mood of Susan is friendly:
		say "[set hostile]'I love that you keep asking me that,' she says.";
	otherwise if the current mood of Susan is hostile:
		say "'Do shut up,' Susan snaps."

Response of Dave when asked-or-told about the apple:
	if the current mood of Dave is neutral:
		say "[set bored]'I saw one once, in Eden,' Dave replies.";
	otherwise if the current mood of Dave is bored:
		say "[set hostile]Dave yawns ostentatiously.";
	otherwise if the current mood of Dave is hostile:
		say "'Are you trying to pick a fight?' Dave asks.";
	otherwise:
		say "'Apples, apples…'"
```


## Body Parts

Giving your characters body parts is not always necessary, but if the
character’s description mentions something prominently (Janet’s blue
eyes, the duke’s hawklike nose, or whatever), you can easily use
Inform’s ability to create parts of objects (as discussed in Chapter 3
of this *Handbook*) to make the body parts. In some games, you
might want to give all of your characters body parts. In this case, you
would make the part a kind of thing, like this:

The Living Room is a room.

```
The Living Room is a room.

A nose is a kind of thing. A nose is part of every person. The description of a nose is usually "Seen one nose, seen [']em all."

Susan is a person in the Living Room.
The description of Susan's nose is "It has a cute upward tilt." Understand "cute" as Susan's nose.

The description of your nose is "You can't see much of it, as you're behind it."
```


The only odd thing about this is that you can’t say “The description
of the player’s nose”. Or rather, you can; it will compile; but it won’t
work. Instead, you have to say “your nose”. Inform will understand that
the player can then refer to this object as “my nose”.
