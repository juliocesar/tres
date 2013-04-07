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

window.ResultsScreen = ResultsScreen
