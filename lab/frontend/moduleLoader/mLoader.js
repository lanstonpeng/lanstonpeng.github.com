var Loader = (function(window){
    var document = window.document;
    var config = {
        modulePath:"./"
    };
    var callbackArr = [];

    var Node = function(moduleName,deps,parent,callback){
        this.moduleName = moduleName;
        this.deps = deps;
        this.callback = callback;
        this.parent = parent;
    }

    function importModule(moduleName,callback){
        var script = document.createElement("script");
        script.src = config.modulePath + moduleName + ".js";
        document.body.appendChild(script);
        //callbackArr.push(callback);
        var node = new Node(moduleName,[],callback);
        script.addEventListener("load",function(){
        });
    }
    function define(deps,factory){
        console.log("define");
        var depModules = [];
        if(arguments.length == 2){
            for(var i = 0 ,len = deps.length;i<len ;i++){
            }
        }
        else{
            factory = deps;
        }
        var module = factory.apply(this,depModules);
        var callback  = callbackArr.pop();
        callback.call(this,module)
    }
    var main = document.querySelector("script[data-main]");
    var mainScript = document.createElement("script");
    mainScript.src = main.getAttribute("data-main") + ".js";
    document.body.appendChild(mainScript);
    mainScript.onload = function(){
       var node = new Node(this.src,[],null,null);
        console.log("onload");
    }
    return {
        define:define
    }
})(window);
