Loader.define(['b'],function(b){
    var a = {
        say:function(msg){
            console.log("b has to say before a's speaking: ",b.say(msg));
            console.log("a is saying: " + msg);
        }
    };
    return a;
});
