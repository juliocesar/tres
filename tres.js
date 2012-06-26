(function(window) {
  var Tres = {},
    $ = window.$,
    _ = window._,
    JST = window.JST,
    $window = $(window),
    $body = $('body'),
    Backbone = window.Backbone;

  var Device = function() {
    var me = this;
    _.extend(me, Backbone.Events);    
        
    me.width = function() { return window.outerWidth; };
    me.height = function() { return window.outerHeight; };
    
    $window.on('orientationchange', _.bind(me.trigger, me, 'orientationchange'));
  };
  Tres.Device = Device;
  
  var Screen = Backbone.View.extend({
    tagName : 'section',
    
    initialize : function(options) {
      if (_.isUndefined(options)) options = {};
      _.extend(this, options);
    },
    
    render : function() {
      this.$el.html( this.template );
      this.rendered = true;
      return this;
    },
    
    embed : function() {
      if (!this.rendered) this.render();      
      $body.append(this.el);
    },
    
    back : function(event) {
      history.back();
    }
  });
  Tres.Screen = Screen;

  window.Tres = Tres;
})(this);