$ ->
  window.App = new Tres.App
  App.Collections = {}
  App.Models      = {}
  App.Screens     = {}

  App.on
    ''    : new HomeScreen

  App.boot()
