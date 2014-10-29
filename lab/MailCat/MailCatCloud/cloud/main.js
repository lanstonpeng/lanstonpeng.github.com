require("cloud/app.js");

var mg = require('mailgun');
var exec = require('child_process').exec
var Mustache = require("mustache");
var fs = require("fs");
var Req = require("request");

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
    var dayLeft = request.params["dayLeft"];
    var receiverName = request.params["receiverName"];
    var clipBody = rawBody.substring(0,50);

    var command = [
        "curl -s --user 'api:key-9febcc3d7295dc80e5591f0f6784a663'",
        "https://api.mailgun.net/v2/sandbox07642907a9c24ad988d7ee436bb30a9b.mailgun.org/messages",
        "-F from='MailCat <postman@mailcat.me>'",
        "-F to='" + sendToEmail + "'",
        "-F subject='你有来自MailCat的信件'",
        "-F text='" + clipBody +"'",
        "--form-string html='<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\" \"http://www.w3.org/TR/REC-html40/loose.dtd\"> <html> <head></head>",
        '<h2>您好</h2>',
        '<p>有人刚刚写了一封信件给你,来自',senderMail ? senderMail : "想保持神秘感的TA",'</p>',
        "<p>&nbsp;</p>",
        '<p><strong><span style="color: rgb(51, 51, 51); font-family: Helvetica Neue, Helvetica, Arial, Hiragino Sans GB, Microsoft Yahei, sans-serif; font-size: 16px; line-height: 22.3999996185303px;">',
        '<p>',receiverName,"</p>",
        clipBody,
        '......</span></strong></p>',
        "<p>信件已经在派送当中了，预计需要 ",dayLeft," 天</p>",
        "<p>欢迎到 MailCat 查看TA给您写的完整的信，同时您也可以给TA回信</p>",
        "</html>'"
    ].join(" ");

    //console.log(command);
    /*
    execute(command,function(result){
        response.success(result);
    });
    */
        var m = new mg.Mailgun("key-9febcc3d7295dc80e5591f0f6784a663");
        m.sendRaw('mailcat@vtmer.com',
            [sendToEmail],
            output,
            function(err) {
                console.log(arguments);
                //err && console.log(err)
            });
});

AV.Cloud.define("sendPreviewMail",function(request,response){
    var sendToEmail = request.params["sendToMail"];
    var rawBody = request.params["body"];
    var senderMail = request.params["senderMail"];
    var hourLeft = request.params["hourLeft"];
    var receiverName = request.params["receiverName"];
    var clipBody = "  " +  rawBody.substring(0,50);

    var templatePath = __dirname + "/views/template.html";

    //Req.get("http://mailcat.avosapps.com/template.html",function(err,res,data){
    //});

    fs.readFile(templatePath,'utf8',function(err,data){
        console.log(data);
        var json = {
            "sendToEmail": sendToEmail,
            "hourLeft":hourLeft,
            "senderEmail":senderMail ? senderMail.split("@")[0] : "某只猫",
            "clipBody":clipBody,
            "receiverName":receiverName
        };

        var output = Mustache.render(data, json);

        var command = [
            "curl -s --user 'api:key-9febcc3d7295dc80e5591f0f6784a663'",
            "https://api.mailgun.net/v2/mailcat.me/messages",
            "-F from='MailCat <postman@mailcat.me>'",
            "-F to='" + sendToEmail + "'",
            "-F subject='来自MailCat的信件'",
            "-F text='" + clipBody +"'",
            "--form-string html='" + output +"'"
        ].join(" ");

        execute(command,function(result){
            response.success(result);
        });
    });
});

AV.Cloud.define("hello", function(request, response) {
    Req.get("http://mailcat.avosapps.com/template.html",function(err,res,body){
        response.success(body);
    });
});



//Hook
AV.Cloud.afterSave("LetterData",function(request){
    var query = new AV.Query("_User");
    var sendToEmail = request.object.get("sendToEmail");
    query.equalTo("email", sendToEmail);
    query.first({
        success:function(object){
            object.set("hasNewMail",true);
            object.save();
        },
        error:function(obj){
            console.log("update user data error");
        }
    })
});

AV.Cloud.afterUpdate("LetterData",function(request){
    var sendToEmail = request.object.get("sendToEmail");
    var queryLetter = new AV.Query("LetterData");
    queryLetter.equalTo("sendToEmail",sendToEmail);
    queryLetter.find({
        success:function(results){
            var needToChangeNewMailFlag = false;
            for(var i = 0,len = results.length;i<len;i++)
            {
                var item = results[i];
                var letterStatus = item.get("letterStatus");
                if(letterStatus != 5){
                    needToChangeNewMailFlag = true;
                    break;
                }
            }
            var queryUser = new AV.Query("_User");
            queryUser.equalTo("email", sendToEmail);
            queryUser.first({
                success:function(object){
                    object.set("hasNewMail",needToChangeNewMailFlag);
                    object.save();
                },
                error:function(obj){
                    console.log("update user data error after updating");
                }
            })
        },
        error:function(){
            console.log("update failded");
        }
    });


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


