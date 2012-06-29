Tres      = {}
$         = window.jQuery
_         = window._
Backbone  = window.Backbone
JST       = window.JST
$window   = $(window)
$body     = $('body')

class Tres.Device
  constructor : ->
    _.extend @, Backbone.Events
    $window.on 'orientationchange', _.bind @trigger, @, 'orientationchange'

  width   : -> window.outerWidth
  height  : -> window.outerHeight


class Tres.Screen extends Backbone.View
  tagName : 'section'

  initialize : (options = {}) ->
    _.extend @, options

  render : ->
    @$el.html @template
    @rendered = true
    @

  embed : ->
    @render() unless @rendered?
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


window.Tres = Tres