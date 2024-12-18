## Foreword   {#foreword}

Somebody once said that if you ask five poets to define poetry, you’ll
get seven definitions. I’m sure I’m misquoting wildly – the original
version may not have been about poetry at all – but the point should be
clear. There are undoubtedly more good ways to explain the intricacies
of the Inform 7 programming language than there are people who have
written tutorials on the subject.

This book makes no claim to being the ultimate guide to Inform 7. On the
contrary: A number of topics that experienced Inform authors (or new
authors who envision unusual types of gameplay) may want or need to know
about simply aren’t included in *The Inform 7 Handbook*, or are
mentioned only in passing. The purpose of this book is to give
first-time authors the kind of information and insight that they’ll need
in order to start using Inform 7 to produce parser-based interactive
fiction in its most familiar form, without getting tangled up in a lot
of complexities. (If you don’t know what I mean by “parser-based,” keep
reading.) This version of the *Handbook* is current with respect to
version 6L38 of Inform 7, and may not be accurate with respect to older
or more recent versions.

I’ve tried to organize the material in ways that will help newcomers
find useful information quickly. I’ve attempted, as well, to write in a
way that makes few or no assumptions about what the reader already
knows. If you read the *Handbook* page by page from start to finish,
you’ll spot a few repetitions; I felt that some minor redundancy would
be better than forcing readers to hunt for information.

Inform 7 (“I7” for short) comes bundled with two long and detailed
tutorial/reference books, [*Writing with Inform*](../WI_1.html) and
[*The Inform Recipe Book*](../RB_1.html), which can be found under the
Documentation tab in the Inform application. The online versions are of
limited use if you have the Inform application open, but they can be
very handy if you find yourself wanting to brush up on your Inform by
reading on your phone while riding on a train. Before getting too far
along in the process of writing a game, every Inform author should read
the Documentation! Several times, in fact. That’s the best way to get
familiar with the power of Inform.

Some aspiring authors, however, find the Documentation a bit daunting.
At times the Documentation seems to assume that a gentle nudge in the
right direction will be all that readers will need. Step-by-step
instructions, cross-references, and full discussions of the myriad
details that authors may need to have at their fingertips are not always
provided. Clearly, there’s room for a different approach.

*The Inform 7 Handbook* grew out of my experiences teaching younger
students (ages 10 through 15) to write interactive fiction using Inform
7. When beginning students asked me how to do the kinds of things that
beginning authors naturally want to do, I sometimes found that the
information they needed was scattered through the Documentation, making
it hard to find and hard to put together into a clear mental picture.
Figuring out how to do some of the most basic real-world programming
chores strictly by reading the Documentation may take a bit of study.
I’ve heard comments about this from adult newcomers as well.

In *The Inform 7 Handbook,* information is organized into chapters by
task. Chapter 2 is about making rooms, Chapter 5 tells how to create
characters, Chapter 6 has ideas for designing puzzles, and so on. None
of the chapters is intended to tell you absolutely everything about a
given topic that you might want or need to know; after (or while)
reading a section of the *Handbook*, you’ll often want to refer back the
Documentation. I’ve included cross-references in many places to show
what pages you should consult.

Inform 7 is not the only programming language available for writing
interactive fiction. Its main competition (if free software can be said
to compete) comes from [TADS 3][1]. Version 3 of TADS (The Adventure
Development System) is, in some ways, more sophisticated than Inform 7,
and Eric Eve’s marvelous alternate library for T3, which goes by the
name adv3Lite, streamlines some of the difficulties that make TADS
intimidating. adv3Lite borrows a few useful ideas from Inform 7, in
fact. Nonetheless, the TADS programming language is as different from I7
as night and day. TADS 3 closely resembles traditional programming
languages such as C. (If you don’t know what that means, don’t worry
about it.)

Inform, TADS, and a couple of other authoring systems trace their
ancestry directly back to [Crowther & Woods’ Adventure][2], a text-based
game that ran, initially, on mainframe computers in the 1970s. Today
this type of interaction is called *parser-based,* because the
reader/player types commands (such as GO NORTH or GET LAMP) that are
processed by an internal routine called a parser. More recently, a very
different type of interactive fiction, sometimes called *choice-based,*
has become popular. In a choice-based fiction, the reader/player is
relieved of the burden of having to think what command to type; instead,
the story presents a few links that can be clicked or tapped to move
matters forward. Inform can be used to produce clickable choice-based
interactive fiction, but you won’t find much about that concept in this
book, because I frankly don’t find choice-based fiction very
interesting. To me, the fictional world of an interactive story is much
more engaging when the reader/player has to figure out what to do,
rather than being presented with a cut-and-dried menu of choices.

The “natural language” programming interface of I7 makes I7 very
attractive to those who would like to write interactive stories but have
no background in computer programming. Also, at this writing the TADS 3
development environment, Workbench, is a Windows-only application. TADS
games can be played on the Mac or on a Linux computer, but the slick
development tools are Windows-specific. For classroom use, Inform 7 is a
better choice not only because the “natural language” aspects of the
system may be easier for the newcomer to understand, but because it
makes no difference whether a given student uses a Macintosh, Windows,
or Linux computer.

Inform games can be located on websites and played within a Web browser
such as Safari, Firefox, or Internet Explorer using systems called
Parchment and Quixe. (Internet Explorer seems to be a poor choice for
running Parchment and Quixe, in my limited testing. This is probably
because Parchment and Quixe are written in Javascript, and Microsoft
uses a non-standard implementation of Javascript in IE.) When you’ve
finished writing your game, these tools will make it easier than ever
for you to share it with players and fans. In fact, Inform allows you to
release your game in the form of a web page, so it will be ready to go –
assuming you have a website to which you can upload it.

If neither the no-compromise complexity of TADS 3 nor the friendly but
sometimes fuzzy approach of Inform 7 appeals to you, you can also
investigate Inform 6, which is a completely different and much more
traditional programming language, although it shares the “Inform” name,
or a simpler system such as ADRIFT or ALAN. ALAN is cross-platform (Mac,
Windows, Linux); The application to create Adrift games is Windows-only,
but the games are playable on other platforms.

A simpler option for writing interactive stories would be to use a
choice-based authoring system. Several are currently available,
including [Undum][3], [Twine][4], and [ChoiceScript][5]. Choice-based
stories are sometimes referred to as CYOA (choose your own adventure),
because their ancestry goes back to a flurry of CYOA paperback books
that was published in the 1970s. CYOA stories are not puzzle-oriented,
but some of the authoring systems are much easier to use than Inform.
(This is not true of Undum, by the way. Undum is quite a lot harder to
learn than Inform, but allows the author to do wonderful effects.)

All of these systems, and others, are available for download on the Web.

Like Inform itself, *The Inform 7 Handbook* is free. I hope you find it
useful. If there are areas where you feel it could be expanded or
improved, I hope you’ll fire off an email (good email addresses are
[midiguru23@sbcglobal.net](mailto:midiguru23@sbcglobal.net) and
[editor@musicwords.net](mailto:editor@musicwords.net)) and let me know
what you’d like to see. Updated versions may be released from time to
time.

– Jim Aikin  
 Livermore, California  
 May 2015
{: .right}

### Acknowledgments   {#acknowledgments}

Thanks go first and foremost to Graham Nelson for the monumental task of
creating, developing, and maintaining Inform. Emily Short is tireless in
her assistance and support for Inform authors. David Kinder maintains
the Windows IDE (Integrated Development Environment) software for Inform
7, and Andrew Hunter the MacOS IDE. Andrew Plotkin’s Glulx system allows
large games and games with extra features to be written in Inform;
without Glulx, Inform would be a much less attractive proposition for
game designers.

Like Inform itself, *The Inform 7 Handbook* is a community effort. Early
drafts were read by Michael Callaghan, Eric Eve, Ron Newcomb, Emily
Short, Mike Tarbert, and Michael Neal Tenuis, all of whom suggested
valuable additions and clarifications. I also took advantage of
materials developed for other classes by Mark Engelberg and Jeff Nyman.
During the writing process, the experts on the [IntFiction forum][6]
freely shared their knowledge with me; you’ll find their names scattered
throughout. I also cribbed a few questions posted on IntFiction by
novice programmers, and made free use of questions and concerns raised
by the students in my own IF classes.

*The Inform 7 Handbook* was written using OpenOffice Writer, which also
handled the very nice cross-referencing and clickable table of contents
in the exported PDF.

Thanks to all!

### About the Author   {#about-the-author}

Jim Aikin has released several interactive fiction games, including [Not
Just an Ordinary Ballerina][7] (written in Inform 6), [Lydia’s Heart][8]
(in TADS 3), [April in Paris][9] (TADS 3), [Mrs. Pepper’s Nasty
Secret][10] (co-written with Eric Eve in TADS 3), [A Flustered Duck][11]
(in Inform 7), [Heavenly][12] (Inform 7), and [The Only Possible Prom
Dress][13] (Inform 7), a sequel to Not Just an Ordinary Ballerina. He is
the author of two science fiction novels, *Walk the Moons Road* (Del
Rey, 1985) and *The Wall at the Edge of the World* (Ace, 1992), both of
which are, sadly, out of print. His short fiction has appeared in
*Fantasy & Science Fiction, Asimov’s Science Fiction,* and other
magazines. His nonfiction books include *A Player’s Guide to Chords &
Harmony* and *Power Tools for Synthesizer Programming* (both published
by Hal Leonard), and he has written innumerable features on music
technology for *Keyboard, Electronic Musician,* and other leading
magazines. His personal website is [JimAikin.net](jimaikin.net).



[1]: http://www.tads.org/
[2]: https://ifdb.org/viewgame?id=fft6pu91j85y4acv
[3]: http://idmillington.github.io/undum/
[4]: https://twinery.org
[5]: https://www.choiceofgames.com/make-your-own-games/choicescript-intro/
[6]: https://intfiction.org
[7]: https://ifdb.org/viewgame?id=cg4j40i7wq34ggo1
[8]: https://ifdb.org/viewgame?id=7t22wbllftv7nuiw
[9]: https://ifdb.org/viewgame?id=r1h3phudfebfbozs
[10]: https://ifdb.org/viewgame?id=dcvk7bgbqeb0a71s
[11]: https://ifdb.org/viewgame?id=g4cgwblf9pzr91u
[12]: https://ifdb.org/viewgame?id=gkfqj59imvobx7b4
[13]: https://ifdb.org/viewgame?id=u4u57v2ggfcqvll7
