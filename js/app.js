(function() {

  $(function() {
    var App, HomeScreen, JST, Places, SecondScreen;
    JST = {
      'home': $('#home-template').html()
    };
    Places = Backbone.Collection.extend({
      fetch: function() {
        return this.reset({
          id: 1,
          name: 'Veri Koko'
        }, {
          id: 2,
          name: 'Koko Loko'
        }, {
          id: 3,
          name: 'Rio'
        });
      }
    });
    HomeScreen = Tres.Screen.extend({
      template: JST['home'],
      active: function() {
        var places;
        places = new Places;
        new Tres.List(places, this.$el.find('#places'));
        return places.fetch();
      }
    });
    SecondScreen = Tres.Screen.extend();
    App = new Tres.App;
    App.on({
      '': new HomeScreen,
      'second/:id': new SecondScreen
    });
    return App.boot();
  });

}).call(this);
