URLs =
  page : (name) -> "http://en.wikipedia.org/w/api.php?action=parse&page=#{name}&format=json&prop=text|displaytitle|sections|revid&mobileformat=html"
  search : (query) -> "http://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=#{query}&format=json&srlimit=10&srprop=snippet"

class Article extends Backbone.Model
class Articles extends Backbone.Collection
  model : Article

  retrieve : (page) ->
    $.ajax
      url      : URLs.page(page)
      dataType : 'jsonp'
      data     : { page : page }
      success  : (response) =>
        @add response.parse unless response.error?

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
    @router.navigate "search/#{encodeURI(form.attributes().query)}", true


class Search extends Tres.Screen
  id       : 'search'
  template : JST['search']
  active : (query) ->
    @title("Search: #{query}")
    @list ?= new Tres.List(
      collection : App.Suggestions
      el         : @$el.find('ul')
      entry      : { template : JST['result'] }
    )
    App.Suggestions.search query


class Article extends Tres.Screen
  id       : 'article'
  template : JST['article']

$ ->
  window.App             = new Tres.App
  App.Articles    = new Articles
  App.Suggestions = new Suggestions

  App.on
    ''                : new Home
    'search/:query'   : new Search
    'article/:name'   : new Article

  App.boot(root : '/anagen/')
