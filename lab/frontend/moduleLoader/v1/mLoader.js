var Loader = (function(window){
    var document = window.document;
    var config = {
        modulePath:"./"
    };
    var callbackArr = [];

    function importModule(moduleName,callback){
        var script = document.createElement("script");
        script.src = config.modulePath + moduleName + ".js";
        document.body.appendChild(script);
        callbackArr.push(callback);

    }
    function define(factory){
        var module = factory.call(this);
        var callback  = callbackArr.pop();
        callback.call(this,module)
    }
    return {
        import:importModule,
        define:define
    }
})(window);
