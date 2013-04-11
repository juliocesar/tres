# Tres
# ====

# The whole framework should fit nicely in a single file. Avoid magic,
# avoid indirection

# Grab all variables to shorter references we'll use throughout
Tres      = {}
$         = window.jQuery
_         = window._
Backbone  = window.Backbone
JST       = window.JST
$window   = $ window
$body     = $ 'body'

# Default screen template
defaultTemplate = _.template """
  <header></header>
  <h1>Tres</h1>
  <p>Welcome to Tres</p>
"""
# ---

# Keep a copy by reference of all screens that were instantiated so we
# can do things like tearing down the whole app.
Tres.screens = []

# Tres.Device handles/exposes device events (orientation change, accellerometer,
# etc), screen width, and other hardware-related goodies
class Device
  constructor: ->
    _.extend @, Backbone.Events
    $window.on 'orientationchange', =>
      @trigger 'orientation:change'
      # Fix <html> not stretching beyond 320px
      $('html').width window.innerWidth
      window.scrollTo 0, 0

  width: -> window.outerWidth
  height: -> window.outerHeight
  orientation: ->

Tres.Device = new Device

# ---

# Tres.Screen is the base screen class. So you'll pretty have one of these for
# each "route" in your app
class Tres.Screen extends Backbone.View

  # Defaults to using sections for screens
  tagName: 'section'

  # Ensure one can still declare events in a view without getting in the
  # way of the defaults
  __events:

    # Provide a convenience method `submit` which gets fired when you
    # submit a form in a screen. You can still trap forms normally.
    # This is just a shortcut in case you have 1 form in a screen
    "submit form": '__submit'

  events: {}

  initialize: (options = {}) ->
    _.extend @, options
    Tres.screens.push @

  # Returns the title of the screen, which will only exist if there's a
  # header with a <h1> inside of it
  title: (title = null) ->
    if title?
      @$el.find('header h1').html title
    else
      @$el.find('header h1').html()

  # Renders the screen's template into the container element, and applies
  # the screen's events and the default screen class
  render: ->
    @$el.html (@template or defaultTemplate)(@model)
    @$el.addClass 'screen'
    @delegateEvents _.extend @events, @__events
    @

  # Embeds a Tres.Screen into the <body>. Returns false in case it's already
  # embedded
  embed: ->
    return false if @embedded
    @render()
    $body.prepend @el
    @embedded = yes
    @

  # Destroys the element associated with the screen and flags as
  # not embedded
  teardown: ->
    @$el.remove()
    @embedded = no
    @

  # Runs whatever @submit method is declared, with the added bonus of
  # un-focusing any text fields that are currently focused
  __submit: (event) ->
    @submit.apply @, arguments
    @$el.find(':focus').blur()

  # Default @submit to noop
  submit: ->

  # Sets the class "current" to this screen, removing the class from
  # whatever other sections that have it. Call the `active` method in
  # case a screen has one. Removes -webkit-transform to prevent Webkit from
  # screwing a whole lot of stuff
  activate: ->
    if not @modal
      $body.find('>section')
        .removeClass('current')
        .css '-webkit-transform', ''
    @$el.addClass 'current'
    @$el.addClass 'modal' if @modal
    @$el.css '-webkit-transform': 'none'
    @active.apply @, arguments if _.isFunction @active
    $window.trigger 'resize'

# ---

# This class is used as controller for each Tres.List item
class Tres.ListEntry extends Backbone.View
  initialize : (options = {}) ->
    _.extend @, options

  render: ->
    @$el.html @template @model
    @delegateEvents 'click': 'touch' if _.isFunction @url
    @

  # If a @url method is defined, means we want the user to touch and
  # visit the URL
  touch: (event) ->
    Tres.Router.navigate @url(), true

# ---

# Tres.List is a convenience class for rendering lists of things
class Tres.List extends Backbone.View

  # A map of likely child tags for each parent tag
  _tagMap :
    'UL'  : 'LI'
    'OL'  : 'LI'
    'DIV' : 'DIV'

  # Keep the DOM in sync with all interactions made with the collection
  initialize: (options = {}) ->
    _.extend @, options
    @setElement @el
    @collection.on 'add',     @__add,    @
    @collection.on 'remove',  @__remove, @
    @collection.on 'reset',   @__addAll, @

  # Adds one record to the list, wrapping it in a Tres.List
  __add: (model) ->
    tag = @entry?.tagName or @_tagMap[@$el.get(0).tagName]
    template = new Tres.ListEntry _.extend(@entry, { tagName : tag, model : model })
    model.template = template
    @$el.append template.render().el

  # Removes the list from the DOM
  __remove: (model) ->
    model.template.remove()

  # Adds all the elements the @collection to the list, removing any existing
  # ones
  __addAll: ->
    @$el.empty()
    @collection.each (model) => @__add model

  # Deletes the instance of Tres.List, ensuring any bound events to
  # @collection are removed
  remove: ->
    @collection.off() if @collection?
    super

# ---

# Handles form submissions and a few other helpers such as accessing
# fieldsets individually, and loading model data into fields
class Tres.Form

  # Takes a jQuery-wrapped form object
  constructor: (@$el) ->

  # Returns a new instance of Tres.Form, narrowed down to a single
  # fieldset
  fieldset: (filter) ->
    new Tres.Form @$el.find('fieldset').filter(filter)

  # Returns all the form data in a single object, in key/value
  # pairs by `name` attribute and value
  attributes: (options = {})->
    attributes = {}
    if options.only?
      inputs = @$el.find "#{options.only} :input[name]"
    else
      inputs = @$el.find ':input[name]'
      _.each inputs, (el) ->
        $el = $ el
        if $el.is ':checkbox'
          attributes[ $el.attr 'name' ] = $el.is ':checked'
        else
          attributes[ $el.attr 'name' ] = $el.val()
    attributes

  # Fills the form's fields whose `name` match the model's attributes
  setFromModel: (model) ->
    _.each _.keys model.attributes, (key) =>
      $el = @$el.find "[name=\"#{key}\"]"
      if $el.is ':checkbox' and model.attributes[key] is true
        $el.attr 'checked', 'checked'
      else
        $el.val model.attributes[key]

  # Clears the form
  clear: ->
    _.each @$el.find ':input', (el) ->
      $el = $ el
      $el.removeAttr 'checked' if $el.is ':checkbox'
      $el.val ''

# ---

# Handles displaying in-app notifications
Tres.Notifier =
  $el: $('<ul id="notifications"></ul>')

  notify : (message, options = { duration : 5000, type : 'exclamation-sign' }) ->
    @$el.appendTo $body
    $li = $ make 'li', { class: "icon-#{options.type}" }, message
    @$el.append $li
    $li.slideDown 250, =>
      _.delay =>
        $li.slideUp => $li.remove()
      , options.duration

# ---

# Just a regular Backbone.Router for now. You'll have one for application
class Router extends Backbone.Router

Tres.Router = new Router

# ---

class Tres.App

  constructor: (options = {}) ->
    _.extend @, options

  # Takes a hash to use as a mapping of URLs -> Tres.Screen objects
  on: (map = {}) ->
    _.each _.keys(map), (url) =>
      Tres.Router.route url, _.uniqueId('r'), =>
        screen = map[url]
        screen.embed() unless screen.embedded is true
        args = arguments
        window.scroll 0, 0
        _.defer => screen.activate.apply screen, args

  # Boots the app, executing the routes and adding a handy `before`
  # event to the router
  boot: (options = {}) ->
    options = _.extend pushState: true, options
    __super = Backbone.history.loadUrl
    Backbone.history.loadUrl = =>
      if _.isFunction Tres.Router.before
        Tres.Router.before Backbone.history.getFragment()
      Tres.Router.trigger 'navigate'
      __super.apply Backbone.history, arguments
    Backbone.history.start options

  # Tears down every screen that was instantiated. Pass a list
  # of arguments for types of screen that you'd like to stay
  # intact
  reboot: ->
    for screen in Tres.screens
      screen.teardown()

# ---

# Export to `window`
window.Tres = Tres
