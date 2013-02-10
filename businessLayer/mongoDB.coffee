databaseUrl = "alizapai" # "username:password@example.com/mydb"
collections = ["portfolio"]
mongo = require("mongodb")
BSON = mongo.BSONPure
db = require("mongojs").connect(databaseUrl, collections)
fs = require('fs')
path = require('path')
mustache = require('Mustache')

exports.runScript = (templateName, req, callback) ->
	fs.readFile "db/" + templateName + ".mon", "ascii", (err, dbRun) ->
		dbScript = mustache.render(dbRun, req.__data)
		eval(dbScript)