# Search results collection
# =========================
#
# This collections fetches and contains search results. Elementary,
# my dear Watson.

class SearchResults extends Backbone.Collection
  className: '.results-screen'

  parse: (response) ->
    response.query.search

  search: (query, callback) ->
    @fetch
      dataType: 'jsonp'
      url: Wikipedia.searchUrl(query)
      success: callback

window.SearchResults = SearchResults
