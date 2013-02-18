fs = require('fs')
_ = require("underscore")
async = require("async")
nodemailer = require("nodemailer")

smtpTransport = nodemailer.createTransport("SMTP",{
    service: "Gmail",
    auth: {
        user: "alizapai@gmail.com",
        pass: "XXXXXXXXXX"
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
	if req.__data.title? and req.__data.title=='sent'
		req.__returnData.sent = true
	callback null, 1

exports.sendEmail = (req, callback) ->
	reqData = req.__data
	mailOptions = {
	    from: reqData.name + '<' + reqData.email + '>',
	    replyTo:reqData.email,
	    to:'alizapai@gmail.com',
	    subject:'AlizaPai.com Contact',
	    text: reqData.body + '\n\n----\n' + reqData.name + '\n' + reqData.email
	}
	smtpTransport.sendMail mailOptions, (error, response) ->
	    if(error)
	        console.log(error)
	    else
	        console.log("Message sent: " + response.message);

	callback null, 1