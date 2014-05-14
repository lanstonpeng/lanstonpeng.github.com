Loader.define(['c','b'],function(c,b){
    var a = {
        say:function(msg){
            console.log("a is saying: " + msg);
            b.say(msg);
            c.say(msg);
        }
    };
    return a;
});
