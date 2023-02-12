## Chapter 1: Getting Started   {#chapter-1-getting-started}

So… you’d like to try writing interactive fiction. It looks like fun,
but you’re not sure where to start. Or maybe you’ve already started, and
now you’re getting confused, or you’re not sure how to get the results
you want.

This book will help you make sense of it all. Every chapter (except the
last one, which is sort of a grab bag) is about one specific part of the
writing process.

You don’t need to read the book straight through from top to bottom.
Feel free to jump around, dipping into whatever chapter looks as if it
will have the information you need. If you want to write a story with
lots of characters, for instance, you may want to head straight to
Chapter 5. If you find that you’re having trouble writing things in a
way that Inform understands, you can consult the tips on phrasing and
punctuation in Chapter 9. Some of the discussion in that chapter is
pretty deep, though, so it may not be the best place to start learning.
(That’s why it’s Chapter 9, not Chapter 1.)

Even right here in Chapter 1, there are things you won’t need to think
about yet when you’re just starting out. If you hit something that
doesn’t make sense, feel free to skip it and come back to it later.

Unlike a technical document, which attempts to lay out the features of a
system in an orderly manner, explaining the most basic concepts first in
order to build on them later, the *Inform Handbook* is organized in a
way that attempts to get you started doing useful and interesting things
quickly. To be sure, the opening chapters cover the basics and contain
many cross-references to concepts that will be explained later.
Nonetheless, as early as Chapter 2 you’ll find things like text
substitutions and before, after, and instead rules used in the example
code with no real explanation of what they are or how they work. When
you encounter something in an example that is unfamiliar, you can safely
assume not only that it works, but that it will be explained in a later
chapter.

Whether you read this book or some other manual, or just dive in and
start trying things without bothering to read a manual at all, you’ll
soon learn that writing interactive fiction (“IF” for short) is more
than just creative writing. Creativity and storytelling are definitely
part of the process, but you’ll also be doing a type of *computer
programming*. “Programming” means you’re giving the computer
instructions about what to do. And computers are incredibly picky about
understanding your instructions! As you start writing IF, you’ll find
that a single misspelled word or a missing period at the end of a
sentence can stop the computer dead in its tracks. Later in this chapter
I’ll give you a short list of mistakes that I’ve seen students make.

This book is about how to use the popular Inform 7 programming language
(“I7” for short). There are several other languages in which you can
write interactive fiction, as mentioned in the Foreword. If you’re using
one of them, you’ll find a few general tips in this book that you can
use. In particular, the discussion of [puzzles in Chapter
6](#chapter-6-puzzles) is largely platform-independent. Nonetheless, the
book is mostly about how to use I7.

I feel Inform 7 is an especially good choice for those who are new to
writing IF and also new to computer programming. I7 is designed to make
it as easy as possible to get started. The computer code you’ll be
writing looks very much like plain English, because (barring a few
oddities) it *is* plain English. Having said that, it has to be admitted
that the I7 application (in which you’ll be writing your game) has a
number of facets, which can make it seem intimidatingly complex.

Certain features that experienced may expect, such as single-step
debugging, are not possible with I7. Even so, I7 includes many “power
user” features for game design, so it won’t limit you if you want your
story to include complex things.

As a *caveat,* however, I should add that if you’re thinking you’ll dip
your toes in the ocean of computer programming by writing some
interactive fiction and then later consider moving on to a
general-purpose language like Javascript or C++, Inform 7 would be a
poor choice. Its syntax is quite unlike what you’ll find in most
programming languages, and the programming skills you learn by writing
stories in I7 will be difficult to translate into a form you can use in
any other programming language.

Inform 7 is the successor to Inform 6, which is also a popular language
for writing IF. The two are completely different, even though they were
created by the same person, Graham Nelson, and are both called “Inform.”
In this book, we’ll most often refer to “Inform” and not bother to add
the 7, but all of these references are to Inform 7, not to Inform 6.

It’s important to note that Inform 7 is still being developed. The most
recent version at this writing (spring 2015) is version 6L38. It and its
immediate predecessor, 6L02, are significantly different from earlier
versions. People have been using I7 successfully to write interactive
fiction for close to ten years, but like most other programming
languages, it isn’t officially finished, and may never be. If certain of
the details in this book don’t seem correct when you try them out, it’s
possible that you’re using an earlier or later version of Inform, in
which the features are different. The basic I7 language is pretty well
developed, and probably won’t change too drastically in the future, but
the recent refinements are significant.

In addition to possible changes in the language, the numbering of pages
and Examples in Inform’s built-in Documentation is quite likely to
change. Please note that all of the page and Example numbers given in
the *Handbook* refer to version 6L38.

<div class="addendum">
<div class="add-header">
Addendum
</div>
<div class="add-body" markdown="1">
In December of 2015, version 6M62 was released. It had a high degree of
backwards-compatibility with 6L38, so the Handbook remained applicable.

After a long gap, version 10.1 was released in 2022 (and 6L38 and 6M62
were retroactively labelled 9.2 and 9.3). Inform 7, the language, was
little changed, but much has changed in the overall landscape in the
intervening 7 years. It's my aspiration that this adaptation could
eventually be described as having been updated for 10.1, but for now
it's a mishmash.

<!-- TODO -->

</div>
</div>

### Downloading & Installing   {#downloading-installing}

To get the most current version of Inform, go to the [Inform 7 Downloads
page](inform7.com/downloads/), and select the appropriate version.

Install the program and launch it, as described in the next section.

As you work with Inform, you’ll be creating projects. Each game that you
create is a separate project. It’s a good idea to start by creating a
folder called Inform Projects inside your Documents (Windows: My
Documents) folder. This may be done for you automatically when you
install Inform, or you may need to do it manually. Each time you create
a new project, save it to that folder.

<div class="sidebar" markdown="1">
#### Is It a Game, or Is It a Story?   {#is-it-a-game-or-is-it-a-story}

In *The Inform 7 Handbook*, we’ll refer to an Inform project as either a
“story” or a “game,” without making much of a distinction between the
two words. There are some real differences: Some interactive fiction has
a strong story and very little in the way of game-type fun. Other
interactive fiction is mainly a game, and the story is so weak it might
as well not exist at all.

It’s up to you to decide how to combine story elements with game
elements. For the purposes of this book, the game is a story and the
story is a game. In recent years the designers of Inform have been
leaning toward “story” as a term for what you’ll be producing, but I
still prefer to think of it as a game.

</div>

### The Inform 7 Program   {#the-inform-7-program}

The first time you launch the Inform 7 program, a dialog box will ask
you whether you want to open an existing project or start a new one.
Since you don’t yet have a project to open, select “Start a new
project…”. This will open a box in which you can name your project and
tell Inform where you want to save it. (Use the Inform Projects folder
in your Documents folder. If this folder doesn’t yet exist, it’s a good
idea to create it.)

<div class="image-frame" markdown="1">
![](images/start_a_new_project.jpg)
</div>

When you close this box, the Inform program will open, and you’ll see a
main window with two pages – a left page and a right page. The left page
will be blank except for the name of your new game and the byline (your
name as the author). On the right page you’ll see the Table of Contents
for the Inform Documentation.

What you’re looking at is not Inform itself (though you can think of it
that way if you want to). What you’re looking at is a program that’s
sort of a container for the Inform game programming system. This type of
program is called an Integrated Development Environment, or “IDE” for
short. The Inform IDE has quite a lot of useful features. Before you
start writing your first story, take a quick look around the Inform IDE.
Its most important features are discussed in the next few sections of
this chapter; others are mentioned in [Chapter 10, Advanced
Topics](#chapter-10-advanced-topics).

<div class="image-frame" markdown="1">
![](images/ide_documentation_pane.jpg)
</div>

Normally, you’ll want to keep the text of the story you’re writing
(Inform calls this the “source text,” a term precisely equivalent to the
more familiar term “source code,” which is used in most other
programming languages) in the left-hand page. The right-hand page will
contain various things at various times – the Documentation, the game
itself, error messages, and so on. The IDE will sometimes open new
*panels* automatically within the right-hand page. But in fact you can
display whatever you’d like in either page. If you’re studying two
related pages in the Documentation, for instance, you could have one
open in the left page of the IDE, and the other open in the right page
at the same time. You can even run two instances of the Inform IDE at
the same time, by opening additional project files. This way, you can
keep the Documentation pages open at all times, or copy what you’ve
written from one project to another.

To choose what’s displayed in each page, click on an item in the row of
page headers. (This is displayed across the top of the pages in the
Windows IDE, and vertically along the right edge in the Macintosh IDE.)
Each header opens a different panel*.*

Until you’ve written something in the Source panel and clicked the Go!
button, some of the other panels will be empty. This is normal.

<div class="image-frame" markdown="1">
![](images/help.png)
</div>

Feel free to click on the gray buttons beside the chapter headings in
the Documentation. These triangles open the lists of pages for each
chapter. Read a few pages. If you see things that you don’t understand
(and you will!), please don’t worry about it. Even in Chapter 1 of the
Documentation, some of the information is fairly advanced, and won’t be
useful to you yet. Just take a look and get acquainted with how the
Documentation is set up. To return to the Documentation’s Table of
Contents, click the circle with the arrow, or the Home button above it.

You can click the right-pointing arrow to go to the next page within the
Documentation, or the left arrow to go back one page. You’ll also find a
pair of left/right browser-style buttons near the upper left corner of
the pages, which will move you back and forth among the pages you have
looked at most recently.

In *The Inform 7 Handbook,* references to “the Documentation” are
generally about *Writing with Inform.* The table of contents for
*Writing with Inform* is in the left column of the Documentation pane.
In the right column is the table of contents of *The Inform Recipe
Book.* The *Recipe Book* is an entirely separate manual. Both of them
are well worth reading. They share the same set of Examples. In fact,
some of the pages in these manuals provide only a quick overview of a
topic, an overview that is fleshed out with details in the accompanying
Examples. Study the Examples carefully, and try to figure out what each
section in each Example does. For tips on how to use the Examples, see
[How to Use the Built-In
Documentation](#using-the-built-in-documentation).

#### The Page Headers   {#the-page-headers}

<div class="image-frame" markdown="1">
![](images/page_headers.jpg)
</div>

Across the top of each page, if you’re using the Windows IDE, or
vertically along the edge if you’re using the Macintosh IDE, you’ll see
a series of panel tabs, or headers: Source, Results, Index, Skein,
Transcript, Story, Documentation, Extensions, and Settings. Below these
main headers a variety of subheads (such as Examples and General Index)
may appear. Clicking on any of the headers opens up a new panel. We’ll
save a discussion of the finer points of how to use the Skein,
Transcript, and Index for [Chapter 10, Advanced
Topics](#chapter-10-advanced-topics). In this chapter we’ll just
introduce the panels briefly.

The **Source** panel is where you’ll write your game. At the top of the
panel you’ll see two buttons: Source and Contents. When you start
designing your first game, the Contents panel won’t be useful; in fact,
it will be empty except for a brief explanatory message about what it’s
designed to do. In large or even medium-sized Inform projects, though,
you’ll want to add heads and subheads to your source text (see
[headings](#headings)). “Source” is computer jargon for what you’re
writing – everything that you’re writing, in fact, both the text that
will be displayed in your game when it’s played, and the instructions
you give Inform that control how the game works.

<div class="image-frame" markdown="1">
![](images/story_headings.png)
</div>

Once you’ve added some headings, the Contents sub-panel within the
Source panel will give you a quick way to navigate around in the source.
You can quickly jump from one section to another section that’s hundreds
of lines away, without having to use the scroll bar beside the panel and
hunt for the section you’re seeking. At right is what a portion of the
Contents of my game “A Flustered Duck” looked like back in 2009.
Clicking on any line of the tree will take you to that section of the
source code. To see more or less detail in the Contents, you can use the
menu (Mac) or slider (Windows) at the bottom of the Contents panel.

Inform is different from most computer programming languages in that the
source for your entire project will be contained in one document (that
is, in one file). Using the Contents panel, however, you can navigate
through this document in much the same way that you would by jumping
from one source code file to another if you were using a different
programming language. (Technically, it’s possible to distribute your
source code across a number of separate files and include these as
extensions in your main story file; but this is not a recommended
procedure.)

The Source panel provides an important and useful feature called
**syntax coloring**. You don’t need to do anything to set this up: It
happens automatically. As you start working with Inform, you’ll find
that different types of text within the source will be displayed in
different colors. For instance, text in double-quotes will always be
blue. Syntax coloring is used in most forms of computer programming.
It’s just a friendly feature to make it easier for you to read what
you’re writing; the colors have no effect on the game itself.

The **Results** panel (which used to be called Errors) will open up
automatically in the right-hand page when you click the Go! button (see
below) if Inform can’t figure out what you wrote. Except when dealing
with problems, you can ignore the Results panel.

The **Index** is extremely useful. Until you’ve compiled your first
game, however (see “The Go! Button,” below), the Index will be blank.
(Depending on the version of the IDE that you’re using, it may not open
at all until you’ve successfully compiled a game.) In the process of
turning your source text into a game, Inform creates and organizes lists
of practically everything in the game. By consulting the pages of the
Index, you can learn a lot about Inform, and also spot problems in your
game, or just get an energy boost from seeing that your game is getting
bigger as the automatically generated map grows.

<div class="image-frame" markdown="1">
![](images/project_index.jpg)
</div>

The Index panel is divided into seven pages: Actions, Contents, Kinds,
Phrasebook, Rules, Scenes, and World. We’ll have more to say about these
in [Chapter 10, Advanced Topics](#chapter-10-advanced-topics). The Home
button takes you to the overview display seen here. Clicking on any of
the colored boxes will take you to a particular part of the Index of
your game.

The **Skein** is used mainly for testing your game while you write it.
The Skein will become a useful tool as your game gets more complex, but
when you’re just starting out, you can safely ignore it. Briefly, the
Skein keeps a record of all of your play sessions as you test your
work-in-progress. One of the ways to test your work after making some
changes is to open up the Skein, right-click (Mac: control-click) on one
of the lozenge-shaped *nodes,* and choose “Play to Here” from the pop-up
menu. This will repeat the commands you typed on that particular
run-through. For more on the Skein, see [The Skein](#the-skein) and
consult [*Writing with Inform* Chapter 1](../WI_1.html).

The **Transcript** panel is also a tool for advanced programming
situations. To be honest, in writing my first large Inform 7 game, I
never used the Transcript, so I’m not sure how it might have made the
writing process easier. It gives you a way to “bless” the output of a
play-through of your game. If you later make changes in the game that
change the output, the Transcript will highlight the changes in the
output so that you can decide if you like them, or if you’ve made a
mistake. If you’re playing through a long game quickly, this should save
you the trouble of having to read every word in the output on every
run-through.

The **Story** panel is where your game will appear, allowing you to try
it out as you’re developing it. You can’t run other games in the Story
panel (unless you download the source code), only the game that you’re
writing. The appearance of your game in the Story panel will be similar
to, but possibly not identical to, the way it will look in an
interpreter. Other people will play your game in an interpreter (see
“Downloading & Playing Games,” later in this chapter), which is a
separate program, or by running an online interpreter in a Web browser.
As long as your game is written in English, the text of your game should
be identical no matter what interpreter it’s played in. (Not all
interpreters support the Unicode letters needed by other languages.)
Even with games whose output is in English, the visual appearance and
the type font may not be the same from one interpreter to another. For
this reason, near the end of the process of creating an Inform story
you’ll want to test your work in one or more other interpreters. Some
interpreters may not have been updated for full compatibility with the
latest version of Inform.

As a general rule, relying on the visual appearance of your game to give
players important information is not a great idea. Not only will the
appearance vary from one interpreter to another, but interactive fiction
is popular among blind computer users, because they can easily play
games of this type using screen reader software. In general, anything
that your players will need to know to play the game should be presented
as ordinary text. It’s possible to use Inform to create hybrid games
that make considerable use of graphics, clickable links, and other
resources, but the methods for doing this are beyond the scope of this
*Handbook.* For more information, see [**Chapter 23** of *Writing with
Inform*, “Figures, Sounds and Files.”](../WI_23.html)

The **Documentation** panel provides access to two large
tutorial/reference works: *Writing with Inform* and *The* *Inform Recipe
Book*. Both of these are hugely valuable resources, and you’ll want to
get to know them. Also in the Documentation panel is a list of [more
than 400 Examples](../examples/) showing how to use Inform. See [Using
the Built-in Documentation](#using-the-built-in-documentation).

The **Extensions** panel is where you’ll find the extensions that you’ve
installed. Inform authors rely extensively on extensions, which are
written by third parties. Extensions typically add new features to the
Inform programming language. In this book we’ll be making use of a
number of extensions. The details on how to add extensions to your
Inform application can be found near the end of this chapter. See
[Extensions for Inform](#extensions-for-inform).

The **Settings** panel is not often needed. Its main purpose is to let
you choose the type of output file you’ll use for your finished game.
Older versions of Inform 7 defaulted to the .z5 format used in Infocom
games, and gave you the larger .z8 format and the new Glulx format as
options. Today, Glulx is the default. If your game contains images or
sounds, you’ll need to switch to Glulx no matter how large or small the
game may be, and also check the “Create a Blorb archive for release” box
before clicking the Release button in the main toolbar. The .z8 format
may be preferable for games intended to be played online in a web
browser, but games that have more than a few rooms and objects are
likely to exceed the memory capacity of .z8.

Inform’s ability to handle images and sounds is cool, but fairly
limited. If you want to write a game that relies heavily on graphics
rather than text, you may want to consider using some other development
system, not Inform.

Also in the Settings panel is a checkbox to make random numbers
repeatable while you’re testing your game. If your game relies on
“rolling the dice,” for example to decide the outcome of a combat, to
move some of the characters from room to room, or just to choose among a
few random alternatives when printing out atmospheric bits of text,
using this checkbox will let you test the game more easily.

#### The Go! Button   {#the-go-button}

<div class="image-frame" markdown="1">
![](images/go.png)
</div>

In my kitchen I have a wonderful invention called a Zojirushi bread
machine. It bakes home-made bread. All I have to do is measure the raw
ingredients, pour them into the pan, close the lid, and press the Start
button. Little paddles inside the machine knead the dough. Then the
machine waits an hour for the dough to rise before it heats up and
starts baking. Three hours after I put in the ingredients, I have a
steaming hot loaf of fresh bread.

Inform’s Go! button is a lot like the Start button on my bread machine.
The text you write in the Source panel is the raw ingredients – the
flour, water, sugar, yeast, and so on. When you click the Go! button,
Inform churns and kneads what you’ve written and turns it into a game
that can be played. This function is explained in [WI 1.4: The Go!
button](../WI_1.html#section4).

This process looks very simple – you just click a button. But Inform
does a huge amount of work to translate your source text into a game.
This work is done by a software “machine” called a **compiler**.<span
id="Ref_compiler" class="anchor" /> There’s no need for you to be
concerned about how the compiler works its magic. But since we’ll be
referring to it here and there in this book, you need to know that it
exists, and what it does. The compiler turns your source text into a
playable game.

If I put too much water into my bread machine, the machine won’t know.
It will just produce a “loaf” that’s a soggy mess. If I forget to add
the yeast, the machine will go ahead and do its thing, and I’ll end up
with a hard, teeth-breaking lump. The bread machine doesn’t look at what
I put in the pan – it just runs through its own process, step by step,
automatically.

<div class="image-frame" markdown="1">
![](images/error.png)
</div>

A compiler is a lot smarter than a bread machine. In order to do its
work, the Inform compiler has to scrutinize every single line that
you’ve written and figure out what to do with it. If it understands what
you’ve written, a few seconds after you click Go!, your game will pop up
in the right-hand page, ready to play. More than half the time, though,
the compiler will encounter problems. It will hit a word, sentence, or
paragraph that it can’t make sense of. Instead of your game appearing in
the right-hand page, you’ll see a page like the one shown at right, in
which Inform will report on the problems it ran into.

This is nothing to worry about – it’s normal. What you need to do is
find the problems, fix them, and click Go! again. Depending on the exact
problem(s), you may have to go through this cycle five or six times
before your work-in-progress will compile successfully.

Next to each problem report in the right-hand pane, you may see a little
orange arrow. When you click on this, the Source page will jump directly
to the problem paragraph, which will be highlighted. If the problem is
in an extension, a separate edit window will open containing the
extension code. The orange arrow doesn’t always appear, however; in the
report shown here, the problem is identified correctly (the word “comma”
was misspelled as “coma” by the author), but no orange arrow is
provided. The current release of the Macintosh IDE, in particular, seems
not too fond of providing orange arrows. Nonetheless, the report will
tell you what you need to fix; the IDE’s search function will enable you
to find the incorrect line. You may also see a blue question-mark
button. Clicking on this will take you to a page in *Writing with
Inform* that may (or may not) help you understand the nature of the
problem.

Each problem message will give you some information about the type of
problem the compiler ran into. Sometimes these explanations will make
instant sense. Other times, they’re more confusing than helpful. For
instance, if you write a text for output (in quotation marks) but forget
to put the command “say” (not in quotation marks) before it, you’ll see
an error message along these lines: “Problem. You wrote \'\"Some
text.\"\' : but this is a phrase which I don\'t recognise, possibly
because it is one you meant to define but never got round to, or because
the wording is wrong (see the Phrasebook section of the Index to check).
Alternatively, it may be that the text immediately previous to this was
a definition whose ending, normally a full stop, is missing?” As you can
see, this message directs you to the line where the problem is, but
misdiagnoses the problem. In general, Inform’s error messages have
gotten progressively better, but they’re not likely ever to be perfect,
simply because authors are so creative about inventing new errors.

After a while you’ll start to get a feel for the types of errors you
usually make, and the problem messages you’ll see as a result. For more
details, see [All About Bugs](#all-about-bugs), later in this chapter.
But if all goes well, your game will appear in the right-hand page, in
the Story panel, ready for you to try it out.

One thing you may want to know about the Go! button is that when you
click it, the first thing that Inform does is save your Source to a file
on disk. This new file will overwrite anything that was in the file
before. So if you’re trying out various kinds of changes in your game,
you may want to create alternate versions of the game – one to
experiment with and one as a safe backup copy. To make a separate copy
of the game that you can experiment with, use the Save As… command in
the File menu.

<div class="sidebar" markdown="1">
#### Six Common Problems   {#common-coding-problems}

As I watch beginners start to learn Inform, I see certain kinds of
problems showing up over and over. Here, in no particular order, are
some things to watch out for in your code:

**Forgetting to say “say”.** You want the game to produce a certain text
output in a certain situation, so you just write it, surrounding it with
quotation marks as usual. In a couple of cases, such as descriptions of
rooms, this is okay. But if you’re writing a rule in which you want
Inform to say something, you have to say “say” before you start the
quoted text.

**Missing period at the end of a sentence.** Always end sentences with
periods. There are some special rules about placing periods in relation
to quotation marks, but if the sentence doesn’t have a period at all,
Inform may get confused. If the sentence is in the middle of a paragraph
of code (as opposed to a quoted block of output text), Inform is almost
certain to get confused.

**Misspelled word.** An easy problem to run into, and sometimes hard to
spot. You’ll be typing the word “description” a lot, and at a high
screen resolution you may not notice at first that you’ve spelled it
“descripton” or “descrpition”.

**Colon instead of semicolon or vice-versa.** These two marks look
almost alike on the screen, but they’re completely different. A
semicolon is like a stop sign on the street; it tells Inform, “Okay,
stop here for just a second, and then go on, because we’re not done
yet.” A colon is like an arrow pointing forward – it tells Inform, “Do
this next.”

**Wrong indents.** See [indenting](#indenting) for a full explanation of
how Inform handles indentation.

**Jumbled thinking.** To write IF, you need to work in a patient,
logical, step-by-step manner. Trying to design a complicated action
sequence before you’ve learned the basics is guaranteed to frustrate you
– and if you post plaintive questions on the forum asking for help, you
may not understand or know how to apply the answers that more
knowledgeable authors give you.

</div>

#### The Release Button   {#the-release-button}

<div class="image-frame" markdown="1">
![](images/release.png)
</div>

When your game is finished – or maybe not quite finished, but far enough
along that it’s ready to share with other people so they can test it,
find problems, and offer suggestions – you can click the Release button.
This will produce a game file in the .z8 or Glulx format, depending on
what you’ve specified in the Settings panel. You can give this file to
other people, or attach it to an email and send it to them. They’ll be
able to load it into an interpreter and play your game.

Some of the features that you can use while testing your game in the IDE
(see [Using the Debugging Commands](#using-the-debugging-commands),
later in this chapter) will not be available in the release version.
However, the extremely handy Release For Testing command in the Release
menu gives you a way to create a game file for your testers that *does*
include the debugging commands.

When you use the Release button, you’ll see (in the right-side panel) a
list of suggestions for things you may want to consider adding to a
released game. These options are not found in the Release menu in the
IDE. Instead, you invoke them by adding statements to your source. For
instance, you might want to write:

```
Release along with cover art, a solution, and a website.
```

The release options are explained in [WI Chapter 25:
Releasing](../WI_25.html).

#### Other Features   {#other-features}

The Stop button is found only in the Windows IDE. It’s not used often,
but you won’t be able to make certain kinds of edits in the Skein while
the game is running. (That would be like trying to change to a new pair
of ice-skates while skating around the rink.) The Stop button will end
the current play session, making these Skein edits possible.

The Macintosh version of the Inform IDE includes, in the Window menu, a
Customize Toolbar command. In the current version, however, this doesn’t
work. In theory, you can drag a Watch or Breakpoints button into the
toolbar, for instance – but Inform has, at present, neither of these
types of functionality. (Watching expressions and setting breakpoints
are techniques used by programmers in debugging computer software.)
Perhaps in a future release of Inform, you’ll be able to add useful
tools to the toolbar.

<div class="sidebar" markdown="1">
#### Source: Code or Text?   {#source-code-or-text}

Computer programmers call what they write *source code.* The term “code”
goes back to the early days of computer programming, and probably
reflects the fact that most computer programming languages look as
abstract and hard to understand as messages encrypted in a secret code.
The creators of Inform prefer to refer to what you write as *source
text,* because they feel “text” is a friendlier term to use to describe
what you’ll be writing. However, most of the time, *The Inform 7
Handbook* will refer to what you’re writing as “source code” or just
“code,” because the word “text” in Inform also refers to the sentences
you write between double-quotes, which are intended as output during
your game. Ambiguity has its uses in literature, and also in real life,
but in general it’s not desirable in computer programming situations. I
prefer to use the word “text” specifically to refer to the output that
your readers/players will encounter. Nonetheless, when discussing the
source code that you write, we’ll sometimes use the word “text.”

</div>

### Using the Built-In Documentation   {#using-the-built-in-documentation}

Many people use Inform’s built-in Documentation as a combined tutorial
and reference guide. When starting out, you’ll probably want to use it
more as a tutorial. To do this, read Chapters 2 through 7 and try out
the Examples. The examples can easily be copied into a test game so you
can try them out and experiment with them.

First, start a new project or open up a project that you don’t mind
trashing. I keep a game called Test Game on my hard drive for this
purpose. (Actually, I have dozens of them.) You pretty much have to
start with a blank Source when trying the Examples, because pasting the
Example code into an existing game will most likely make a mess of a
game that you’re already working on.

<div class="image-frame" markdown="1">
![](images/port_royal_3.jpg)
</div>

After navigating to the Documentation page that you’re interested in and
possibly scrolling down to the bottom, open up an Example by clicking on
the blue lozenge-shaped button with the number. If the Source page in
your Test Game is still empty, you can click on the square blue button
by the first line of the code in the Example. This button will copy the
entire Example over to the Source page. If you’re already working on a
game and don’t have an empty Source page, click on the arrow button
instead. This will open an entirely new Inform IDE window with the
Example code loaded. Now all you need to do is click Go!, and the
Example will turn into a short but playable game. After playing the game
to see what it does, try changing some of the source code and play it
again. This is a great way to learn how Inform works. (Due to ongoing
changes in the Inform language, however, it’s possible that a few of the
older Examples won’t work correctly. If you encounter this type of
problem, post a message asking for help on the [IntFiction forum][1].)

<div class="image-frame" markdown="1">
![](images/port_royal_1.png)
</div>

All of the Examples are used in both *Writing with Inform* and the
*Recipe Book.* If you’ve opened the Example from within *Writing with
Inform,* the yellow RB button on the right side of the Example’s header
takes you to the page in the *Recipe Book* where it’s used. From
Examples in the *Recipe Book,* the gray WI button will take you back to
the Example in *Writing with Inform.*

Once you’ve read through large parts of the Documentation (perhaps
several times), it will get easier to find the information you need. The
Documentation now has an index, which you can reach by clicking the
General Index tab at the upper right corner. In case that doesn’t get
you where you need to go, the IDE includes a Search field. You can type
whatever you’d like in this field, and Inform will go through all of the
Documentation looking for matches. You may find anything from no matches
to dozens of them. The more specific you can be about what you’re
looking for, the better the Search engine will work. Phrases like “end
the story” and “omit contents in listing” will work better than
something like “scenery”, which produces way too many matches. In the
Windows IDE, the search results will be highlighted in the text, making
the word or phrase easy to find. The Macintosh IDE does not yet have
this neat feature.

Once you’ve successfully compiled your story for the first time, the
Index panel will contain numerous links (the blue question-mark buttons
and gray magnifying-glass buttons) to the Documentation. Before too long
you should take some time to explore the Index. While it’s almost
bewilderingly thorough, has links to lots of good information.

### What Happens in a Game   {#what-happens-in-a-game}

If you’ve played a few parser-based interactive fiction games, you won’t
need to be told how IF works. But for the benefit of those who may just
be getting started, we’ll cover the basics here. Parser-based IF is a
bit different from hypertext stories in which you move through the story
by clicking or tapping links; we’ll have little more to say in the
*Handbook* about this type of user interface, though in fact some
extensions to Inform (notably [Keyword Interface by Aaron Reed][2]) have
been created that add the ability to insert clickable links in your
story.

In a game, you play the part of a character in a story. The story may
have a simple concept, or it may be quite complex, involving many
characters, locations, and events. In a simple story, you (the
character) might be wandering around in a cave, collecting treasures. In
a complex story, you’ll most likely meet other characters, and you may
need to outwit them or make friends with them. The story may have
several different endings, some of them happy and others not so happy.
One of your tasks as a player/reader will be to figure out which actions
lead to a happy ending. But until you start taking actions, you won’t
know which choices lead to which endings.

#### Entering Commands   {#entering-commands}

To play the game, you type *commands* (instructions to the computer)
when you see the command prompt. The <span id="Ref_command_prompt"
class="anchor" />command prompt generally looks like this:

> <span class="command"><span class="prompt">></span></span>

The words you type at the prompt are called the command line, and this
method of interacting with the computer is called a *command line
interface* (CLI). The command line interface was common in computers in
the 1970s, when interactive fiction was first invented, but today most
computer users may not even know that their computer’s operating system
has this type of interface. It’s well hidden.

Unlike a video game, where you need quick reflexes to deal with animated
characters who are moving around, in a text game nothing happens until
you type a command and hit the computer’s Enter key. When you press
Enter, the game reads your latest command and prints out a response.
(There are rare exceptions to this – text games that have some real-time
features, which cause time to advance in the story whether or not you
enter a command.)

What kinds of commands can you enter? The commands tend to have a common
form, which we’ll discuss here, but each game may have a few unexpected
commands of its own. Part of the challenge of interactive fiction
(indeed, most of the challenge) is figuring out which commands to enter,
and when. A command that works beautifully in one scene may not produce
useful results in another. It’s up to the player to discover how exactly
to use the commands in any given game.

Some of the responses that the game gives when you enter commands may be
error messages: Maybe you misspelled a word, for instance, so the game
doesn’t know what you meant. In this case, try typing OOPS followed by
the correct spelling. The result might look like this:

> **Dungeon** \
> A dank and dismal dungeon. You can go north. \
> You can see a tool chest (closed) here. \
>  \
> <span class="command">open chet</span> \
> You can\'t see any such thing. \
>  \
> <span class="command">oops chest</span> \
> It\'s awkward, but you manage to open the tool chest while wearing \
> the handcuffs.

Assuming your command makes sense, the response will show you what’s
happening in the story. The command you entered may cause a change in
the world of the story, or it may just give you more details about
what’s going on.

If you’re playing a game, you don’t often need to pause to think about
exactly how the game is able to read your commands and respond to them.
But while writing a game, you’ll need to know more than a few details.
The software gadget that reads and interprets what the player types is
called a <span id="Ref_parser" class="anchor" />**parser**{::}*.* Every
text game that uses a command line interface has a parser (although the
parser used in games that are written using the ADRIFT programming
system is so crude as almost not to be worthy of the name). The parser
that’s built into Inform 7 is very sophisticated. It’s able to
understand quite a variety of inputs from the player. You can also
change what it does, if you need to. Many of the techniques for doing
that are explained in this *Handbook.* For instance, you can add to the
types of commands that the parser understands. You can also change the
error messages that it prints out when it doesn’t understand what the
player typed or can’t do the operation that the player has requested.

No parser is able to understand the kinds of complex sentences that you
and I speak and write every day. The parser is designed to process
simple commands, such as OPEN THE DOOR and PICK UP THE BALL. Most
commands are of the form <VERB> <NOUN> <MAYBE A PREPOSITION> <MAYBE
ANOTHER NOUN>.

Some verbs (such as WAIT, SLEEP, and JUMP) are followed by no nouns at
all. Some verbs need one noun – for instance, OPEN THE DOOR and PICK UP
THE BALL. A few verbs take two nouns, which are (usually) separated by a
preposition. Examples would include PUT THE BOX ON THE TABLE and HIT THE
OGRE WITH THE STICK.

When you’re entering commands during a game, the word THE can always be
left out, and most experienced players never use it. They would just
type HIT OGRE WITH STICK. That works perfectly. (Or at least, it works
perfectly if the player character is holding a stick, if there’s an ogre
in the room, and if the author has taken the trouble to tell Inform what
should happen in response to that command.) Think of the command line
syntax in interactive fiction as a form of Caveman English. TAKE BALL.
OPEN DOOR. It’s easy, once you get used to it.

If an object has a name that includes an adjective or two, you’ll
probably be able to use just an adjective to refer to it. If the object
is called “the tarnished gold crown” in the game, typing PICK UP GOLD
should work (at least, it will work if the author has done a decent job
writing the game).

Once in a while, the parser will ask the player for more information.
For instance, if you’re in a room with a gold crown, a gold ring, and a
gold orb, when you type PICK UP GOLD the parser will respond, “Which do
you mean, the gold crown, the gold ring, or the gold orb?” At this
point, the parser will try to interpret your next input as an answer to
the question. If you just type ORB, the parser will understand that you
meant PICK UP GOLD ORB, and the game will proceed to do that action.

If you’re in a room with another character, you can try giving them a
command, like this: BOB, PICK UP THE STICK. Bob may or may not do what
you want – at the moment, we’re just looking how commands are entered.
Here, you type the name of the character, then a comma, then the
command. (To learn how to write a game so that characters will respond
to the player’s commands, see [Giving Orders to
Characters](#giving-orders-to-characters).)

Most interactive stories take place in what’s called a *model world*.
This is a place that was created by the author of the story. It exists
only within the computer – and in fact, only within the game’s
interpreter software. It might be an ancient castle, the interior of a
space station, or a busy modern city. The model world always consists of
one or more *rooms.* The rooms are the locations where the story takes
place. A “room” might be a large open field, or it might be the interior
of a small, stuffy cardboard box. The word “room” is used in IF
authoring to refer to each of the locations in the game, whether or not
the location is literally a room.

If you want to see what’s in the room with you, you can use the command
LOOK (this can be abbreviated L). When you LOOK, you’ll read a
description of the room and its contents. In general, you can only see
what’s in the room with you; you can’t see into any other rooms. Some
games have windows you can look through, but basically windows have to
be “faked” using some clever programming tricks.

If there’s more than one room in the game, you’ll be able to move from
room to room. This is usually done by typing commands based on compass
directions – for instance, GO NORTH. This type of command is so common
that it can be abbreviated. You can type N to go north, NE to go
northeast, E to go east, SE to go southeast, and so on. Depending on the
type of world where the story takes place, the directions you can travel
may also include up (U), down (D), in, and out.

The use of compass directions in IF is artificial but convenient. From
time to time authors try to come up with alternatives, but none of these
has caught on. In “Blue Lacuna” (a large, complex game written in
Inform), Aaron Reed used a neat system in which certain words that are
highlighted in the text can be used as movement commands. For example,
if the word “beach” appears highlighted, typing BEACH will take you to
the beach. This system is available as an extension for Inform called
Keyword Interface. (For more on how to use extensions, see [Extensions
for Inform](#extensions-for-inform).)

As you travel through the model world, you’ll encounter various kinds of
objects. Some of them will be portable: You’ll be able to pick them up,
carry them around, and drop them in other locations. Other objects will
be scenery, and can’t be moved.

The first thing you’ll want to do, when you enter a room, is EXAMINE all
of the objects that are mentioned in the room description. Most modern
games understand X as an abbreviation for EXAMINE, though a few
old-school games don’t. Read the room description carefully and then X
anything that’s mentioned. You may discover important details by doing
this.

If an object is portable, you’ll be able to pick it up. Let’s say the
object is a bowling ball. The commands PICK UP BALL, TAKE BALL, and GET
BALL all mean the same thing. (Inform authors call this the *taking*
action.) To read a list of the items you’re carrying, use the INVENTORY
command. This can be abbreviated INV, or simply I.

The game may limit, realistically, the number of objects you can carry
at any given time – after all, the player character probably has only
two hands! But players tend to find this limitation annoying. A
compromise solution adopted by many authors is to give the player a
sack, or something similar, whose capacity is basically unlimited. (See
learn how to make a [carry-all object for the player.)](#Ref_holdall)

Whether or not a game contains a carry-all, from time to time you’ll
probably find other containers. A container may be permanently open,
like a basket, or it may be something that you can OPEN and CLOSE, like
a suitcase. If a container is open, you can try putting things into it
using a command like PUT BOWLING BALL IN THIMBLE. Some of the things
that can be opened and closed can also be locked and unlocked.

Note that Inform’s standard locking and unlocking actions require that
the author create a key that fits the lock. By default, the action
UNLOCK DOOR is not defined in Inform, though you can create this type of
action yourself, for your own game. Inform’s unlocking action always
takes the form UNLOCK DOOR WITH RUSTY KEY. And of course the player must
be holding the correct key for that action to work.

Most games include puzzles. (For more on puzzles, see Chapter 6.) Some
puzzles are easy, and some are fiendishly difficult. These days, many
games have built-in hints that will help you if you don’t know how to
solve a puzzle, but in other games, it’s strictly up to your ingenuity
to figure out what to do. See [Adding Hints](#adding-hints).

Some games are friendly: You may get stuck for a while before you figure
out what you need to do next, but the worst thing that can happen to the
character whose role you’re playing is wandering around and not knowing
what to do next. Other games are cruel. In a cruel game, if you do the
wrong thing, your character can get killed, perhaps in a very nasty way.
Fortunately, the UNDO command will usually get you out of trouble.

Not always, though. Some games are so cruel that they won’t let you UNDO
if your character has died. Because of that, it’s a good idea to SAVE
your game every so often, especially before trying anything that might
be dangerous. If you get killed or lose the game in some other way,
you’ll be able to RESTORE. The RESTORE command opens a dialog box where
you can choose a saved file to reopen. By choosing the most recent saved
file, you can revert to a point before you got in trouble. (Wouldn’t it
be nice if real life was like that?)

<div class="sidebar" markdown="1">
#### It’s All About You!   {#its-all-about-you}

In most interactive fiction, you (the player) play the part of a
character called “you.” When the game prints out a message, such as “You
can’t see any such thing,” it’s talking about the character called
“you.” The pronoun “you” is grammatically in the second person, so we
say these games are written in *second person*. A few games are written
in which the character is “I” (first person) or “he” or “she” (third
person).

In most games, the action is described as taking place right now. For
instance, “You walk up the stairs.” Grammatically, this is called
*present tense.* A few games are written in past tense (“You walked up
the stairs.”) Second-person, present-tense storytelling is not used much
in novels or short stories, but it’s very normal in interactive fiction.
It’s possible to write a story in any combination of person and tense,
and the current version of Inform supports this very nicely. You might
want to give a period flavor to a story set in the 18th century, for
instance, by choosing past tense and third person: “He walked up the
stairs.” See [Story Tense and Viewpoint](#story-tense-and-viewpoint).

</div>

### Downloading & Playing Games   {#downloading-playing-games}

One of the best ways to learn about game design is to download and play
a few games. A good place to start looking for games is the [Interactive
Fiction Database][3]). On this site you can read reviews of games,
search for games by a particular author, and click links to download the
games themselves. Some games on this site can be played online, in your
browser, without downloading.

Another resource for finding games is the archives of an online magazine
called [SPAG (the Society for the Promotion of Adventure Games][4]. Some
games are available from authors’ websites, but far more are to be found
in the [IF Archive][5]. You can find many [Inform games in the
games/glulx directory of the Archive][6] and the [source code for many
Inform games in games/source/inform at the Archive][7].

To play text games, you’ll generally need both the game file itself and
a separate piece of software called an **interpreter**{:
#Ref_interpreter}. After downloading and installing an interpreter,
you’ll load the game into the interpreter to play it. A few games
written in TADS and some other development systems are available as
free-standing programs for Windows. [Quixe][8] is a browser-based game
player for large Inform games in the Glulx format. Inform games in Glulx
or the Z-machine\'s .z5 and .z8 formats can be played in a Web browser
using [Parchment][9].

Currently the best interpreter is called [Gargoyle][10]. It’s available
for Windows, Mac OS, and Linux (as an AppImage). You can [download the
latest Gargoyle release][11] Gargoyle can play all Z-code (Inform) and
Glulx games, as well as TADS games and Hugo games.

<div class="addendum">
<div class="add-header">
Addendum
</div>
<div class="add-body" markdown="1">
Gargoyle is still popular. Most Mac users like Spatterlight; Lectrote is
another popular choice.

</div>
</div>

#### What’s This .z8 Stuff All About, Anyway?   {#whats-this-z8-stuff-all-about-anyway}

In the beginning, there was Zork. Well, no, that wasn’t quite the
beginning. In the beginning was Adventure. Adventure was the very first
text-based computer game. It was freely copied and shared by computer
users in the 1970s, and was never a commercial product. But around 1980,
some clever people saw that they could make money on text-based games.
They started a company called Infocom. The first game that came from
Infocom was called Zork.

Zork was enormously successful, and led to a series of sequels, which
were also successful. But then, in the mid-1980s, computers became fast
enough to display graphics. Games that used graphics were much sexier
than text games. As a type of commercial product, text games pretty much
died. (Not entirely. Here and there you might find a text game for sale
– for example, at this writing Andrew Plotkin’s “Hadean Lands” is
available for iOS through the App Store. Text games are no longer a big
business, though.)

By the late 1980s, the text game boom had passed, but there were still
hundreds of thousands of computer users who owned Zork or one of
Infocom’s other games. These games were available for many different
computer operating systems (and at the time, there were a lot more
computer operating systems than there are today). The actual game data
was the same no matter what type of computer you owned, but Infocom
created a *virtual machine* for each operating system. A virtual machine
… well, let’s not worry about the technical details. A virtual machine
is a piece of software that pretends to be a piece of hardware. The
point is, if you had a virtual machine from Infocom for your computer,
you could play any of Infocom’s games. All you needed was the data file
for a particular game. You loaded the data file into the virtual
machine, and the game would appear on your screen.

The virtual machine developed by Infocom is what came to be called the
Z-machine. (Named after Zork, you see.) Even after Infocom closed its
doors, the Z-machine was still widely available, because a lot of people
had copies, and in those days copy-protected software was still a few
years in the future.

So when Graham Nelson started working on the first version of Inform in
the early 1990s, he made a very smart decision: He wouldn’t try to write
his own game delivery system from scratch. Instead, he’d create an IF
programming language that would produce game files that could be loaded
into the Z-machine. Inform was written in such a way that its compiler
would create Z-machine-compatible game files. These could then be played
by anyone who had a Z-machine on a disk. This was one of several factors
that insured the success of Inform.

Computers in those days had very little memory compared to computers
today, so the Z-machine had to be small and efficient. It could load and
run several different file types, but the most common had names that
ended with .z5 and .z8. A .z5 file could be as large as 256Kb (yes,
that’s kilobytes, not megabytes), while the larger .z8 format could be
used for games that needed to be as large as 512Kb.

Today, the Infocom-era Z-machine is ancient history. If you still have
an Atari or Kaypro computer in working condition, and a Z-machine
interpreter for that computer, you could play a game written today in
Inform, as long as the game was compiled as a .z5 or .z8 file. But who
owns a Kaypro anymore? Today, several newer IF interpreters have been
written that are compatible with the original Z-machine game file
format. These have names like Frotz and Bocfel (both of which were magic
words in one of the Zork sequels).

In order to allow Inform authors to write larger games, Andrew Plotkin
created the [Glulx][12] game format. Glulx games can be much larger, and
can include sounds, graphics, and multiple sub-windows within the main
game window. Glulx games can be played on any modern personal computer,
since Glulx interpreters exist for Macintosh, Windows, and Linux.
However, Glulx games are mostly too large to play on cell phones and
other hand-held devices. Z-machine interpreters are available for some
popular hand-helds. (Frotz is available for the iPhone, for instance.)

### Writing Your First Game   {#writing-your-first-game}

There are no rules at all that dictate what you can put in a game. One
of the great things about interactive fiction is that you’re free to
write whatever sort of story you’d like, and put whatever story elements
in it you think would be fun.

Your first game may be just something that you put together for fun, or
as a surprise for your kids. But if you hope to create a game that you
can share with other people, you may want to think carefully about what
people will be able to see and do when they play your game. Here are a
few tips that may help you come up with a better game. If these tips
don’t make sense now, come back to the list in a few weeks – it may make
more sense after you’ve done some writing.

1.  Players won’t be able to read your mind. If you want them to know
    about something (such as which directions they can go when they’re
    in a certain room, or the fact that a time bomb is ticking), you
    need to write some output text that will tell them. Output text is
    the material that appears in double quotation marks within your
    source text.
2.  When creating objects, always add all of the vocabulary words you
    can think of that players might use to refer to the objects. (See
    [Adding Vocabulary Words](#adding-vocabulary-words-with-understand)
    to learn how to do this.)
3.  When creating new actions that will work on your objects, always add
    all of the verb synonyms you can think of. Forcing the player to
    guess what verb you had in mind is considered extremely poor form.
    (The techniques for [creating new actions](#creating-new-actions)
    are explained in Chapter 4)
4.  After writing a few paragraphs, click the Go button to compile your
    game and test your work. Test all of the silly commands you can
    think of, and watch how your game handles the commands. Then rewrite
    and test some more. Don’t wait until you’ve written great swaths of
    source text before compiling; failing to compile often is just a way
    to give yourself lots of needless headaches.
5.  Write an intro to your game (using a When Play Begins rule – see
    [Passing Time](#passing-time)) that gives players a clear idea about
    two or three things: Where the story takes place, what character
    they’re supposed to be, and what that character is trying to do.
6.  If you plan to have anyone outside your immediate circle of family
    and friends play the game, you’ll want to enlist at least two
    [beta-testers](#Ref_beta-test).
{: .num}

Even before you write the first sentence of your story, Inform contains
a great mass of rules that will allow your game to do some sophisticated
things automatically. The game can, for instance, construct sentences
that you never wrote, in order to describe situations that may come up
during the story. The rules that are included in I7 are called the
**Standard Rules**. You can use them without knowing anything about
them. In fact, you will be using them in every game, unless you
explicitly switch some of them off. Just about every rule in the library
can be individually disabled (switched off) if it produces results that
you don’t want. Switching off portions of the library is an advanced
programming topic, but the basic technique is illustrated in [Appendix
C][13].

If you’re curious about what the Standard Rules look like, you can open
them from the Inform IDE. In the Macintosh, choose File > Open Extension
> Graham Nelson > Standard Rules.

Please be careful not to make any changes in this file! If you do
accidentally make changes, be sure to close the file without saving.
Changing the Standard Rules could mess up Inform so that the games you
write won’t work properly, or at all. (If this happens, you can always
download and reinstall Inform. Reinstalling will not affect the game
you’re working on.)

#### From the Top   {#from-the-top}

To start your game, you need to create at least one room, where the
story will start. Chapter 2 of this book is all about how to create
rooms. Before you start writing your first room, though, you may want to
do a couple of preliminary things. I recommend starting your game as
shown below. First, the game should have a title and a byline. (These
will be created automatically by Inform when you start a new project,
but you can change them at any time just by editing the first line in
the Source page.) After the title and byline, skip a line and write a
Use sentence, like this:

```
Use American dialect and the serial comma.
```

Inform was written by an Englishman, so it uses British spellings for a
few words unless you instruct otherwise. “Use American dialect” switches
the spelling from British to American. If you want the game to start out
in brief mode, do it this way:

```
Use American dialect, brief room descriptions, and the serial comma.
```

Prior to version 6E59, Inform’s default for room descriptions was <span
id="Ref_brief_mode" class="anchor" />brief mode, but the default has
been changed to verbose mode. Here’s the difference: When the game is in
verbose mode, the player will read the complete description of each room
each time she enters the room. If the game is in brief mode, the room
description will be printed out in full only the first time the player
enters a room; after that, the room name will be printed more or less by
itself. (Any movable objects or people in the room will still be
mentioned.) The player can switch full-length room descriptions on and
off using the VERBOSE and BRIEF commands, which are built into Inform,
so telling Inform that you want to use brief room descriptions only
controls how your game will start out, not what may happen after that.
If the solution of a puzzle relies on the game being in verbose mode,
but the player has switched to brief mode, you’ve written an unfair
puzzle! (Here’s a **bonus tip**: If the room description has changed as
a result of some action the player has taken, and you want to make sure
the player sees the new description, make the room *unvisited* when the
player takes that action. For more on how to do this, see [When Is a
Room ‘Visited’?](#when-is-a-room-visited).

The serial comma <span id="Ref_serial_comma" class="anchor" />is the
final comma in lists of items. If the serial comma is switched on, your
game might report this:

> You can see an apple, a pear, and a banana here.

If the serial comma is *not* being used, the output is just slightly
different:

> You can see an apple, a pear and a banana here.

Most games also need an introduction – some text that will “set the
stage” for the story. You can create an introduction by writing a When
Play Begins rule, perhaps something like this:

```
When play begins, say "Lord Triffid has invited you to spend your week's vacation in his castle. Upon arriving, though, you begin to feel a bit uneasy. Perhaps it's the bats flying in and out of the attic window that put a damper on your mood, or perhaps it’s the sound of barking, snarling guard dogs…"
```

#### The Detail Trap   {#the-detail-trap}

When writing your first interactive fiction, there’s a pitfall you may
want to watch out for – the detail trap. Let’s suppose you want your
story to start in the kitchen of the main character’s house. So you
start putting things in the kitchen – appliances and so on. (By the way,
[RB 6.5: Kitchen and Bathroom](../RB_6.html#section_5) has some great
tips on how to make appliances.) Now, a kitchen is a complicated place!
The stove can be switched on, and touching it when it’s switched on will
burn you. The hot and cold water taps in the sink can also be turned on,
and when one of them is on, there’s some water that the player might
want to interact with. In the refrigerator is some moldy cheese, so you
need to figure out how Inform handles the smelling action.

And so on. Two months later, you’re still trying to work out the details
of a realistic kitchen. (What if the glass in the cupboard is half-full
of water instead of completely full? If you empty a half-full glass on
the floor will it only make a small puddle instead of a large puddle?)
Meanwhile, your story has gone nowhere, and your enthusiasm for
interactive fiction has taken a nosedive. That’s the detail trap.

A better approach, I’ve found, is to start by creating a bunch of rooms
and putting perhaps a couple of major scenery items in each room.
(Scenery is discussed in Chapter 2.) Then create a few simple puzzles.
Then add one or two important characters – but only in a basic way.
Don’t worry about the nuances of conversation yet. (Characters and
conversation are covered in Chapter 5.)

I like to write descriptions when I’m starting out, because I like to
get a concrete feeling for the places and objects in the story. To start
with, though, write basic descriptions of rooms and important objects
without worrying about how the objects may change during the course of
the game. You can always edit the descriptions later to allow them to
change dynamically, or to take account of details that are added to the
code later.

There’s a lot to learn in Inform. So start with simple things and build
up your game in an orderly way. Put off the complex and tricky stuff for
a later stage in the development.

#### Title Trickery   {#title-trickery}

We’re going to take a little detour into more sophisticated Inform
programming here – nothing that’s tricky to write or understand, but
we’ll use a couple of Inform’s deeper features without bothering to
explain them. The reason we’re going to do it here is because of what
happens at the very beginning of the game.

After your intro, Inform will print the banner text. (Don’t confuse the
banner text, which is printed only once, with the status line, which
looks like a banner and usually runs across the top of the interpreter
window throughout the game.) If you’ve given your game a title and
subtitle, they’ll appear in the banner text, which might look something
like this:

> **A Screw Loose** \
> A Digital Dalliance by Jim Aikin \
> Release 1 / Serial number 150215 / Inform 7 build 6L38 (I6/v6.33 lib \
> 6/12N) SD

Wondering how to put a cool subhead underneath the game’s title, like
the one shown above? That text is called the story headline. You do it
like this:

```
The story headline is "A Digital Dalliance".
```

Providing the release number, serial number, and so on as part of the
banner is not anything you need to set up; it’s done automatically, as a
courtesy to players. Among other things, it will help you keep track of
different versions of your game, if you release more than one version.
But there may be games in which displaying this text is not desirable.
You may want to replace the default banner text with your own text, or
suppress it entirely. To do this, you could add code like this near the
top of your game:

```
Rule for printing the banner text:
	say "[bold type]I'm a lumberjack and I'm okay![roman type][line break][line break]"
```

Whatever you write as a rule for printing the banner text will be
printed out as the banner. Instead of using a “say” phrase as shown
above, you can write “do nothing” here, which will suppress the banner
text entirely. If you’re replacing the banner text, you might want to
include your own version number. (Inform’s version numbering doesn’t
allow decimal points, which makes it a bit nonstandard in the computer
world, so writing a banner text such as “A Screw Loose, version 1.01”
might be worth considering.)

Writing a new rule for printing the banner text, however, will *also*
change the banner text information when the player types the VERSION
command. The release number, serial number, build number, and compiler
number will be unavailable. This is less desirable. If you want to
suppress the banner text at the beginning of the game but keep the
information available in response to the VERSION command, you can do it
this way:

```
The display banner rule is not listed in the startup rulebook.
```

This will eliminate the opening banner but leave the version information
intact, so the player will be able to display it with the VERSION
command. Substituting your own banner text when play begins while
keeping the existing text in response to the VERSION command is possible
but tricky, so we won’t get into it here.

Before we move on, we need to pause for a quick cautionary note: The
title of an Inform game can’t contain quotation marks. That is, if you
want your story’s title to be displayed this way:

> “Repent,” Said the Tick-Tock Man

… you just plain can’t. You can, however, use single quotes
(apostrophes), producing this title:

> ‘Repent,’ Said the Tick-Tock Man

A problem that used to crop up more often has now been fixed. In some
previous versions of I7, it was impossible to use an apostrophe in the
title if the apostrophe fell at the end of a word. That is, you couldn’t
call your story “Goin’ Home”. This is now allowed. You can just type an
apostrophe at any point in the title, either in the middle of a word or
at the end, and it will be displayed properly.

#### Telling a Story   {#telling-a-story}

Maybe the most basic way to look at a story – any story, be it
interactive, written on paper, or told out loud – is that a story is
about a person who has a *problem*. The reason for looking at stories
this way is simple: If the main character in the story doesn’t have a
problem, the story will be extremely boring. When we read a story, we
want to enjoy the suspense of wondering how the lead character will
solve the problem, and then at the end we want the satisfaction of
seeing how the problem was resolved. In interactive fiction, the player
usually *is* the lead character, which can add to the suspenseful
emotions your reader/players will feel.

The problem in a story can be as small as finding a lost kitten, or as
large as saving Earth from alien invaders. As long as the problem is
emotionally important to the lead character, it will work in a story.

If the problem is too easily solved, the reader (or player) will feel
cheated. So the author needs to make sure the problem is not only
important to the character, but not too easy.

In interactive fiction, solving the main story problem usually means
solving a variety of puzzles. This *Handbook* has a whole chapter
(Chapter 6) on designing puzzles.

<div class="sidebar" id="whats-a-wip" markdown="1">
#### What’s a WIP?

As you read discussion of interactive fiction programming in Internet
forums and newsgroups, you’ll often find somebody talking about “my
WIP.” This is an abbreviation for “work in progress.” Large games can be
“in progress” for months or years. As long as you’re still working on an
unfinished game, or even thinking about it once in a while, it’s a WIP.

</div>

### Managing Your Project(s)   {#managing-your-projects}

It’s a good idea to always save your project to some specific folder on
your hard drive. In Windows, this would probably be My Documents >
Inform > Projects. If you care about your creative work (and you
should!), it’s a very good idea to *back up* your project to a separate
location after you’ve done any new work on it. USB memory sticks are
cheap and convenient. Always use a separate *physical* location for
backup, not just a different partition on the same physical hard drive.
The point of making a backup copy is to protect you against the
possibility of a hard drive crash or system failure.

Every few days, I like to save a project using a new, numbered filename.
After working on Flustered Duck 05 for a few days, I’ll use the Save As
command and save the project as Flustered Duck 06, and so on. (The final
release version of “A Flustered Duck” was project version 21). Here’s
why that’s a good idea: If you should change your mind about a design
decision that you’ve made, or if you should accidentally delete or
change something without meaning to, you can open up an older version of
your project and copy a portion of the source code from the old version
into the new one. Doing this actually saved me from a serious problem
when I was writing this *Handbook.* I recommend it highly.

### About Inform Source Code   {#about-inform-source-code}

One of the strong attractions of Inform 7 for new authors who would like
to try writing IF is its use of natural language syntax. In many simple
situations, both writing Inform source code and reading it is easier
than wrapping your brains around a more conventionally structured
programming language (such as TADS 3 or Javascript). Unfortunately,
there’s a downside to this apparent ease of use, which will become more
apparent as you get deeper into writing your game. Inform’s programming
language contains a lot of one-off syntax – phrases that make sense if
you know them, but that are hard to guess if you don’t know them. If you
can’t remember how a given line should be written, your game probably
won’t compile, and the compiler’s error message may not be very helpful.
And if you can’t remember the phrase to use, searching the Documentation
for it may not work either.

### All About Bugs   {#all-about-bugs}

When a computer program doesn’t do what it’s supposed to do, it either
does the wrong thing or, worse, stops working entirely. This type of
problem is referred to as a *bug*. According to legend, one day the
scientists who were trying to use one of the very earliest computers
kept getting mysterious errors. After hours of frustration, somebody
thought of opening the box of circuits and looking inside. A dead moth
was lying on a circuit board, making an electrical connection where no
connection was supposed to be. After that, the scientists started saying
that any mysterious behavior in their programs was caused by “a bug.”

Finding and fixing bugs is a huge part of computer programming.
Fortunately, most of the bugs you’ll run into don’t involve dead
insects! (Although that might make an interesting puzzle…) Most bugs
today are caused by errors in the instructions (the source code) that
the computer is trying to run.

We all write source code that has bugs, so you may as well get used to
it. Most bugs are easily found and easily fixed. A few of them may drive
you crazy for hours at a time. It’s all part of the process.

Inform bugs come in four different varieties.

When you click the Go! button to tell Inform to compile your source code
into a game, the compiler may encounter errors. You may have written
things that Inform doesn’t understand. Instead of producing a game,
Inform will print out an error message, or a bunch of them. Usually
these messages will give you a pretty good idea what you need to fix –
but sometimes the compiler can’t quite guess what the real problem is,
so you may need to try a bunch of changes until you find something that
works.

In the second type of bug, when you click the Go! button, your game may
compile successfully and appear in the right-hand window, ready for you
to try out. But the game may not behave in the way you expect. An object
that you meant to put in plain sight in a room might not be anywhere in
the game, for example. Inform can’t find these bugs for you. The only
way to find them is by testing and retesting your game while writing it.
Try out a bunch of different commands, including silly ones, just to see
what happens. (This is called “trying to break it.”)

The third type of bug is called a “run-time error.” In a run-time error,
your game tries to do something that it can’t do. Instead of producing
some type of normal output, the game will produce an error message.
Run-time errors can happen, for instance, when your code tries to refer
to an object that doesn’t happen to exist. When you run into a run-time
error, look closely at the error message in the game panel, and then at
the code that is being used by the command that triggered the error.

The biggest run-time errors are those that cause the game to freeze or
quit unexpectedly. Fortunately, these are fairly rare. But don’t be
surprised if it happens – just go back to the code that was being run in
response to your last command. Nine times out of ten, that’s where the
problem will be found.

If you’re having trouble finding a bug, a useful technique is to
“comment out” a section of your source code that you think might be
causing the problem. In Inform, comments are surrounded by square
brackets \[like this\]. Any text that is within square brackets will be
ignored by the compiler – unless it’s within double-quotes. Within
quotes, square brackets have a different purpose, as explained in [Text
Insertions](#text-insertions).

By commenting out blocks of code, you can test a game both with and
without selected features. This will help isolate a trouble spot.

The fourth type of bug can look like any of the first three. Because
Inform itself is still being developed, the compiler undoubtedly has a
few bugs of its own. If you encounter something weird when you seem to
be doing everything right, it could be a compiler bug. 97% of the time
it won’t be – it will be your code. But compiler bugs do exist. If you
should run into something that looks like a compiler bug, your first
step should to post a message to the IntFiction forum asking for
confirmation of what you’ve found. If it is indeed a compiler bug,
you’ll want to file a bug report. The [Inform website][14] has
instructions on how to do this. There is also a [bug tracker
website][15] where you can check whether a given bug has already been
filed. If not, you can file a report and keep an eye on it. You can also
check here to discover what other bugs you’ll need to be aware of while
writing. Most of them are relatively obscure and shouldn’t cause you any
trouble, but some are worth knowing about.

### Testing Your Game   {#testing-your-game}

Testing a game, or any other piece of software, happens in two stages.
In the first (alpha) stage, you test your work as you’re developing it.
The best way to do this is to write the game one small piece at a time.
For instance, when you add a couple of new rooms (as explained in
Chapter 2), click the Go! button to run the game and try walking back
and forth from the new rooms to the rooms that were already in place.
Even with something as simple as adding rooms, it’s possible to make a
mistake in the compass directions or inadvertently create a room when
you think you’re creating a door, so you need to test your work.

If you add a dozen rooms, a dozen pieces of scenery, and a machine the
player can operate and *then* run the game, you’re far more likely to
miss a bug than if you test a little bit at a time. Worse, you may find
yourself staring at a screen full of compiler error messages and have to
spend an hour figuring out where your work went astray.

But even when you test as thoroughly as you possibly can while
developing the game, you will miss dozens of awful bugs. This is a
promise.

<span id="Ref_beta-test" class="anchor" />In the second (beta) stage of
testing, you enlist the aid of a few industrious volunteers, who
*beta-test* your game before it’s released and send you reports of any
bugs they spot. Good beta-testing won’t transform an awful game into a
great one, but it can definitely turn an awful game into an okay game,
or turn a decent game with deep problems into a great game. (But only if
you fix the issues that your testers find. That goes without saying.)

Always thank your beta-testers for sending you their bug reports! And
even if you think they’re wrong, don’t argue with them. Like everyone
else who plays your game, they’re entitled to an opinion, and even from
a wrong-headed opinion, you may be able learn useful lessons.

Encourage your testers to use Inform’s handy transcript feature (not to
be confused with the Transcript in the Inform IDE). At the beginning of
each play session, they should type the command TRANSCRIPT. This will
open a file dialog box in which they’ll be able to specify a name for a
script (.scr or .log) file. This file will capture everything that
happens in the play session. They can then attach the transcript file to
an email and send it to you. In effect, you’ll be able to “watch over
their shoulder” while they play the game. This is incredibly useful –
you’ll learn a lot about what commands they try to use and what objects
they’re interested in examining.

Note that this feature doesn’t work in the Inform IDE. It only works
when the game is loaded into a separate interpreter.

Some IF interpreter software may wipe out a running transcript if your
game ever clears the screen. If you employ screen-clearing for dramatic
purposes between scenes, you need to test what happens in several
interpreters (and if possible on both Mac and Windows interpreters)
before sending the game to your testers. Or ask them to test it, and
tell them how to do so.

Traditionally, IF beta-testers include comments in their transcript by
starting a command line with an asterisk. For instance, you might find a
line in the transcript that reads like this:

> <span class="command">\* The room description mentions the vase on the \
> pedestal, but I already broke the vase.</span>

By default, Inform will respond to a line like this by saying, “That’s
not a verb I recognize.” While not an actual problem, this message soon
gets annoying, since the tester is, after all, doing something sensible
– namely, giving you a comment. What we’d like would be for Inform to
respond with something like, “Comment noted.” Fortunately, this is easy
to fix. Copy the following code into your game:

```
Commenting is an action out of world applying to one topic.
Understand "* [text]" as commenting.

Carry out commenting:
	say "Comment noted."
```

The details of this code (the definition of the action and the use of a
Carry Out rule) are covered in Chapter 4. A slightly more flexible way
to get the same result is shown in Example 403, “Alpha,” in the
Documentation. However, the regular expression matching used in that
example doesn’t match the asterisk character. To allow the tester to use
asterisks, as shown above, we would need to edit the code in the example
slightly, like this:

```
After reading a command (this is the ignore beta-comments rule): 
	if the player's command matches the regular expression "^\p" or the player's command matches the regular expression "^\*": 
		say "(Noted.)"; 
		reject the player's command.
```

With this code in place, your testers can flag their comments with a \*,
!, ?, or : (or, for that matter, a ??? or !!!), either in a way that
signals what type of comment they’re making, or just for fun.

### Using the Debugging Commands   {#using-the-debugging-commands}

Inform includes a good set of commands that can be used for speeding up
your testing process and tracking down bugs in your game. These commands
are available only during the development process; when you release your
finished game, other players won’t be able to use them. These commands
don’t actually find bugs; what they do is help you see what’s going on
in your game while it’s running, and/or take shortcuts that will speed
up the testing process.

The commands you can use while your game is running in the Inform IDE
include ACTIONS, RULES, PURLOIN, GONEAR, and SHOWME. Also, for testing a
series of commands quickly, you can write a TEST ME script. The Replay
button can be used to rerun your most recent sequence of commands, which
is a very useful way to find out if you’ve succeeded in fixing a problem
that you had in the last run-through. The Skein window contains all of
your earlier run-throughs, and you can use it to replay just about any
series of commands you used earlier.

With the PURLOIN command, you can instantly “grab” any object in your
model world. Objects in distant rooms and locked containers can be
purloined – and you can also purloin things that can’t be picked up at
all in the ordinary way, such as people and scenery. There’s no reason
to purloin people or scenery, other than for fun. But by purloining the
rusty iron key that’s hidden in the oak cask in the wine cellar, you can
quickly test whether the key works to unlock the door of the princess’s
chamber. You don’t need to go down to the wine cellar and break open the
cask; just PURLOIN the key.

The GONEAR command provides instant transportation to any location in
your game. With a large game, one that includes dozens of rooms, GONEAR
will save you hours of work. Just pick an item of scenery in the room
you want to be transported to, and GONEAR the scenery item.

When using PURLOIN and GONEAR to bypass part of the process that your
players will go through, you need to be aware that you can get the game
into an unusual state – a state that your players will never encounter.
On rare occasions this can lead you to think your code has a bug that
isn’t there at all. For instance, let’s suppose you’ve programmed a
ghost to follow the player around the haunted castle. If you use GONEAR
to pass magically through a locked door, the ghost quite likely won’t be
able to follow you.

The ACTIONS command causes Inform to print out the action that’s being
triggered when you type a command. This can be useful if you aren’t
getting the results you expect from a command.

The SHOWME command prints out the current state of any object in the
model world. SHOWME SHOES, for instance, will print out all of the data
associated with the shoes object. When you start writing objects that
can get into several different states (for instance, a goblet of wine
that can be poisonous or safe), you can use SHOWME GOBLET after dropping
the tablets into the goblet to see if the goblet has switched to the
state that it’s supposed to. (See [WI 2.7: the SHOWME
command](../WI_2.html#section_7).)

As explained in [WI 11.4: the showme phrase](../WI_11#section_4), the
word showme can be used to add debugging code to your game. When the
game is running, if a line with a showme phrase is reached, you’ll see a
message in the game window giving whatever information you’ve put in the
phrase. I’m not convinced that this is very useful, however. A better
method is described on [WI 2.9: Material not for
release](../WI_2.html#section_7). After marking a section of your code
as not for release, you can put anything you like in that section,
secure in the knowledge that it will be available only to you (and to
your testers, if you choose). For example, if the hunger of the player
character is a numerical value that changes during the game, and you
want to keep an eye on it, do this:

```
Section - Not for Release

Every turn:
	say "The hunger of the player is now [hunger of the player]."
```

It’s not always convenient to put this type of game-state monitoring
printout code in its own section, however. Another technique is
suggested below, in the section “Another Way to Debug.”

More about commands you can use within the game panel while testing your
work: If you’re using scenes in your game (see Chapter 7), the SCENES
command can be used to show which scenes are currently running.

The TEST ME command gives you a quick way to run through a series of
commands (see [WI 2.8: the TEST command](../WI_2.html#section_8)). To
start with, define the series of commands you want to use in your game,
like this:

```
Test me with "open suitcase / unlock suitcase with rusty key / open suitcase / search suitcase / take dynamite / light match / light dynamite with match / z / z / z".
```

After compiling your game, when you type TEST ME the game will
automatically run through this entire sequence of commands, in order.
When you’re testing complex puzzles over and over, this will save you
lots of typing. The word “me” is used a lot (probably because it’s
reminiscent of a scene in *Alice in Wonderland*), but it’s not
necessary. You could just as easily do it this way, writing two or more
separate tests and then, if you like, writing a TEST ME command that
nests some or all of the other tests:

```
Test suitcase with "open suitcase / unlock suitcase with rusty key / open suitcase / search suitcase".
Test dynamite with "take dynamite / light match / light dynamite with match / z / z / z".
Test me with "test suitcase / test dynamite".
```

Now the commands TEST SUITCASE and TEST DYNAMITE can be used
independently, or they can be combined by typing TEST ME.

The RULES command can be used while testing your game to find out what
rules Inform is using to process other commands. This is a fairly
advanced technique – the first few times you try it you may not
understand what you’re seeing – but it can sometimes be very useful. If
the game is producing an output that you don’t want, you may be able to
figure out what rule is producing that output by using RULES and then
trying the command that isn’t working correctly. Most often, the last
rule that is displayed before the offending output text is the rule
that’s producing the text.

### Another Way to Debug   {#another-way-to-debug}

One of the easiest traditional ways to debug a computer program is to
add print statements. A print statement (which in Inform would be in the
form of a “say” statement) prints a text output to the screen. You can
put whatever you want in a print statement. For instance, you could do
something like this:

```
To demolish the dungeon:
	say "Now entering the dungeon-demolishing code.";
	[other lines of code would go here…]
```

The “say” line doesn’t do anything in your game; it just enables you to
test that your code is actually running the “demolish the dungeon”
routine when you think it’s supposed to.

Rather than just print out a bare “now this is happening” statement, you
could write a testing “say” line that would give you specific
information about other things that are going on in the game. Let’s
suppose, for instance, that you want the dungeon to be demolished only
if the player is carrying the detonator – but for some reason it appears
that the player is able to demolish the dungeon even while not carrying
the detonator. In that case, you might want to check the player’s
inventory while printing out your debugging message:

```
To demolish the dungeon:
	say "Now entering the dungeon-demolishing code. The player is currently carrying [a list of things carried by the player].";
	[other lines of code would go here…]
```

The thing to be careful of with this technique is that you might
accidentally leave a debugging print statement in the released version
of your game. Erik Temple has suggested a neat way to dodge this danger,
however. This uses a bit of inserted Inform 6 code, an advanced
technique that is mentioned only briefly in this *Handbook,* (see [What
does Inform 6 have to do with Inform
7](#what-does-inform-6-have-to-do-with-inform-7)). But since we’re on
the topic of debugging, here’s how to do it. First, add the following
lines to your game, entering them carefully (the spaces are important):

```
Use inline debugging.

Use inline debugging translates as (- Constant INLINE_DEBUG; -)
	
To #if utilizing inline debugging:
	(- #ifdef INLINE_DEBUG; -)
	
To #end if:
	(- #endif; -)
	
To debug (T - a text):
	#if utilizing inline debugging;
	say T;
	#end if.
```

<div class="addendum">
<div class="add-header">
Addendum
</div>
<div class="add-body" markdown="1">
This cannot work in 10.1, which won't allow an I6 inclusion to have an
#ifdef without an #endif.

</div>
</div>

Having done this, you can now write any debugging print statements that
you add to your game’s code like this:

```
debug “--Now entering the dungeon-demolishing code. The player is currently carrying [a list of things carried by the player].]";
```

The lines beginning with # can be used to do other things besides saying
texts, though this is probably less useful. For instance:

```
Instead of jumping:
	say "You jumped!";
	#if utilizing inline debugging;
	now the player carries the rutabaga;
	#end if.
```

You might use this technique as a tricky way of resetting in-game
objects (such as a locked door) to a desired state in order to test them
repeatedly.

When you’re done debugging and ready to release your game, simply
comment out the line “Use inline debugging” before compiling for
release, and all of the debug code will disappear from the released
version of the game.

### Puzzles   {#puzzles}

Let’s be frank: This *Handbook* is not going to tell you everything you
might want to know about writing puzzles. For one thing, clever authors
keep dreaming up new possibilities! But puzzles are such a big part of
interactive fiction that a book on how to write IF using Inform can’t
neglect them entirely.

A few works of IF have been written that have no puzzles. In a work of
this sort, the player wanders around, looking at things and/or
conversing with characters, but there are no obstacles to movement or
action. The whole of the story is available, and no special smarts or
problem-solving are needed to read it. At one time there was a
competition, the IF Art Show, dedicated to this type of game.

Even in a story with no actual puzzles, the player may be able to make
choices. These choices may affect the outcome of the story: The author
might write five or six branching story lines, and the player might have
to play the game a number of times to be sure of not missing anything
important, or to understand what the author had in mind. But if the
story is free of puzzles, we would expect that any of the choices would
be easy to find. It would be easy to move down any of the branches of
the story.

In most IF, though, the player has to exercise some brain power to do
things that will move the story forward. The player who can’t figure out
what to do next is *stuck.* A player who is stuck can wander around in
the world of the story for an hour, trying things that don’t produce any
results and getting more and more frustrated.

When the player does figure out how to solve a puzzle, there is usually
a reward of some kind. A new object might become available (something
the player will need to attack another puzzle), a new treasure be
discovered, and a new room or region of the map open up. In games that
keep score (see Chapter 7), the player should earn points for solving
each puzzle. You may want to set up a scoring system that will award
more points for solving the most difficult puzzles, and fewer points for
solving the easier ones. Of course, players may not agree with you about
which puzzles are easy and which are hard!

For details on the types of puzzles you’re likely to find when playing
IF, or likely to want to implement, see Chapter 6, “Puzzles.”

### Extensions for Inform   {#extensions-for-inform}

A number of people in the Inform 7 community (which exists almost
entirely on the Internet, though local meet-ups have popped up here and
there) have written *extensions* for Inform. An extension is a file
containing code that can be used by authors to do something specific –
something that’s not included in the standard version of Inform.

There are extensions for creating tricky kinds of objects, such as
liquids and secret doors; for producing smoother and more interesting
conversations between the player character (PC) and non-player
characters (NPCs); for constructing menus of hints that your players can
consult; and for many other purposes.

<div class="image-frame" markdown="1">
![](images/extensions.jpg)
</div>

Extensions are written using the Inform programming language – so
technically, an extension can’t do anything you couldn’t do yourself.
But most of them were written by experts, they have been tested and
debugged, and they come with documentation that tells how to use them.
So why spend a week working out how to do something tricky when you can
download an extension and have it working in half an hour?

Unfortunately, as of 2015 the situation with respect to extensions has
become a bit disorganized and confusing. It was formerly the case that
all extensions could be downloaded from the Extensions page of the
Inform 7 website. But most of the material on this page is now obsolete.
It’s useful to have access to the older extensions if you’re running an
older version of Inform for some reason, so there’s a reason to keep
this material available. But in versions 6L02 and 6L38, some basic
things in the Inform programming language have changed. As a result,
many of the older extensions won’t run in the new versions of Inform. If
you try to include one, the compiler will issue an error message. Bottom
line: Unless you know what you’re doing, do not attempt to download
extensions one at a time manually from the Inform website.

<div class="addendum">
<div class="add-header">
Addendum
</div>
<div class="add-body" markdown="1">
I wish I could tell you that as of 2022 it's no longer confusing.

</div>
</div>

Some authors have updated their extensions to work with the new version,
but others haven’t. If you want the features in an extension that hasn’t
been updated, you may possibly be able to fix the problems yourself;
Appendix B of the *Handbook* provides a few details on how to attempt
this.

If you’re new to Inform authoring, you can avoid much of the confusion.
After downloading and installing the Inform program, switch to the
Extensions page in the program, click the Public Library header, and
scroll to the bottom of the page, as shown at right. You’ll see a yellow
DOWNLOAD EXTENSIONS button; the number may be larger than 76, as more
extensions are added to the library. Click this button. Inform will
download the extensions and install them for you, and you’ll be ready to
go.

Once the extensions have downloaded, the documentation for each
extension will now be available under the Home button in the Extensions
page of the Inform program. You’ll find that the extensions are listed
alphabetically by the first name of the author.

If you’re upgrading to Inform 6L38 (or a later version) from an earlier
version and you already have some extensions installed, you’ll need to
use a slightly more complex process. Basically, you need to drag your
old folder of extensions off somewhere, so that Inform won’t be able to
find it. In Windows, the usual location for this folder is My
Documents/Inform. In the MacOS, it will be in the Library folder in your
folder in Users (for instance, Users/jimaikin/Library/Inform). However,
the MacOS tends to want to hide this Library folder from users. If you
can’t find it, open a Terminal window. Type this line (carefully) and
hit Return:

```
chflags nohidden ~/Library/
```

This code will make the Library folder show up. Please don’t make any
other changes in the Library! Once you’ve deleted the Extensions folder
from Library/Inform, you can use the Download Extensions button as
described earlier.

Once your new extensions are installed, using one of them in your game
is easy. Near the top of your source code, just below the name of the
game and the author byline, enter a line like this:

```
Include Notepad by Jim Aikin.
```

This format is required: You have to give the name of the author, and
you can’t put a comma after the name of the extension.

It’s possible to open extension in a new window in the Inform IDE and
edit the code just the way you would any other Inform code. I recommend
that you not do this. Until you become an Inform power user, it’s far
too easy to create messy problems by editing an extension. If you want
to try editing an extension – for instance, because you think it has a
bug in it – make a backup copy of it first by copying the file and
pasting it to a new folder on your hard drive. That way, if you don’t
get the results you’re expecting, you can restore the original version
without needing to download it again.

Some extensions use other extensions. If extension A uses extension B
(by including it, as shown above) but extension B has been updated more
recently than extension A, extension A may now be broken. In this type
of situation, your best bet is to report the problem, either in the
IntFiction forum or directly to the extension author.

### Where to Learn More   {#where-to-learn-more}

Once you’ve started writing with Inform, you’ll find the built-in
Documentation extremely useful. Pages in the Documentation that may not
have made much sense to begin with will turn out, after a month or two,
to be very clearly written and easy to understand. In particular, the
more than 400 Examples are a huge resource – but to get the most out of
them, you’ll need to study the code line by line. The explanations that
are included in the Examples are often brief and don’t mention
interesting features. After reading portions of the Documentation,
you’ll find the Search field in the IDE more and more useful. By typing
a half-remembered phrase (such as “something new”), you can quickly
locate a page that has the information you need.

If – no, make that “when” – you have questions about how to use Inform,
you’ll find the forum at IntFiction a tremendous resource. If you post a
question there, you’ll probably be able to read an answer posted by an
Inform expert within a few hours – or at worst, the next morning.

To get the most out of the forum, a few simple procedures will help:

1.  Post your question in the [Inform 7 subcategory][16] of the forum.
    Inform 7 is not the only programming system discussed in the forum,
    and you want to guide the right people to your post by making it
    clear what system you’re using.
2.  Describe your problem as clearly as you can. Questions that are
    rambling or confusing will be less likely to lead to helpful
    responses than questions that are clear and concise.
3.  Before posting, try to create a very short example game (no longer
    than 20 lines) that shows the problem you’re having. This will make
    it easier for the experts to see what you’re doing wrong – and in
    the process of creating the example game, you may figure out how to
    solve the problem yourself! (It often works that way, in my
    experience.)
{: .num}

Carolyn VanEseltine has a quick-start I7 tutorial, [Welcome to
Adventure][17]. For more general advice on writing IF, the [IF wiki][18]
is a good place to start your search. A lot of information is available
on the Internet, some of it tucked away in unlikely places, but the wiki
has links to most of it. [Emily Short’s interactive fiction blog][19]
also has lots of useful resources, with links to many of them collected
in her [Self-training in Narrative Design][20].

<div class="addendum">
<div class="add-header">
Addendum
</div>
<div class="add-body" markdown="1">
I recommend Allison Parrish's [Inform 7: Concepts and Strategies][21] as
the single best place to start; go on to Welcome to Adventure
afterwards. The two complement each other well, with Concepts and
Strategies offering a top-down view, and Welcome to Adventure being more
bottom-up.
</div>
</div>



[1]: http://www.intfiction.org/forum/
[2]: https://github.com/i7/extensions/blob/9.3/Aaron%20Reed/Keyword%20Interface.i7x
[3]: https://ifdb.org/
[4]: http://www.spagmag.org/archives/
[5]: https://ifarchive.org/
[6]: http://ifarchive.org/indexes/if-archive/games/glulx/
[7]: http://ifarchive.org/indexes/if-archive/games/source/inform/
[8]: https://eblong.com/zarf/glulx/quixe/
[9]: https://github.com/curiousdannii/parchment
[10]: http://ccxvii.net/gargoyle/
[11]: https://github.com/garglk/garglk/releases
[12]: https://eblong.com/zarf/glulx/index.html
[13]: #Ref_new_rule_(replace)
[14]: http://inform7.com/
[15]: https://inform7.atlassian.net/jira/software/c/projects/I7/issues
[16]: https://intfiction.org/c/authoring/inform-7/19
[17]: https://www.sibylmoon.com/welcome-to-adventure/
[18]: http://www.ifwiki.org/
[19]: https://emshort.blog
[20]: https://emshort.blog/2019/01/08/mailbag-self-training-in-narrative-design/
[21]: http://catn.decontextualize.com/inform7/
