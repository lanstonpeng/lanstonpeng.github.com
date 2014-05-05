/*
 Question
    between define and onload,is there any chance for other module to finish onload

 TODO

 context saving
 问题在在无依赖的Node调用完后如何调用父级的依赖检测callback
 * */
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
        this.deps = options.deps;
        this.loadedDeps = options.loadedDeps || [];
        this.factory = options.factory;
        this.returnValue = options.returnValue;
        this.callback = options.callback;
    }

    function considerRun(currentModuleName,parentNode){
        if(!parentNode) return;
        var idx = parentNode.deps.indexOf(currentModuleName);
        parentNode.loadedDeps.push(loadedModuleDic[currentModuleName].returnValue);
        parentNode.deps.splice(idx,1);
        if(!parentNode.deps.length){
            parentNode.returnValue = parentNode.factory.apply(window,parentNode.loadedDeps);
        }
    }
    function importModule(moduleName,callback){
        var script = document.createElement("script");
        script.src = config.modulePath + moduleName + ".js";
        document.body.appendChild(script);

        script.addEventListener("load",function(){
            console.log(moduleName ," loaded");
            currentLoadedNode.moduleName = moduleName;
            loadedModuleDic[moduleName] = currentLoadedNode;

            var dependence = currentLoadedNode.deps;
            for(var i = 0 ,len = dependence.length;i<len ;i++){
                //check if exists
                if(!loadedModuleDic[dependence[i]]){
                    var cb = (function(currentLoadedNode){
                                return function(moduleName){
                                    considerRun(moduleName,currentLoadedNode);
                                }
                             })(currentLoadedNode);

                    importModule(dependence[i],cb);
                }
            }
            currentLoadedNode.callback = callback;
            if(!currentLoadedNode.deps.length){
                callback && callback.call(window,currentLoadedNode.moduleName);
            }
        });
    }
    function define(deps,factory){
        if(arguments.length == 2){
        }
        else{
            factory = deps;
            deps = []
        }

        currentLoadedNode = new Node({
            deps:deps,
            factory:factory
        });
    }

    var main = document.querySelector("script[data-main]");
    importModule(main.getAttribute("data-main"),function(){
        considerRun("main",null);
    });
    return {
        define:define
    }
})(window);
