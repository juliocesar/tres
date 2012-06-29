(function() {

  $(function() {
    var HomeScreen, SecondScreen;
    window.JST = {
      'home': $('#home-template').html()
    };
    HomeScreen = Tres.Screen.extend({
      template: JST['home']
    });
    SecondScreen = Tres.Screen.extend();
    Tres.App.on({
      '': HomeScreen,
      'second/:id': SecondScreen
    });
    return Tres.App.boot();
  });

}).call(this);
