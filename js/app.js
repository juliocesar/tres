(function() {

  $(function() {
    var SecondScreen;
    window.JST = {
      'home': $('#home-template').html()
    };
    window.HomeScreen = Tres.Screen.extend({
      template: JST['home']
    });
    SecondScreen = Tres.Screen.extend();
    window.App = new Tres.App;
    App.on({
      '': new HomeScreen,
      'second/:id': new SecondScreen
    });
    return App.boot();
  });

}).call(this);
