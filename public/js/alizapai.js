(function() {
  var AP;

  AP = {};

  AP.HOME_PAGE = 'landing';

  AP.BaseView = Backbone.View.extend({});

  AP.BaseModel = Backbone.Model.extend({});

  AP.PageModel = AP.BaseModel.extend({});

  AP.AjaxCall = function(action, data, dataType, type, callback) {
    return $.ajax({
      url: action,
      data: data,
      cache: false,
      dataType: dataType,
      type: type,
      success: callback
    });
  };

  AP.PageView = AP.BaseView.extend({
    el: $("body"),
    events: {
      "click .nav-link": "linkClick"
    },
    linkClick: function(e) {
      var action;
      e.preventDefault();
      action = e.target.pathname || e.currentTarget.pathname;
      if (_.isUndefined(action)) {
        action = '/';
      }
      return AP.pageRouter.navigate(action, {
        trigger: true,
        replace: false
      });
    }
  });

  AP.PageRouter = Backbone.Router.extend({
    routes: {
      '*action': 'fetchContent'
    },
    templateName: '',
    routerPageView: {},
    initialize: function() {
      var _pageModel;
      _pageModel = new AP.PageModel();
      return this.routerPageView = new AP.PageView({
        model: _pageModel
      });
    },
    fetchContent: function(action) {
      var _this;
      _this = this;
      if (action === '' || action === '/') {
        action = AP.HOME_PAGE;
        $('ul.nav li.active').removeClass('active');
        $('h3.title').html('&nbsp;').removeClass('fade');
      } else {
        $('ul.nav li.active').removeClass('active');
        $('ul.nav li[data-target="' + action + '"]').addClass('active');
        $('h3.title').html('Aliza Pai').addClass('fade');
        action = '/' + action;
      }
      return AP.AjaxCall(action, null, 'json', 'GET', function(json) {
        return _this._pageViewSetModel(json);
      });
    },
    _pageViewSetModel: function(json) {
      return $('#paiContent').html(Mustache.render(json.view, json.payload));
    }
  });

  $(document).ready(function() {
    AP.pageRouter = new AP.PageRouter();
    return Backbone.history.start({
      pushState: true
    });
  });

}).call(this);
