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
      $window.on('orientationchange', _.bind(this.trigger, this, 'orientation:change'));
    }

    Device.prototype.width = function() {
      return window.outerWidth;
    };

    Device.prototype.height = function() {
      return window.outerHeight;
    };

    Device.prototype.orientation = function() {};

    return Device;

  })();

  Tres.Screen = (function(_super) {

    __extends(Screen, _super);

    function Screen() {
      return Screen.__super__.constructor.apply(this, arguments);
    }

    Screen.prototype.tagName = 'section';

    Screen.prototype.__events = {
      "click a[href]:not('.outlink')": 'touchLink',
      "submit form": '__submit'
    };

    Screen.prototype.events = {};

    Screen.prototype.initialize = function(options) {
      if (options == null) {
        options = {};
      }
      return _.extend(this, options);
    };

    Screen.prototype.title = function(title) {
      if (title == null) {
        title = null;
      }
      if (title != null) {
        return this.$el.find('h1').html(title);
      } else {
        return this.$el.find('h1').html();
      }
    };

    Screen.prototype.render = function() {
      this.$el.html(this.template || defaultTemplate);
      this.delegateEvents(_.extend(this.events, this.__events));
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

    Screen.prototype.__submit = function(event) {
      this.submit.apply(this, arguments);
      return this.$el.find(':focus').blur();
    };

    Screen.prototype.submit = function() {};

    Screen.prototype.activate = function() {
      $body.find('>section').removeClass('current');
      this.$el.addClass('current');
      if (_.isFunction(this.active)) {
        return this.active.apply(this, arguments);
      }
    };

    return Screen;

  })(Backbone.View);

  Tres.ListEntry = (function(_super) {

    __extends(ListEntry, _super);

    function ListEntry() {
      return ListEntry.__super__.constructor.apply(this, arguments);
    }

    ListEntry.prototype.initialize = function(options) {
      if (options == null) {
        options = {};
      }
      return _.extend(this, options);
    };

    ListEntry.prototype.render = function() {
      this.$el.html(this.template(this.model));
      return this;
    };

    return ListEntry;

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

    List.prototype.initialize = function(options) {
      if (options == null) {
        options = {};
      }
      _.extend(this, options);
      this.setElement(this.el);
      this.collection.on('add', this.__add, this);
      this.collection.on('remove', this.__remove, this);
      return this.collection.on('reset', this.__addAll, this);
    };

    List.prototype.__add = function(model) {
      var tag, template;
      tag = this.entry.tagName || this._tagMap[this.$el.get(0).tagName];
      template = new Tres.ListEntry(_.extend(this.entry, {
        tagName: tag,
        model: model
      }));
      model.template = template;
      return this.$el.append(template.render().el);
    };

    List.prototype.__remove = function(model) {
      return model.template.remove();
    };

    List.prototype.__addAll = function() {
      var _this = this;
      this.$el.empty();
      return this.collection.each(function(model) {
        return _this.__add(model);
      });
    };

    List.prototype.remove = function() {
      if (this.collection != null) {
        this.collection.off();
      }
      return List.__super__.remove.apply(this, arguments);
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
          router: new Tres.Router,
          device: new Tres.Device
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
          var args, screen;
          screen = map[url];
          if (screen.embedded !== true) {
            screen.router = _this.router;
            screen.embed();
          }
          args = arguments;
          return _.defer(function() {
            return screen.activate.apply(screen, args);
          });
        });
      });
    };

    App.prototype.boot = function(options) {
      var __super,
        _this = this;
      if (options == null) {
        options = {};
      }
      __super = Backbone.history.loadUrl;
      Backbone.history.loadUrl = function() {
        if (_.isFunction(_this.router.before)) {
          _this.router.before.call(_this);
        }
        _this.router.trigger('navigate');
        return __super.apply(Backbone.history, arguments);
      };
      return Backbone.history.start(_.extend(options, {
        pushState: true
      }));
    };

    return App;

  })();

  window.Tres = Tres;

}).call(this);
