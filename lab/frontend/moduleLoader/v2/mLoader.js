var Loader = (function(window){
    var document = window.document;
    var config = {
        modulePath:"./"
    };
    var callbackArr = [];
    var currentLoadedNode,
        loadedModuleDic = {};

    var Node = function(options){
        this.moduleName = options.moduleName;
        this.factory = options.factory;
        this.callback = options.callback;
    }

    function onLoadHandler(moduleName){
        currentLoadedNode.moduleName = moduleName;
        var cb = function(moduleName){
            currentLoadedNode.returnValue = currentLoadedNode.factory.apply(window,[]);
        }
        cb.call(window,moduleName);
    }
    function importModule(moduleName,callback){
        var script = document.createElement("script");
        script.src = config.modulePath + moduleName + ".js";

        document.body.appendChild(script);
        script.addEventListener("load",function(){
            onLoadHandler(moduleName);
        });
    }
    function define(factory){
        currentLoadedNode = new Node({
            factory:factory
        });
    }

    var main = document.querySelector("script[data-main]");
    importModule(main.getAttribute("data-main"),function(){});

    return {
        define:define
    }
})(window);
