fs = require('fs')
_ = require("underscore")
async = require("async")

exports.readStoryFile = (req, callback) ->
	async.forEach req.__data.items, (ele) ->
		ele.storyText = fs.readFileSync ele.file, "ascii"
	callback null, 1

exports.markStory = (req, callback) ->
	async.forEach req.__data.items, (ele) ->
		ele.story =  true
	callback null, 1

exports.markPortfolio = (req, callback) ->
	async.forEach req.__data.items, (ele) ->
		ele.portfolio =  true
	callback null, 1

exports.emailSent = (req, callback) ->
	if req.__data.title? and req.__data.title=='complete'
		req.__returnData.complete = true
	callback null, 1

exports.sendEmail = (req, callback) ->
	console.log 'send email', req.__data
	callback null, 1