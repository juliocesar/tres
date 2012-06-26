$(document).ready(function() {
  window.JST = {
    'screen' : $('#screen-template').html()
  };
  
  window.App = {};
  
  App.Device = new Tres.Device;
  App.Device.on('orientationchange', function() {
    alert("width : " + this.width() + ' - height : ' + this.height());
  });
  
  App.HomeScreen = new Tres.Screen({ template : JST['screen'] });
  
  App.HomeScreen.embed();
});