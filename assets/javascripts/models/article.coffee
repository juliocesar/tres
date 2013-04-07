# Article model
# =============
#
# An article. By default they are kept in localStorage at all times,
# and fetched from Wikipedia with retrieve()

class Article extends Backbone.Model
  defaults: 'text': '', 'displaytitle': ''
  idAttribute: 'query'

  url: ->

  isNew: ->
    @get('displaytitle') is ""

  retrieve : (callback) ->
    $.ajax
      url      : Wikipedia.pageUrl(@get 'title')
      dataType : 'jsonp'
      data     : page: @get('title')
      success  : (response) =>
        @set response.parse unless response.error?
        callback() if _.isFunction callback

window.Article = Article
