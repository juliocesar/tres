$ ->
  window.JST = { 'home' : $('#home-template').html() }

  HomeScreen    = Tres.Screen.extend(template : JST['home'])
  SecondScreen  = Tres.Screen.extend()

  Tres.App.on 
    ''        : -> new HomeScreen
    'second'  : -> new SecondScreen


  Tres.App.boot()

