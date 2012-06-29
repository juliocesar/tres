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
      '': function() {
        return new HomeScreen;
      },
      'second': function() {
        return new SecondScreen;
      }
    });
    return Tres.App.boot();
  });

}).call(this);
