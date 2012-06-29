(function() {
  var $, $body, $window, Backbone, JST, Tres, defaultTemplate, _,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Tres = {};

  $ = window.jQuery;

  _ = window._;

  Backbone = window.Backbone;

  JST = window.JST;

  $window = $(window);

  $body = $('body');

  defaultTemplate = "<header></header>\n<h1>Tres</h1>\n<p>Welcome to Tres</p>";

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

    Screen.prototype.events = {
      'click a[href]': 'clickLink'
    };

    Screen.prototype.initialize = function(options) {
      if (options == null) {
        options = {};
      }
      return _.extend(this, options);
    };

    Screen.prototype.render = function() {
      this.$el.html(this.template || defaultTemplate);
      return this;
    };

    Screen.prototype.clickLink = function(event) {
      event.preventDefault();
      return Tres.App.router.navigate($(event.currentTarget).attr('href'), true);
    };

    Screen.prototype.embed = function() {
      this.render();
      return $body.append(this.el);
    };

    Screen.prototype.activate = function() {
      $body.find('>section').removeClass('current');
      this.$el.addClass('current');
      if (_.isFunction(this.active)) {
        return this.active();
      }
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

  Tres.App = {
    router: new Tres.Router,
    on: function(map) {
      var _this = this;
      if (map == null) {
        map = {};
      }
      return _.each(_.keys(map), function(url) {
        return _this.router.route(url, _.uniqueId('r'), function() {
          var screen;
          screen = new map[url];
          screen.embed();
          return screen.activate();
        });
      });
    },
    boot: function() {
      return Backbone.history.start({
        pushState: true
      });
    }
  };

  window.Tres = Tres;

}).call(this);
