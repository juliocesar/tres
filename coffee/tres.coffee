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

  clickLink : (event) ->
    event.preventDefault()
    Tres.App.router.navigate $(event.currentTarget).attr('href'), true

  embed : ->
    @render()
    $body.append @el

  activate : ->
    $body.find('>section').removeClass 'current'
    @$el.addClass 'current'

  back : ->
    history.back()


class Tres.Router extends Backbone.Router
  initialize : ->
    if _.isFunction(@before)
      __super = Backbone.history.loadUrl
      before  = @before
      router  = @
      Backbone.history.loadUrl = =>
        before.call @
        router.trigger 'navigate'
        __super.apply @, arguments

Tres.App = 
  router : new Tres.Router

  on : (map = {}) ->
    _.each _.keys(map), (url) =>
      screen = map[url]()
      @router.route url, "r#{_.uniqueId('r')}", ->
        screen.embed()
        screen.activate()

  boot : ->
    Backbone.history.start(pushState : true)

window.Tres = Tres