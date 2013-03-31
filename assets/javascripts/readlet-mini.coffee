# Readlet Mini UI scripts
# =======================
#
# The requires below are all Sprockets. You don't have *have* to use
# Tres with it.

#= require jquery-1.9.1.min
#= require underscore-min
#= require backbone-min
#= require tres

class HomeScreen extends Tres.Screen
  className : 'home-screen'
  template  : _.template $('#home-template').html()

  submit: (event) ->
    event.preventDefault()
    form = new Tres.Form @$el.find('form')
    Tres.Router.go "search?query=#{form.attributes().query}"

class ResultsScreen extends Tres.Screen
  className : 'results-screen'
  template  : _.template $('#results-template').html()

  events:
    'click .result': 'clickResult'
    'click .back-button': 'goBack'

  clickResult: (event) ->
    $li = $ event.target
    Tres.Router.go "article?name=#{$li.data('name')}"

  goBack: ->
    history.back()

class ArticleScreen extends Tres.Screen
  className : 'articles-screen'
  template  : _.template $('#article-template').html()

  events:
    'click .back-button': 'goBack'

  goBack: ->
    history.back()

$ ->
  App = new Tres.App

  App.on
    ''                    : new HomeScreen
    'search?query=:query' : new ResultsScreen
    'article?name=:name'  : new ArticleScreen

  App.boot()
