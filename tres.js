(function(window) {
  var Tres    = {},
    $         = window.$,
    _         = window._,
    Backbone  = window.Backbone;
    JST       = window.JST,
    $window   = $(window),
    $body     = $('body');
    

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

    activate : function() {
      $body.find('>section').removeClass('current');
      this.$el.addClass('current');
    },
    
    back : function(event) {
      history.back();
    }
  });
  Tres.Screen = Screen;

  var Router = Backbone.Router.extend({
    initialize : function() {
      if (_.isFunction(this.before)) {
        var __super = Backbone.history.loadUrl,
            before  = this.before,
            router  = this;
        Backbone.history.loadUrl = function(frag) {
          before.call(router);
          router.trigger('navigate');
          __super.apply(this, arguments);
        }
      }

    }
  });
  Tres.Router = Router;

  window.Tres = Tres;
})(this);