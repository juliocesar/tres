Tres      = {}
$         = window.jQuery
_         = window._
Backbone  = window.Backbone
JST       = window.JST
$window   = $(window)
$body     = $('body')

defaultTemplate = """
  <header></header>
  <h1>Tres</h1>
  <p>Welcome to Tres</p>
"""

class Tres.Device
  constructor : ->
    _.extend @, Backbone.Events
    $window.on 'orientationchange', _.bind @trigger, @, 'orientationchange'

  width   : -> window.outerWidth
  height  : -> window.outerHeight

class Tres.Screen extends Backbone.View
  tagName   : 'section'

  # Ensure one can still declare events in a view without getting in the way of the defaults.
  _events   : 
    'click a[href]' : 'clickLink'

  events    : {}

  initialize : (options = {}) ->
    _.extend @, options

  render : ->
    @$el.html (@template or defaultTemplate)
    @delegateEvents _.extend(@events, @_events)
    @

  embed : ->
    return false if @embedded
    @render()
    $body.append @el
    @embedded = true
    @

  clickLink : (event) ->
    event.preventDefault()
    @router.navigate $(event.currentTarget).attr('href'), true

  activate : ->
    $body.find('>section').removeClass 'current'
    @$el.addClass 'current'
    @active(arguments) if _.isFunction(@active)

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
        screen.activate(arguments)

  boot : ->
    if _.isFunction(@router.before)
      __super = Backbone.history.loadUrl
      Backbone.history.loadUrl = =>
        @router.before.call @
        @router.trigger 'navigate'
        __super.apply Backbone.history, arguments
    Backbone.history.start(pushState : true)


window.Tres = Tres