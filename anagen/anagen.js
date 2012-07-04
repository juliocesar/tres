(function() {
  var Article, Home, Search,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Home = (function(_super) {

    __extends(Home, _super);

    function Home() {
      return Home.__super__.constructor.apply(this, arguments);
    }

    Home.prototype.id = 'home';

    Home.prototype.template = JST['home'];

    Home.prototype.active = function() {};

    return Home;

  })(Tres.Screen);

  Search = (function(_super) {

    __extends(Search, _super);

    function Search() {
      return Search.__super__.constructor.apply(this, arguments);
    }

    Search.prototype.id = 'search';

    Search.prototype.template = JST['search'];

    return Search;

  })(Tres.Screen);

  Article = (function(_super) {

    __extends(Article, _super);

    function Article() {
      return Article.__super__.constructor.apply(this, arguments);
    }

    Article.prototype.id = 'article';

    Article.prototype.template = JST['article'];

    return Article;

  })(Tres.Screen);

  $(function() {
    window.App = new Tres.App;
    App.on({
      '': new Home,
      '/search/:query': new Search,
      '/article/:name': new Article
    });
    return App.boot({
      root: '/anagen/'
    });
  });

}).call(this);
