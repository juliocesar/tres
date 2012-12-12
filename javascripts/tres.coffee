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
make      = Backbone.View.prototype.make

# Default screen template
defaultTemplate = _.template """
  <header></header>
  <h1>Tres</h1>
  <p>Welcome to Tres</p>
"""
# ---

# Tres.Device handles/exposes device events (orientation change, accellerometer,
# etc), screen width, and other hardware-related goodies
class Device
  constructor: ->
    _.extend @, Backbone.Events
    $window.on 'orientationchange', =>
      @trigger 'orientation:change'
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
    "click a[href]:not([href^='http://'])": 'touchLink'

    # Provide a convenience method `submit` which gets fired when you
    # submit a form in a screen. You can still trap forms normally.
    # This is just a shortcut in case you have 1 form in a screen
    "submit form": '__submit'

  events: {}

  initialize: (options = {}) ->
    _.extend @, options

  # Returns the title of the screen, which will only exist if there's a
  # header with a <h1> inside of it
  title: (title = null) ->
    if title?
      @$el.find('h1').html title
    else
      @$el.find('h1').html()

  # Renders the screen's template into the container element. Also
  # (re)delegates the screen's events
  render: ->
    @$el.html (@template or defaultTemplate)(@model)
    @delegateEvents _.extend @events, @__events
    @expandVertically()
    @

  # Sets the height of the screen to the maximum possible minus the URL bar
  expandVertically: ->
    @$el.css 'min-height', window.innerHeight+75

  # Embeds a Tres.Screen into the <body>. Returns false in case it's already
  # embedded.
  embed: ->
    return false if @embedded
    @render()
    $body.append @el
    @embedded = true
    @

  # Click/touch on links will trigger pushState, but stay in the app
  touchLink: (event) ->
    event.preventDefault()
    Tres.Router.navigate $(event.currentTarget).attr('href'), true

  # Runs whatever @submit method is declared, with the added bonus of
  # un-focusing any text fields that are currently focused
  __submit: (event) ->
    @submit.apply @, arguments
    @$el.find(':focus').blur()

  # Default @submit to noop
  submit: ->

  # Sets the class "current" to this screen, removing the class from
  # whatever other sections that have it. Call the `active` method in
  # case a screen has one
  activate: ->
    $body.find('>section').removeClass 'current'
    @$el.addClass 'current'
    @active.apply @, arguments if _.isFunction @active

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
  $el: $ make('ul', id: 'notifications')

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

  # All the screens that are currently instanced
  screens: []

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
    __super = Backbone.history.loadUrl
    Backbone.history.loadUrl = =>
      Tres.Router.before.call @ if _.isFunction Tres.Router.before
      Tres.Router.trigger 'navigate'
      __super.apply Backbone.history, arguments
    Backbone.history.start _.extend(options, pushState : true)

# ---

# Export to `window`
window.Tres = Tres
