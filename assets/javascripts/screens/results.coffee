# Search results screen
# =====================
#
# This screen displays a list of 10 search results. When tapped, it takes
# the user to the article screen.

class ResultsScreen extends Tres.Screen
  className : 'results-screen'
  template  : _.template $('#results-template').html()

  events:
    'click .results-list li' : 'clickResult'
    'click .back-button'     : 'goBack'

  active: (query) ->
    @clearResults()
    @title "Results for #{query}"
    @collection.search query, => @addAllResults()

  addAllResults: ->
    @clearResults()
    @collection.each (result) => @addResult result

  addResult: (result) ->
    template = _.template $('#results-entry-template').html()
    @$el.find('.results-list').append template result

  clearResults: ->
    $list = @$el.find '.results-list'
    $list.empty()

  clickResult: (event) ->
    $li = $ event.target
    Tres.Router.go "article?title=#{$li.data('title')}"

  goBack: ->
    history.back()

window.ResultsScreen = ResultsScreen
