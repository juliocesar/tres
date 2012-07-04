(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  $(function() {
    var App, HomeScreen, JST, Places, SecondScreen;
    JST = {
      'home': $('#home-template').html(),
      'form': $('#form-template').html()
    };
    Places = Backbone.Collection.extend();
    HomeScreen = (function(_super) {

      __extends(HomeScreen, _super);

      function HomeScreen() {
        return HomeScreen.__super__.constructor.apply(this, arguments);
      }

      HomeScreen.prototype.template = JST['home'];

      HomeScreen.prototype.active = function() {
        var places;
        places = new Places;
        new Tres.List(places, this.$el.find('#places'));
        return places.reset({
          id: 1,
          name: 'Veri Koko'
        }, {
          id: 2,
          name: 'Koko Loko'
        }, {
          id: 3,
          name: 'Rio'
        });
      };

      return HomeScreen;

    })(Tres.Screen);
    SecondScreen = (function(_super) {

      __extends(SecondScreen, _super);

      function SecondScreen() {
        return SecondScreen.__super__.constructor.apply(this, arguments);
      }

      SecondScreen.prototype.template = JST['form'];

      SecondScreen.prototype.active = function() {};

      return SecondScreen;

    })(Tres.Screen);
    App = new Tres.App;
    App.on({
      '': new HomeScreen,
      'second/:id': new SecondScreen
    });
    return App.boot();
  });

}).call(this);
