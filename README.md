APG Game Classes
================

This is a game framework written in the Haxe programming language. It doesn't
provide much at all, just some basic management for game objects. 

The core idea in the framework is that each game object has a set of behaviors
and attributes. These are defined at runtime. A game object's behavior is
completely determined by the Behavior objects which have been added to it. This
allows for reuse of behavior code. For example, you only have to write a
"KeyboardControlled" behavior once, and then you can add it to multiple objects.
I found this structure also lends itself well to level editors.

The code is fairly simple, so no documentation is provided. Also, you probably
just shouldn't use this. Go find a more mature game framework. I wrote this
more for my own enjoyment/education than for it to be actually useful.