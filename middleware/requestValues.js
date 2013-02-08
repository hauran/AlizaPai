_ = require('underscore')
tasks = require('../businesslayer/tasks')

exports = module.exports = function requestValues() {
	return function requestValues(req, res, next) {
		req.__data = _.extend({}, req.body);
		next();
	}
};