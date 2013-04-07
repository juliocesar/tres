# Readlet Mini UI scripts
# =======================
#
# In case you're wondering what trickery is this, it's Sprockets.
# Check http://getsprockets.org.

#= require jquery-1.9.1.min
#= require underscore-min
#= require backbone-min
#= require tres

## Require all scripts from the screens directory
#= require_tree ./screens

$ ->
  App = new Tres.App

  App.on
    ''                    : new HomeScreen
    'search?query=:query' : new ResultsScreen
    'article?name=:name'  : new ArticleScreen

  App.boot()
