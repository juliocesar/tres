URLs =
  page : (name) -> "http://en.wikipedia.org/w/api.php?action=parse&page=#{name}&format=json&prop=text|displaytitle|sections|revid&mobileformat=html"
  search : (query) -> "http://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=#{query}&format=json&srlimit=10&srprop="

class Article extends Backbone.Model
  retrieve : (page, callback) ->
    $.ajax
      url      : URLs.page(page)
      dataType : 'jsonp'
      data     : { page : page }
      success  : (response) =>
        @set(response.parse) unless response.error?
        callback() if _.isFunction(callback)

class Suggestion extends Backbone.Model
class Suggestions extends Backbone.Collection
  model : Suggestion
  url   : URLs.search
  parse : (response) ->
    response.query.search
  search : (query) ->
    @fetch(dataType : 'jsonp', url : URLs.search(query))

class Home extends Tres.Screen
  id       : 'home'
  template : JST['home']
  submit : (event) ->
    event.preventDefault()
    form = new Tres.Form(@$el.find('form'))
    Tres.Router.navigate "search/#{encodeURI(form.attributes().query)}", true

class Search extends Tres.Screen
  id       : 'search'
  template : JST['search']
  active : (query) ->
    @title(query)
    @list ?= new Tres.List(
      collection : App.Suggestions
      el         : @$el.find('ul')
      entry      : { template : JST['result'], url : -> "article/#{@model.attributes.title}" }
    )
    App.Suggestions.search query

class Reader extends Tres.Screen
  id       : 'show-article'
  template : JST['article']
  active   : (name) ->
    @title(name)
    @model.retrieve name, => @render()

$ ->
  window.App        = new Tres.App
  App.Suggestions   = new Suggestions
  App.Reader        = new Reader(model : new Article)

  App.on
    ''                : new Home
    'search/:query'   : new Search
    'article/:title'  : App.Reader

  App.boot(root : '/anagen/')
