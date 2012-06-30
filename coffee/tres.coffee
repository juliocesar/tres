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
  tagName : 'section'
  events  : 
    'click a[href]' : 'clickLink'

  initialize : (options = {}) ->
    _.extend @, options

  render : ->
    @$el.html (@template or defaultTemplate)
    @

  embed : ->
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
    @active() if _.isFunction(@active)

  back : ->
    history.back()


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
        screen = _.find(@screens, (screen) => screen is map[url])
        if screen?
          screen.activate()
        else
          map[url].router = @router
          map[url].embed()
          map[url].activate()

  boot : ->
    if _.isFunction(@router.before)
      __super = Backbone.history.loadUrl
      Backbone.history.loadUrl = =>
        @router.before.call @
        @router.trigger 'navigate'
        __super.apply Backbone.history, arguments
    Backbone.history.start(pushState : true)

window.Tres = Tres