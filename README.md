# Tres

Tres is (will be) a mobile web development framework based in Backbone.js. The idea is instead of using
a bunch of jQuery plugins and whatnot, you'll build your application as you'd build a regular Backbone
app: you write the markup, declare the JS classes for each view, and style everything using CSS. A good 
good looking theme will be provided, as well as transitions.

# Roadmap

1. Standalone JS file and CSS includes.
2. Console interface, with generators for models, collections, and screens.
3. Ruby library, Rails and Sinatra interfaces.

# Classes

* Tres.Device
  - Will track events such as orientation change, and keep info such as width/height, supported 
  features, etc.
* Tres.Screen
  - A screen, with some features such as a fixed header/footer and momentum scrolling.
* Tres.SwipeSet
  - This class wraps a set of `Tres.Screen`s and allows for swipe navigation across them.
* Tres.List
  - A simple list, bindable to a `Backbone.Collection`.
* Tres.ListEntry
  - Contained by `Tres.List`. You can make it clickable by adding a `click` method to it. Renders
  differently depending on that.
* Tres.Form
  - A <form> wrapper class to capture data from it, and handle submitting and validations. Most
  likely tied to a `Backbone.Model`. Note: not likely this will generate the form from a model's
  attributes, since that means we need to define a schema for the model, and in which case we're 
  replicating what Backbone.Forms does. Just go and use it instead.
* Tres.Notifications
  - Displays animated notifications, clickable or not.
  
Tentative stuff, but could be handled later by plugins.

* Tres.Map
  - A Google map screen, with some helpers to ease the capture/insertion of data from it.

# Usage
  
Here's roughly how I envision building an application:

  class Book extends Backbone.Model
  class Books extends Backbone.Collection
    model : Book
    url   : '/books'

  class HomeScreen extends Tres.Screen
    id        : 'home'
    template  : JST['home']
    
  class Router extends Tres.Router
    routes :
      ''  : 'home'
      
    home : ->
      home = new HomeScreen
      list = new Tres.List(collection : (new Books))      
      home.render()
      home.add list
      
      list.fetch()
  
  $ ->    
    window.App = 
      Device  : new Tres.Device
      Router  : new Tres.Router
    
    Backbone.history.start(pushState : true)
    
# Styles

As much as the philosophy is "stay out the way" and will remain so, a basic theme will be provided which
uses exclusively fonts for icons and CSS3. That's in conformity with the trend of high resolution displays.

# Thoughts

Readme-oriented development is your friend!