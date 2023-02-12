# Appendix B: Updating Older Extensions

## Updating Extensions

Extensions are an important and convenient way of extending the
functionality of Inform 7. Many of them are available. Older extensions
are archived on the Inform 7 website, and can be downloaded from there –
but they won’t necessarily work with 6L38. In fact, they probably won’t.
If you want to try, find your Inform Extensions folder (in Windows it’s
in My Documents), add a folder named after the author of the extension,
and put the .i7x file in this folder. The next time you launch Inform,
the extension will appear in the Extensions pane.

By the time you read this, more of the older extensions may have
migrated to the wonderful new Public Library. This feature eliminates
the need to check the Inform 7 website for new or updated extensions –
just go to the Public Library tab under the Extensions tab, scroll down
to the bottom, and click the download button. But if an extension that
you’d like to use isn’t available in the Public Library, you may want to
grab it from inform7.com and try to update it yourself.

Some older extensions may work in the latest version of Inform
without any changes. [Patrollers by Michael Callaghan](https://github.com/i7/archive/blob/master/Michael%20Callaghan/Patrollers.i7x), for instance,
seems to require no changes. With other extensions, the needed changes
may be so massive that considerable study may be required. In between
these two categories, however, are some extensions that can easily be
tidied up. If you see one on the Inform 7 website’s Extensions page that
you think might be useful, feel free to download it, install it by
putting it in a folder in your Extensions folder, and give it a try.

At this writing, for instance, [Far Away by Jon Ingold](https://github.com/i7/extensions/blob/10.1/Jon%20Ingold/Far%20Away-v5.i7x), which is
designed to deal with things that can be seen in the distance but are
too far away to be touched, has not been upgraded for 6L38
compatibility. Updating it turns out to be quite easy.

After installing it, open it in the Inform IDE from File > Open
Extensions > Jon Ingold. The main incompatibility in this Extension
is that it uses the old “change … to” syntax, which is no longer
supported. The new syntax is “now … is”. Use the Find command to find
all instances of the word “change” and edit those lines so that they
read, for example:

```
now the far-off-object is n;
```


Only one other change is needed. Inform no longer uses the word
“consider” for sending the game off to a list of rules in the Standard
Rules. The new term is “follow.” So this line:

```
consider the distant-objects rules for the far-off-object;
```


won’t compile until you change “consider” to “follow.”

The code “if using … option” is another non-functional bit of syntax.
In [Considerate Holdall by Jon Ingold](https://github.com/i7/archive/blob/master/Jon%20Ingold/Considerate%20Holdall.i7x), for example, we find this
line:

```
if not using the inline implicit library option, disallow
stashing;
```


This syntax has to be changed to “if the … option is active”:

```
if the inline implicit library option is active, disallow
stashing;
```


Both Considerate Holdall and another useful extension, Secret Doors
by Andrew Owen, suffer from a different problem. They rely on an
outdated method of printing messages for the player to read.
(Considerate Holdall also has two lines where the word “when” is
duplicated, but that’s easy to fix.) Here are the two code blocks in
Considerate Holdall that don’t work:

```
To print the you can't go message:
    (- L__M(##Go, 2, 0); -).

To print the you can't see message:
    (- L__M(##Miscellany, 30, 0); -).
```


The L__M refers to Library Messages, a system that Inform no longer
employs. By taking a cruise through the Standard Rules, you can find the
new method of printing these messages, and edit the code so that it
looks like this:

```
To print the you can't go message:
	say "[We] [can't go] that way."
To print the you can't see message:
	say "[We] [can't] see any such thing."
```


Once you’ve made these changes, Secret Doors will work just fine.

A bigger problem in some extensions is procedural rules. At one time,
these were used to bypass normal rules in the Standard Library under
certain conditions, but they’re no longer allowed. One way to get around
this is to write a new rule that replaces the normal rule, insert it in
place of the normal rule, and add the required conditions to it. The
handy phrase “do nothing” has the effect of bypassing the rule. Here’s a
quick example, not from an extension but from the 2009 edition of this
*Handbook.* The “Dangerous Jewel Box” example in Appendix C
originally contained this code:

```
A procedural rule: if taking gems when the jewel box is dangerous
then ignore the announce items from multiple object lists rule.

A procedural rule: if removing gems from the jewel box when the jewel
box is dangerous then ignore the announce items from multiple object
lists rule.
```


The idea behind this code, obviously, was to bypass the “announce
items from multiple object lists rule” in one specific game situation.
Here’s how the same code looks today – a new rule that replaces the old
rule, checks the game-specific situation, and says “do nothing” if
that’s what’s needed:

```

This is the new announce items from multiple object lists rule:
	if the current item from the multiple object list is not nothing:
		if taking gems when the jewel box is dangerous:
			do nothing;
		else if removing gems from the jewel box when the jewel box is dangerous:
			do nothing;
		else:
			say "[current item from the multiple object list]: [run paragraph on]".

The new announce items from multiple object lists rule is listed instead of the announce items from multiple object lists rule in the action-processing rules.
```

