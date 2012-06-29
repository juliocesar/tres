(function() {
  var $, $body, $window, Backbone, JST, Tres, _,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Tres = {};

  $ = window.jQuery;

  _ = window._;

  Backbone = window.Backbone;

  JST = window.JST;

  $window = $(window);

  $body = $('body');

  Tres.Device = (function() {

    function Device() {
      _.extend(this, Backbone.Events);
      $window.on('orientationchange', _.bind(this.trigger, this, 'orientationchange'));
    }

    Device.prototype.width = function() {
      return window.outerWidth;
    };

    Device.prototype.height = function() {
      return window.outerHeight;
    };

    return Device;

  })();

  Tres.Screen = (function(_super) {

    __extends(Screen, _super);

    function Screen() {
      return Screen.__super__.constructor.apply(this, arguments);
    }

    Screen.prototype.tagName = 'section';

    Screen.prototype.initialize = function(options) {
      if (options == null) {
        options = {};
      }
      return _.extend(this, options);
    };

    Screen.prototype.render = function() {
      this.$el.html(this.template);
      this.rendered = true;
      return this;
    };

    Screen.prototype.embed = function() {
      if (this.rendered == null) {
        this.render();
      }
      return $body.append(this.el);
    };

    Screen.prototype.activate = function() {
      $body.find('>section').removeClass('current');
      return this.$el.addClass('current');
    };

    Screen.prototype.back = function() {
      return history.back();
    };

    return Screen;

  })(Backbone.View);

  Tres.Router = (function(_super) {

    __extends(Router, _super);

    function Router() {
      return Router.__super__.constructor.apply(this, arguments);
    }

    Router.prototype.initialize = function() {
      var before, router, __super,
        _this = this;
      if (_.isFunction(this.before)) {
        __super = Backbone.history.loadUrl;
        before = this.before;
        router = this;
        return Backbone.history.loadUrl = function() {
          before.call(_this);
          router.trigger('navigate');
          return __super.apply(_this, arguments);
        };
      }
    };

    return Router;

  })(Backbone.Router);

  window.Tres = Tres;

}).call(this);
