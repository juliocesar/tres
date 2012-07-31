(function() {
  var Article, Home, Reader, Search, Suggestion, Suggestions, URLs,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  URLs = {
    page: function(name) {
      return "http://en.wikipedia.org/w/api.php?action=parse&page=" + name + "&format=json&prop=text|displaytitle|sections|revid&mobileformat=html";
    },
    search: function(query) {
      return "http://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=" + query + "&format=json&srlimit=10&srprop=";
    }
  };

  Article = (function(_super) {

    __extends(Article, _super);

    function Article() {
      return Article.__super__.constructor.apply(this, arguments);
    }

    Article.prototype.retrieve = function(page, callback) {
      var _this = this;
      return $.ajax({
        url: URLs.page(page),
        dataType: 'jsonp',
        data: {
          page: page
        },
        success: function(response) {
          if (response.error == null) {
            _this.set(response.parse);
          }
          if (_.isFunction(callback)) {
            return callback();
          }
        }
      });
    };

    return Article;

  })(Backbone.Model);

  Suggestion = (function(_super) {

    __extends(Suggestion, _super);

    function Suggestion() {
      return Suggestion.__super__.constructor.apply(this, arguments);
    }

    return Suggestion;

  })(Backbone.Model);

  Suggestions = (function(_super) {

    __extends(Suggestions, _super);

    function Suggestions() {
      return Suggestions.__super__.constructor.apply(this, arguments);
    }

    Suggestions.prototype.model = Suggestion;

    Suggestions.prototype.url = URLs.search;

    Suggestions.prototype.parse = function(response) {
      return response.query.search;
    };

    Suggestions.prototype.search = function(query) {
      return this.fetch({
        dataType: 'jsonp',
        url: URLs.search(query)
      });
    };

    return Suggestions;

  })(Backbone.Collection);

  Home = (function(_super) {

    __extends(Home, _super);

    function Home() {
      return Home.__super__.constructor.apply(this, arguments);
    }

    Home.prototype.id = 'home';

    Home.prototype.template = JST['home'];

    Home.prototype.submit = function(event) {
      var form;
      event.preventDefault();
      form = new Tres.Form(this.$el.find('form'));
      return Tres.Router.navigate("search/" + (encodeURI(form.attributes().query)), true);
    };

    return Home;

  })(Tres.Screen);

  Search = (function(_super) {

    __extends(Search, _super);

    function Search() {
      return Search.__super__.constructor.apply(this, arguments);
    }

    Search.prototype.id = 'search';

    Search.prototype.template = JST['search'];

    Search.prototype.active = function(query) {
      var _ref;
      this.title(query);
      if ((_ref = this.list) == null) {
        this.list = new Tres.List({
          collection: App.Suggestions,
          el: this.$el.find('ul'),
          entry: {
            template: JST['result'],
            url: function() {
              return "article/" + this.model.attributes.title;
            }
          }
        });
      }
      return App.Suggestions.search(query);
    };

    return Search;

  })(Tres.Screen);

  Reader = (function(_super) {

    __extends(Reader, _super);

    function Reader() {
      return Reader.__super__.constructor.apply(this, arguments);
    }

    Reader.prototype.id = 'show-article';

    Reader.prototype.template = JST['article'];

    Reader.prototype.active = function(name) {
      var _this = this;
      this.title(name);
      return this.model.retrieve(name, function() {
        return _this.render();
      });
    };

    return Reader;

  })(Tres.Screen);

  $(function() {
    window.App = new Tres.App;
    App.Suggestions = new Suggestions;
    App.Reader = new Reader({
      model: new Article
    });
    App.on({
      '': new Home,
      'search/:query': new Search,
      'article/:title': App.Reader
    });
    return App.boot({
      root: '/anagen/'
    });
  });

}).call(this);
