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
	el: $("body")
	,events: {
		"click .nav-link": "linkClick",
		"submit form.post-form": "postForm"
	}
	,linkClick: (e) ->
		e.preventDefault()
		$target = $(e.target)
		action = $target.data('href')

		if !action? #try getting data-href from parent
			action = $target.closest('.nav-link').data('href')
		if !action? #get href
			action = e.target.pathname or e.currentTarget.pathname
			if e.target.search
				action = action + e.target.search;

		if _.isUndefined(action) 
			action = '/'
			
		AP.pageRouter.navigate action, {trigger: true, replace:false}
	
	,postForm:(e) ->
		e.preventDefault();
		postAction = $(e.target).attr('action');
		jsonData = $(e.target).serializeJSON();
		AP.AjaxCall postAction, jsonData, 'json', 'POST', (json) ->
			console.log(json)
			AP.pageRouter.navigate json.action, {trigger:true, replace:true}
		
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
			highlight = action
			console.log action
			if action.indexOf('/') > 0
				highlight = action.split('/')[0]
			$('ul.nav li[data-target="' + highlight + '"]').addClass('active')
			$('h3.title').html('Aliza Pai').addClass('fade')
			action = '/' + action

		AP.AjaxCall action, null, 'json', 'GET', (json) ->
			_this._pageViewSetModel(json)
	,
	_pageViewSetModel: (json) ->
		$('#paiContent').html(Mustache.render(json.view, json.payload))
		# this.routerPageView.setModel(this.templateName, this.payload, this.pageTitle, this.errorFields,!json)
}

(($) ->
  $.fn.serializeJSON = ->
    json = {}
    jQuery.map $(this).serializeArray(), (n, i) ->
      json[n["name"]] = n["value"]

    json
) jQuery

$(document).ready  ->
	AP.pageRouter = new AP.PageRouter()
	Backbone.history.start {pushState: true}

	
