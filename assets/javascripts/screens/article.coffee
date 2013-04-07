# Article display screen
# ======================
#
# Shows an individidual article in the screen.

class ArticleScreen extends Tres.Screen
  className : 'article-screen'
  template  : _.template $('#article-template').html()

  events:
    'click .back-button': 'goBack'

  active: (title) ->
    @title title
    @model.set 'title', title
    @model.retrieve =>
      @render()
      @title title

  goBack: ->
    history.back()

window.ArticleScreen = ArticleScreen
