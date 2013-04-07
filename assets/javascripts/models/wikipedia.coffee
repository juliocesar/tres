# Wikipedia URLs module
# =====================
#
# An object with 2 functions that returns URLs, one for each of the
# app's features: searching and displaying.

Wikipedia =
  pageUrl: (name) ->
    "http://en.wikipedia.org/w/api.php?action=parse&page=#{name}&format=json&prop=text|displaytitle|revid&mobileformat=html"
  searchUrl : (query) ->
    "http://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=#{query}&format=json&srlimit=10&srprop="

window.Wikipedia = Wikipedia
