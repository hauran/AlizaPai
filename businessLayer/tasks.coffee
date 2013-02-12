fs = require('fs')
_ = require("underscore")
async = require("async")
nodemailer = require("nodemailer")

smtpTransport = nodemailer.createTransport("SMTP",{
    service: "Gmail",
    auth: {
        user: "onedaysale@gmail.com",
        pass: "Rad!)head6955"
    }
})

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
	reqData = req.__data
	mailOptions = {
	    from: reqData.name + '<' + reqData.email + '>',
	    to:'richardmai@gmail.com',
	    subject:'sent from AlizaPai.com - Contact',
	    text:reqData.body
	}
	smtpTransport.sendMail mailOptions, (error, response) ->
	    if(error)
	        console.log(error)
	    else
	        console.log("Message sent: " + response.message);

	callback null, 1