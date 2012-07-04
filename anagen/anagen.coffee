class Home extends Tres.Screen
  id       : 'home'
  template : JST['home']
  active : ->

class Search extends Tres.Screen
  id       : 'search'
  template : JST['search']

class Article extends Tres.Screen
  id       : 'article'
  template : JST['article']


$ ->
  window.App = new Tres.App
  App.on
    ''                : new Home
    '/search/:query'  : new Search
    '/article/:name'  : new Article
  App.boot(root : '/anagen/')
