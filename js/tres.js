(function() {
  var $, $body, $window, Backbone, JST, Tres, defaultTemplate, make, _,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Tres = {};

  $ = window.jQuery;

  _ = window._;

  Backbone = window.Backbone;

  JST = window.JST;

  $window = $(window);

  $body = $('body');

  make = Backbone.View.prototype.make;

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

    Screen.prototype._events = {
      "click a[href]:not('.outlink')": 'touchLink',
      "submit form": 'submit'
    };

    Screen.prototype.events = {};

    Screen.prototype.initialize = function(options) {
      if (options == null) {
        options = {};
      }
      return _.extend(this, options);
    };

    Screen.prototype.render = function() {
      this.$el.html(this.template || defaultTemplate);
      this.delegateEvents(_.extend(this.events, this._events));
      return this;
    };

    Screen.prototype.embed = function() {
      if (this.embedded) {
        return false;
      }
      this.render();
      $body.append(this.el);
      this.embedded = true;
      return this;
    };

    Screen.prototype.touchLink = function(event) {
      event.preventDefault();
      return this.router.navigate($(event.currentTarget).attr('href'), true);
    };

    Screen.prototype.submit = function() {};

    Screen.prototype.activate = function() {
      $body.find('>section').removeClass('current');
      this.$el.addClass('current');
      if (_.isFunction(this.active)) {
        return this.active(arguments);
      }
    };

    return Screen;

  })(Backbone.View);

  Tres.List = (function(_super) {

    __extends(List, _super);

    function List() {
      return List.__super__.constructor.apply(this, arguments);
    }

    List.prototype._tagMap = {
      'UL': 'LI',
      'OL': 'LI',
      'DIV': 'DIV'
    };

    List.prototype.initialize = function(collection, el) {
      this.collection = collection;
      this.setElement(el);
      this.collection.on('add', this._add, this);
      this.collection.on('remove', this._remove, this);
      return this.collection.on('reset', this._addAll, this);
    };

    List.prototype._add = function(model) {
      var child;
      child = this.make(this._tagMap[this.$el.get(0).tagName], null, model.get('name'));
      model.template = child;
      this.$el.append(child);
      return this.$el;
    };

    List.prototype.remove = function(model) {
      return model.template.remove();
    };

    List.prototype._addAll = function() {
      var _this = this;
      this.$el.empty();
      return this.collection.each(function(model) {
        return _this._add(model);
      });
    };

    return List;

  })(Backbone.View);

  Tres.Form = (function() {

    function Form($el) {
      this.$el = $el;
    }

    Form.prototype.fieldset = function(filter) {
      return new Tres.Form(this.$el.find('fieldset').filter(filter));
    };

    Form.prototype.attributes = function(options) {
      var attributes, inputs;
      if (options == null) {
        options = {};
      }
      attributes = {};
      if (options.only != null) {
        inputs = this.$el.find("" + options.only + " :input[name]");
      } else {
        inputs = this.$el.find(':input[name]');
        _.each(inputs, function(el) {
          var $el;
          $el = $(el);
          if ($el.is(':checkbox')) {
            return attributes[$el.attr('name')] = $el.is(':checked');
          } else {
            return attributes[$el.attr('name')] = $el.val();
          }
        });
      }
      return attributes;
    };

    Form.prototype.setFromModel = function(model) {
      var _this = this;
      return _.each(_.keys(model.attributes), function(key) {
        var $el;
        $el = _this.$el.find("[name=\"" + key + "\"]");
        if ($el.is(':checkbox') && model.attributes[key] === true) {
          return $el.attr('checked', 'checked');
        } else {
          return $el.val(model.attributes[key]);
        }
      });
    };

    Form.prototype.clear = function() {
      _.each(this.$el.find(':input'), function(el) {
        var $el;
        $el = $(el);
        if ($el.is(':checkbox')) {
          $el.removeAttr('checked');
        }
        return $el.val('');
      });
      return this;
    };

    return Form;

  })();

  Tres.Notifier = {
    $el: $(make('ul', {
      id: 'notifications'
    })),
    notify: function(message, options) {
      var $li,
        _this = this;
      if (options == null) {
        options = {
          duration: 5000,
          type: 'exclamation-sign'
        };
      }
      this.$el.appendTo($body);
      $li = $(make('li', {
        "class": "icon-" + options.type
      }, message));
      this.$el.append($li);
      return $li.slideDown(250, function() {
        return _.delay(function() {
          return $li.slideUp(function() {
            return $li.remove();
          });
        }, options.duration);
      });
    }
  };

  Tres.Router = (function(_super) {

    __extends(Router, _super);

    function Router() {
      return Router.__super__.constructor.apply(this, arguments);
    }

    Router.prototype.initialize = function(options) {
      if (options == null) {
        options = {};
      }
      return _.extend(this, options);
    };

    return Router;

  })(Backbone.Router);

  Tres.App = (function() {

    function App(options) {
      if (options == null) {
        options = {
          router: new Tres.Router
        };
      }
      _.extend(this, options);
    }

    App.prototype.screens = [];

    App.prototype.on = function(map) {
      var _this = this;
      if (map == null) {
        map = {};
      }
      return _.each(_.keys(map), function(url) {
        return _this.router.route(url, _.uniqueId('r'), function() {
          var screen;
          screen = _.find(_this.screens, function(screen) {
            return screen === map[url];
          }) || map[url];
          if (!screen.embedded) {
            screen.router = _this.router;
            screen.embed();
          }
          return _.delay((function() {
            return screen.activate(arguments);
          }), 100);
        });
      });
    };

    App.prototype.boot = function(options) {
      var __super,
        _this = this;
      if (options == null) {
        options = {
          pushState: true
        };
      }
      if (_.isFunction(this.router.before)) {
        __super = Backbone.history.loadUrl;
        Backbone.history.loadUrl = function() {
          _this.router.before.call(_this);
          _this.router.trigger('navigate');
          return __super.apply(Backbone.history, arguments);
        };
      }
      return Backbone.history.start(options);
    };

    return App;

  })();

  window.Tres = Tres;

}).call(this);
