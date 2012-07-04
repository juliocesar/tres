Tres      = {}
$         = window.jQuery
_         = window._
Backbone  = window.Backbone
JST       = window.JST
$window   = $(window)
$body     = $('body')
make      = Backbone.View.prototype.make

defaultTemplate = """
  <header></header>
  <h1>Tres</h1>
  <p>Welcome to Tres</p>
"""

# Tres.Device handles/exposes device events (orientation change, accellerometer, etc), screen width, and 
# other hardware-related goodies.
class Tres.Device
  constructor : ->
    _.extend @, Backbone.Events
    $window.on 'orientationchange', _.bind @trigger, @, 'orientationchange'

  width   : -> window.outerWidth
  height  : -> window.outerHeight

# Tres.Screen is the base screen class. So you'll pretty have one of these for each "route" in your app.
class Tres.Screen extends Backbone.View

  # Always use sections
  tagName   : 'section'

  # Ensure one can still declare events in a view without getting in the way of the defaults.
  _events   : 
    # Click/touch on links will trigger pushState, but stay in the app. Except
    # for links with the "outlink" class.
    "click a[href]:not('.outlink')" : 'touchLink'

    # Provide a convenience method `submit` which gets fired when you submit a form in a screen.
    # You can still trap forms normally. This is just a shortcut in case you have 1 form in a screen.
    "submit form"                   : 'submit'

  events    : {}

  initialize : (options = {}) ->
    _.extend @, options

  render : ->
    @$el.html (@template or defaultTemplate)
    @delegateEvents _.extend(@events, @_events)
    @

  # Embeds a Tres.Screen into the <body>. Returns false in case it's already embedded.
  embed : ->
    return false if @embedded
    @render()
    $body.append @el
    @embedded = true
    @

  touchLink : (event) ->
    event.preventDefault()
    @router.navigate $(event.currentTarget).attr('href'), true

  submit : ->

  # Sets the class "current" to this screen, removing the class from whatever other sections
  # that have it. Call the `active` method in case a screen has one.
  activate : ->
    $body.find('>section').removeClass 'current'
    @$el.addClass 'current'
    @active(arguments) if _.isFunction(@active)

# Tres.List is a convenience class for rendering lists of things, interactible or not.
class Tres.List extends Backbone.View
  _tagMap    :
    'UL'    : 'LI'
    'OL'    : 'LI'
    'DIV'   : 'DIV'

  initialize : (@collection, el) ->
    @setElement(el)
    @collection.on 'add',     @_add,    @
    @collection.on 'remove',  @_remove, @
    @collection.on 'reset',   @_addAll, @

  _add : (model) ->
    child = @make @_tagMap[@$el.get(0).tagName], null, model.get('name')
    model.template = child
    @$el.append child
    @$el

  remove : (model) ->
    model.template.remove()

  _addAll : ->
    @$el.empty()
    @collection.each (model) => @_add(model)  

class Tres.Form
  constructor : (@$el) ->
  
  fieldset : (filter) ->
    new Tres.Form(@$el.find('fieldset').filter(filter))
      
  attributes : (options = {})->
    attributes = {}
    if options.only?
      inputs = @$el.find("#{options.only} :input[name]")
    else
      inputs = @$el.find(':input[name]')
      _.each inputs, (el) ->
        $el = $(el)
        if $el.is(':checkbox')
          attributes[ $el.attr('name') ] = $el.is(':checked')
        else
          attributes[ $el.attr('name') ] = $el.val()
    attributes
  
  setFromModel : (model) ->
    _.each _.keys(model.attributes), (key) =>
      $el = @$el.find("[name=\"#{key}\"]")
      if $el.is(':checkbox') and model.attributes[key] is true
        $el.attr('checked', 'checked')
      else
        $el.val model.attributes[key]
  
  clear : ->
    _.each @$el.find(':input'), (el) ->
      $el = $(el)
      $el.removeAttr('checked') if $el.is(':checkbox')
      $el.val('')
    @


Tres.Notifier =
  $el : $(make('ul', id : 'notifications'))

  notify : (message, options = { duration : 5000, type : 'exclamation-sign' }) ->
    @$el.appendTo $body
    $li = $(make('li', { class : "icon-#{options.type}"}, message))
    @$el.append $li
    $li.slideDown 250, =>
      _.delay =>
        $li.slideUp => $li.remove()
      , options.duration


class Tres.Router extends Backbone.Router
  initialize : (options = {}) ->
    _.extend @, options
    

class Tres.App
  constructor : (options = {router : new Tres.Router}) ->
    _.extend @, options

  screens : []

  on : (map = {}) ->
    _.each _.keys(map), (url) =>
      @router.route url, _.uniqueId('r'), =>
        screen = (_.find(@screens, (screen) => screen is map[url]) or map[url])
        unless screen.embedded
          screen.router = @router
          screen.embed()
        _.defer => screen.activate(arguments))

  boot : (options = { pushState : true }) ->
    if _.isFunction(@router.before)
      __super = Backbone.history.loadUrl
      Backbone.history.loadUrl = =>
        @router.before.call @
        @router.trigger 'navigate'
        __super.apply Backbone.history, arguments
    Backbone.history.start(options)


window.Tres = Tres