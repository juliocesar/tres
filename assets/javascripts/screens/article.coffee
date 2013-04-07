class ArticleScreen extends Tres.Screen
  className : 'articles-screen'
  template  : _.template $('#article-template').html()

  events:
    'click .back-button': 'goBack'

  goBack: ->
    history.back()

window.ArticleScreen = ArticleScreen
