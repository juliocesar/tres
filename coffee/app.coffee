$ ->
  JST = { 'home' : $('#home-template').html() }

  HomeScreen    = Tres.Screen.extend(template : JST['home'])
  SecondScreen  = Tres.Screen.extend()
  App           = new Tres.App

  App.on 
    ''            : new HomeScreen
    'second/:id'  : new SecondScreen

  App.boot()

