AP = {}
AP.HOME_PAGE = 'landing'
AP.BaseView = Backbone.View.extend({});
AP.BaseModel = Backbone.Model.extend({});
AP.PageModel = AP.BaseModel.extend({});

AP.AjaxCall = (action, data, dataType, type, callback) ->
	$.ajax {
		url:action,
		data:data,
		cache: false,
		dataType:dataType,
		type: type,
		success: callback
	}

AP.PageView = AP.BaseView.extend {
	el: $("body"),
	events: {
		"click .nav-link": "linkClick"
	},
	linkClick: (e) ->
		e.preventDefault();
		action = e.target.pathname || e.currentTarget.pathname
		if _.isUndefined(action) 
			action = '/'
			
		AP.pageRouter.navigate action, {trigger: true, replace:false}
}

AP.PageRouter = Backbone.Router.extend {
	routes: {
		'*action' : 'fetchContent'
	},
	templateName: '',
	routerPageView:{},
	initialize: () ->
		_pageModel = new AP.PageModel()
		this.routerPageView = new AP.PageView({model:_pageModel})
	, 
	fetchContent: (action) ->
		_this = this;
		if (action is '' || action is '/') 
			action = AP.HOME_PAGE
			$('ul.nav li.active').removeClass('active')
			$('h3.title').html('&nbsp;').removeClass('fade')
		else 
			$('ul.nav li.active').removeClass('active')
			$('ul.nav li[data-target="' + action + '"]').addClass('active')
			$('h3.title').html('Aliza Pai').addClass('fade')
			action = '/' + action

		AP.AjaxCall(action, null, 'json', 'GET', (json) ->
			_this._pageViewSetModel(json)
		)
	,
	_pageViewSetModel: (json) ->
		$('#paiContent').html(Mustache.render(json.view, json.payload))
		# this.routerPageView.setModel(this.templateName, this.payload, this.pageTitle, this.errorFields,!json)
}

$(document).ready  ->
	AP.pageRouter = new AP.PageRouter()
	Backbone.history.start {pushState: true}

