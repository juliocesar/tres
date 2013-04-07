class HomeScreen extends Tres.Screen
  className : 'home-screen'
  template  : _.template $('#home-template').html()

  submit: (event) ->
    event.preventDefault()
    form = new Tres.Form @$el.find('form')
    Tres.Router.go "search?query=#{form.attributes().query}"

window.HomeScreen = HomeScreen
