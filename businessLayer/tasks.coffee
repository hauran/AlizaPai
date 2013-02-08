fs = require('fs')
_ = require("underscore")

exports.readStoryFile = (req, callback) ->
	_.each req.__data.items, (ele) ->
		fs.readFile ele.file, "ascii", (err, story) ->
			ele.story = story
			callback null, 1