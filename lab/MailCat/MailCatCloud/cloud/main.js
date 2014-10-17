require("cloud/app.js");

var mg = require('mailgun');

AV.Cloud.define("sendmail",function(request,response){
    var MailComposer = require("mailcomposer").MailComposer,
        mailcomposer = new MailComposer();

    var longhtml = '';


    mailcomposer.setMessageOption({
        from: "andris@tr.ee",
        to: "lanstonpeng@gmail.com",
        body: "Hello world!",
        html: longhtml
    });

    mailcomposer.buildMessage(function(err, messageSource){
        console.log(err || messageSource);

        var m = new mg.Mailgun("key-9febcc3d7295dc80e5591f0f6784a663");
        m.sendRaw('sender@example.com',
            ['lanstonpeng@gmail.com'],
            messageSource,
            function(err) { err && console.log(err) });


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


