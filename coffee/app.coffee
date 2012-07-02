$ ->
  JST = { 'home' : $('#home-template').html(), 'form' : $('#form-template').html() }

  Places = Backbone.Collection.extend()

  HomeScreen    = Tres.Screen.extend(
    template : JST['home']
    active : ->
      places = new Places
      new Tres.List(places, @$el.find('#places'))
      places.reset(
        { id : 1, name : 'Veri Koko' }
        { id : 2, name : 'Koko Loko' }
        { id : 3, name : 'Rio' }
      )

  )
  SecondScreen  = Tres.Screen.extend(
    template : JST['form']
    active : ->
  )
  App           = new Tres.App

  App.on 
    ''            : new HomeScreen
    'second/:id'  : new SecondScreen

  App.boot()