# Tres

Tres is an implementation of a [Backbone.js](http://backbonejs.org/) pattern, which greatly simplifies things by giving views (referred to as "screens") control over all the action that goes on when you're looking at a screen.

This pattern goes really well for mobile web apps, and more so for mobile-specific builds, since it embeds a few best practices suitable for it.

# Using it

Tres is two-fold: a JavaScript (written in CoffeeScript) part, which you'll need if you plan on writing apps with it, and a stylesheet, which works like a "bootstrap" library for common screen/header/footer/scrollable contents arrangements. You'll need to style your app yourself anyway.

# This repo

Tres' GitHub repository is an example application in itself, built using [Hopla](http://hopla.io/). Hopla is a really simple suite built in a Rake file which gives you [Sprockets](http://getsprockets.org).

The standalone library (without the repo) can be downloaded from the repo: both [tres.js](https://raw.github.com/juliocesar/tres/master/tres.js) and [tres.css](https://raw.github.com/juliocesar/tres/master/tres.css).

# What about the Ruby gem?

Tres was initially released as a Ruby gem, and had a set of generators for creating screens, models, and templates. As I increasingly found myself using less of that, and disagreeing with tools like that in principle, I decided to revert the effort into a much simpler library.

That, and the fact I managed to rewrite the entirety of it's back-end features in a single file with a few methods (see Hopla).
