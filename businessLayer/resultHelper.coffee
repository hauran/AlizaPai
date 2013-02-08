fs = require('fs')
path = require('path')

exports.processResultSet = (req, callback) ->
	console.log req
	callback null, 1
		