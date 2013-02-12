express = require("express")
util = require("util")
http = require("http")
fs = require("fs")
path = require("path")
_ = require("underscore")

dslActionHelper = require('./businesslayer/dslActionHelper')
GLOBAL.actionDictionary = {}
dslActionHelper.compileAllDSLActions (actionDictionary) ->
  GLOBAL.actionDictionary = actionDictionary


XMLHttpRequest = require("xmlhttprequest").XMLHttpRequest
app = module.exports = express()
app.configure ->
  requestValues = require './middleware/requestValues'
  singlePage = require './middleware/singlePage'
  app.engine "html", require("ejs").renderFile
  app.set "view options",
    layout: false

  app.set "views", __dirname + "/public"
  app.set "view engine", "ejs"
  app.use express.bodyParser()
  app.use express.cookieParser()
  app.use express.static(__dirname + "/public")
  app.use express.methodOverride()
  app.use singlePage(indexPage: "index.html")
  app.use requestValues()
  app.use app.router

ip = process.env.OPENSHIFT_NODEJS_IP or "127.0.0.1"
port = process.env.OPENSHIFT_NODEJS_PORT or 8888
console.log "--------------------"
console.log ip, port
app.listen port, ip
  

app.get '/:action/:title?', (req, res, next) ->
  actionName = req.params.action
  queryStringJson = qs.parse(url.parse(req.url).query)
  _.extend(req.__data, queryStringJson)
  payload = {}

  # if (req.params.name)
  #   actionName = req.params.name

  title = req.params.title
  if (title? and title.indexOf("?") != -1)
    params = title.split("?")
    title = params[0]
    req.__data.params = params[1]

  req.actionName = actionName
  if title?
    req.__data.title = title  

  dslActionHelper.executeAction req, res, actionName, (err, resultSet) ->
    if err
        next(err)
      else
        payload.data = req.__returnData
        if (req.__data.params?)
          payload.data.params = req.__data.params
        view = actionName
        if req.__data.view?
          if typeof req.__data.view is 'string'
            view = req.__data.view
          else 
            if payload.data.items?
              if payload.data.items.length > 1
                view = req.__data.view.listing
              else
                view = req.__data.view.details
            else
              view = actionName
        fs.readFile "public/templates/" + view + ".html", "ascii", (err, htmlView) ->
            res.json({view: htmlView, payload: payload})

app.post '/post/:name', (req, res, next) ->
  actionName = req.params.name
  queryStringJson = qs.parse(url.parse(req.url).query)
  _.extend(req.__data, queryStringJson)
  payload = {}

  dslActionHelper.executeAction req, res, actionName, (err, resultSet) -> 
    if err
      next(err)
    else
      payload.data = req.__returnData
      res.json({action: req.__data.nextAction, payload: payload}, 200)  



String::replaceAll = (replaceThis, withThis) ->
  @replace new RegExp(replaceThis, "g"), withThis

String::trim = ->
  @replace(/^\s\s*/, "").replace /\s\s*$/, ""

isNull = (obj) ->
  if obj is null or typeof obj is "undefined"
    true
  else
    false

rand = (max) ->
  Math.floor Math.random() * max