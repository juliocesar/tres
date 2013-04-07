(function() {
  var $, $body, $window, Backbone, Device, JST, Router, Tres, defaultTemplate, _,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Tres = {};

  $ = window.jQuery;

  _ = window._;

  Backbone = window.Backbone;

  JST = window.JST;

  $window = $(window);

  $body = $('body');

  defaultTemplate = _.template("<header></header>\n<h1>Tres</h1>\n<p>Welcome to Tres</p>");

  Device = (function() {

    function Device() {
      var _this = this;
      _.extend(this, Backbone.Events);
      $window.on('orientationchange', function() {
        _this.trigger('orientation:change');
        $('html').width(window.innerWidth);
        return window.scrollTo(0, 0);
      });
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

  Tres.Device = new Device;

  Tres.Screen = (function(_super) {

    __extends(Screen, _super);

    function Screen() {
      return Screen.__super__.constructor.apply(this, arguments);
    }

    Screen.prototype.tagName = 'section';

    Screen.prototype.__events = {
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
        return this.$el.find('header h1').html(title);
      } else {
        return this.$el.find('header h1').html();
      }
    };

    Screen.prototype.render = function() {
      this.$el.html((this.template || defaultTemplate)(this.model));
      this.$el.addClass('screen');
      this.delegateEvents(_.extend(this.events, this.__events));
      return this;
    };

    Screen.prototype.embed = function() {
      if (this.embedded) {
        return false;
      }
      this.render();
      $body.prepend(this.el);
      this.embedded = true;
      return this;
    };

    Screen.prototype.__submit = function(event) {
      this.submit.apply(this, arguments);
      return this.$el.find(':focus').blur();
    };

    Screen.prototype.submit = function() {};

    Screen.prototype.activate = function() {
      if (!this.modal) {
        $body.find('>section').removeClass('current-screen').css('-webkit-transform', '');
      }
      this.$el.addClass('current-screen');
      if (this.modal) {
        this.$el.addClass('modal-screen');
      }
      this.$el.css({
        '-webkit-transform': 'none'
      });
      if (_.isFunction(this.active)) {
        this.active.apply(this, arguments);
      }
      return $window.trigger('resize');
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
      if (_.isFunction(this.url)) {
        this.delegateEvents({
          'click': 'touch'
        });
      }
      return this;
    };

    ListEntry.prototype.touch = function(event) {
      return Tres.Router.navigate(this.url(), true);
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
      var tag, template, _ref;
      tag = ((_ref = this.entry) != null ? _ref.tagName : void 0) || this._tagMap[this.$el.get(0).tagName];
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
      return _.each(_.keys(model.attributes, function(key) {
        var $el;
        $el = _this.$el.find("[name=\"" + key + "\"]");
        if ($el.is(':checkbox' && model.attributes[key] === true)) {
          return $el.attr('checked', 'checked');
        } else {
          return $el.val(model.attributes[key]);
        }
      }));
    };

    Form.prototype.clear = function() {
      return _.each(this.$el.find(':input', function(el) {
        var $el;
        $el = $(el);
        if ($el.is(':checkbox')) {
          $el.removeAttr('checked');
        }
        return $el.val('');
      }));
    };

    return Form;

  })();

  Router = (function(_super) {

    __extends(Router, _super);

    function Router() {
      return Router.__super__.constructor.apply(this, arguments);
    }

    Router.prototype.go = function(url) {
      return this.navigate(url, {
        trigger: true
      });
    };

    return Router;

  })(Backbone.Router);

  Tres.Router = new Router;

  Tres.App = (function() {

    function App(options) {
      if (options == null) {
        options = {};
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
        return Tres.Router.route(url, _.uniqueId('r'), function() {
          var args, screen;
          screen = map[url];
          if (screen.embedded !== true) {
            screen.embed();
          }
          args = arguments;
          window.scroll(0, 0);
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
        if (_.isFunction(Tres.Router.before)) {
          Tres.Router.before(Backbone.history.getFragment());
        }
        Tres.Router.trigger('navigate');
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
