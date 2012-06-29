$ ->
  window.JST = { 'screen' : $('#screen-template').html() }

  HomeScreen  = Tres.Screen.extend(template : JST['screen'])
  Router      = Tres.Router.extend(
    routes : 
      ''    : 'home'

      home  : ->
        App.HomeScreen.embed()
        App.HomeScreen.activate()
  )

  App = 
    Device      : new Tres.Device
    HomeScreen  : new HomeScreen
    Router      : new Router

  Backbone.history.start(pushState : true)