$ ->
  window.JST = { 'home' : $('#home-template').html() }

  HomeScreen    = Tres.Screen.extend(template : JST['home'])
  SecondScreen  = Tres.Screen.extend()

  Tres.App.on 
    ''            : HomeScreen
    'second/:id'  : SecondScreen

  Tres.App.boot()

