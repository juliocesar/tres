$ ->
  JST = { 'home' : $('#home-template').html() }

  Places = Backbone.Collection.extend(
    fetch : ->
      @reset(
        { id : 1, name : 'Veri Koko' }
        { id : 2, name : 'Koko Loko' }
        { id : 3, name : 'Rio' }
      )
  )

  HomeScreen    = Tres.Screen.extend(
    template : JST['home']
    active : ->
      places = new Places
      new Tres.List(places, @$el.find('#places'))
      places.fetch()
  )
  SecondScreen  = Tres.Screen.extend()
  App           = new Tres.App

  App.on 
    ''            : new HomeScreen
    'second/:id'  : new SecondScreen

  App.boot()

