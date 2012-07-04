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

class Article extends Tres.Screen
  id       : 'article'
  template : JST['article']


$ ->
  window.App = new Tres.App
  App.on
    ''                : new Home
    'search/:query'  : new Search
    'article/:name'  : new Article
  App.boot(root : '/anagen/')
