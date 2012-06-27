$(document).ready(function() {
  window.JST = {
    'screen' : $('#screen-template').html()
  };
  
  window.App = {};
  App.Device = new Tres.Device;

  var HomeScreen = Tres.Screen.extend({
    template : JST['screen']
  });
  
  App.HomeScreen = new HomeScreen;

  var Router = Tres.Router.extend({
    routes : {
      '' : 'home'
    },

    home : function() {
      App.HomeScreen.embed();
      App.HomeScreen.activate();
    }
  });

  App.Router = new Router;

  Backbone.history.start({pushState : true});
});