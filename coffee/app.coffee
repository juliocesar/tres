$ ->
  window.JST = { 'home' : $('#home-template').html() }

  HomeScreen    = Tres.Screen.extend(template : JST['home'])
  SecondScreen  = Tres.Screen.extend()
  window.App           = new Tres.App(router : new Tres.Router(before : -> alert('before')))

  App.on 
    ''            : HomeScreen
    'second/:id'  : SecondScreen

  App.boot()

