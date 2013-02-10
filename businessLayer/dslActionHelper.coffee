fs = require('fs')
path = require('path')
mongoDB = require ('./mongoDB')
tasks = require('./tasks')

exports.compileAllDSLActions = (callback) ->
	actionDictionary = {}
	fullPath = './dsl/'
	dslFiles = fs.readdirSync(fullPath);
	for file of dslFiles
		fileName = dslFiles[file]
		fullPathFile = path.join fullPath, fileName
		stats = fs.statSync fullPathFile
		if stats.isDirectory() == false
			actionName = fileName.split('.')[0]
			actionDictionary[actionName]?= JSON.parse(fs.readFileSync(fullPathFile,'utf8'))
	callback actionDictionary

exports.executeAction = (req, res, actionName, callback) ->
	dbFilePath = actionName + ".mon"
	htmlFilePath = "public/templates/" + actionName + ".html"
	
	req.__returnData = {}
	if GLOBAL.actionDictionary[actionName]?
		actionJson = GLOBAL.actionDictionary[actionName]
		returnResultSet = {}
		counter = 0
		executeActionSequence req, actionJson, counter, returnResultSet, callback
	else if (fs.existsSync(htmlFilePath))
		callback null, {}

executeActionSequence = (req, actionJson, counter, returnResultSet, callback) ->
	action = actionJson[counter]
	console.log action
	if typeof action is 'string'
		func = action.split('.')
		global[func[0]][func[1]] req, (err, returnValue) ->
			executeNextAction req, actionJson, counter, returnValue, callback
	else if fs.existsSync("dsl/" + req.actionName + ".json")
		executeStep req, action, (err, returnResultSet) ->
			executeNextAction req, actionJson, counter, returnResultSet, callback
	else
		callback null, {}


executeStep = (req, action, callback) ->
	if typeof action is 'object'
		if(action.view?)
			req.__data.view = action.view
		else 
			req.__data.view = req.actionName
		
		db = action.db
		if (db? and fs.existsSync("db/" + db+ ".mon"))
			mongoDB.runScript db, req, (err, returnResultSet) ->
				callback  err, returnResultSet
		else 
			callback null, {}

executeNextAction = (req, actionJson, counter, returnResultSet, callback) ->
	action = actionJson[counter]
	# if typeof action is 'string'
	actionName = action
	if typeof action is 'object'
		if action.propertyName
			actionName = action.propertyName
		else if action.db
			actionName = action.db
		else
			actionName = req.actionName

		addResultsetToRequest req, actionName, returnResultSet
	else if typeof action is 'string' 
		periodIndex = actionName.indexOf ".", 0
		if periodIndex > 0
			actionName = actionName.split('.')[1]

	counter++
	if counter == actionJson.length
		callback  null, returnResultSet
	else
		executeActionSequence req, actionJson, counter, returnResultSet, callback

addResultsetToRequest = (req, propertyName, resultSet) ->
	req.__returnData[propertyName] = resultSet
	if resultSet.length > 0 
		req.__data[propertyName] = resultSet 

