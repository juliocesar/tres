# Readlet Mini UI scripts
# =======================
#
# In case you're wondering what trickery is this, it's Sprockets.
# Check http://getsprockets.org.

#= require jquery-1.9.1.min
#= require underscore-min
#= require backbone-min
#= require tres

#= require models/wikipedia
#= require_tree ./models
#= require_tree ./screens

$ ->
  App = new Tres.App

  App.on
    ''                     : new HomeScreen
    'search?query=:query'  : new ResultsScreen(collection: new SearchResults)
    'article?title=:title' : new ArticleScreen(model: new Article)

  App.boot()
