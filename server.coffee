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
  

app.get "/:page/:action?/:id?", (req, res) ->
  actionName = req.params.page
  payload = {};
  dslActionHelper.executeAction req, res, actionName, (err, resultSet) ->
    if err
        next(err)
      else
        payload.data = req.__returnData
        payload.data.id = req.__data.ID
        if (req.__data.params?)
          payload.data.params = req.__data.params
        view = actionName
        if req.__data.view?
          view = req.__data.view
        fs.readFile "public/templates/" + view + ".html", "ascii", (err, htmlView) ->
            res.json({view: htmlView, payload: payload})




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