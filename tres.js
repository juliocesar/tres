(function(window) {
  var Tres = {},
    $ = window.$,
    _ = window._,
    $window = $(window),
    Backbone = window.Backbone;

  var Device = function() {
    var me = this;
    _.extend(me, Backbone.Events);    
        
    me.width = function() { return window.outerWidth; };
    me.height = function() { return window.outerHeight; };
    
    $window.on('orientationchange', _.bind(me.trigger, me, 'orientationchange'));
  };
  
  Tres.Device = Device;

  window.Tres = Tres;
})(this);