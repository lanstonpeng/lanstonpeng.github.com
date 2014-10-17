require("cloud/app.js");

var mg = require('mailgun');
var exec = require('child_process').exec

AV.Cloud.define("sendmail",function(request,response){
    var MailComposer = require("mailcomposer").MailComposer,
        mailcomposer = new MailComposer();



    var sendToEmail = request.params["sendToMail"];
    var rawBody = request.params["body"];
    var senderMail = request.params["senderMail"];
    var clipBody = rawBody.substring(0,20);


    var longhtml = '<style>h2{color:red}<style><h2>' + clipBody + '</h2>';
    console.log(request);
    console.log("==========\n\n");
    mailcomposer.setMessageOption({
        from: "mailcat@vtmer.com",
        subject:"来自 " + senderMail + " 的邮件",
        to: sendToEmail,
        body: clipBody,
        html: longhtml
    });

    mailcomposer.buildMessage(function(err, messageSource){
        var m = new mg.Mailgun("key-9febcc3d7295dc80e5591f0f6784a663");
        console.log(messageSource);
        m.sendRaw('mailcat@vtmer.com',
            [sendToEmail],
            messageSource,
            function(err) { err && console.log(err) });
    });

});

function execute(command, callback){
    exec(command, function(error, stdout, stderr){
        callback(stdout);
    });
};

AV.Cloud.define("newSendMail",function(request,response){

    var sendToEmail = request.params["sendToMail"];
    var rawBody = request.params["body"];
    var senderMail = request.params["senderMail"];
    var clipBody = rawBody.substring(0,20);

    var command = [
        "curl -s --user 'api:key-9febcc3d7295dc80e5591f0f6784a663'",
        "https://api.mailgun.net/v2/sandbox07642907a9c24ad988d7ee436bb30a9b.mailgun.org/messages",
        "-F from='MailCat <postman@mailcat.me>'",
        "-F to='" + sendToEmail + "'",
        "-F subject='你有来自MailCat的信件'",
        "-F text='" + clipBody +"'",
        "--form-string html='<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\" \"http://www.w3.org/TR/REC-html40/loose.dtd\"> <html> <head></head> <body style=\"color:orange\">" + clipBody + "</body> </html>'"
    ].join(" ");

    console.log(command);
    execute(command,function(result){
        console.log(result);
        response.success(result);
    });
});

AV.Cloud.define("hello", function(request, response) {
  response.success("sup man");
});

AV.Cloud.define("averageStars", function(request, response) {
  var query = new AV.Query("TestObject");
  query.find({
    success: function(results) {
      response.success(results.length);
    },
    error: function() {
      response.error("movie lookup failed");
    }
  });
});


