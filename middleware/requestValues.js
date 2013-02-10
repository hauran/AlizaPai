_ = require('underscore')
tasks = require('../businesslayer/tasks')
helper = require('../businesslayer/helper')
url = require('url')
qs = require('querystring')

exports = module.exports = function requestValues() {
	return function requestValues(req, res, next) {
		req.__data = _.extend({}, req.body);
		next();
	}
};