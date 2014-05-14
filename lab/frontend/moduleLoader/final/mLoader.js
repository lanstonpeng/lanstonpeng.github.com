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
        this.loadedDepsDic = options.loadedDepsDic || {};
        this.factory = options.factory;
        this.returnValue = options.returnValue;
        this.callback = options.callback;
        this.count = options.count;
    }

    function considerRun(currentModuleName,parentNode){
        var idx = parentNode.deps.indexOf(currentModuleName);
        parentNode.loadedDeps[idx] = loadedModuleDic[currentModuleName].returnValue;
        parentNode.loadedDepsDic[currentModuleName] = 1;
        parentNode.count--;
        checkDependence(parentNode);
        considerDependence(parentNode);
    }
    function considerDependence(node){
        if(!node.count){
            console.log(node.moduleName,"'s factory is running");
            node.returnValue = node.factory.apply(window,node.loadedDeps);
            node.callback && node.callback.call(window,node.moduleName);
        }
    }
    function checkDependence(node){
        var deps = node.deps;
        for(var i = 0 ,len = node.deps.length; i < len;i++){
           if(loadedModuleDic[deps[i]] && !node.loadedDepsDic[deps[i]]){
                node.loadedDeps[i] = loadedModuleDic[deps[i]].returnValue;
                node.count--;
           }
        }
    }
    function onLoadHandler(moduleName,callback){
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
        considerDependence(currentLoadedNode);
    }
    function importModule(moduleName,callback){
        var script = document.createElement("script");
        script.src = config.modulePath + moduleName + ".js";

        if(loadedModuleDic[moduleName]){
            console.log("load",moduleName,"from cached" );
            onLoadHandler(moduleName,callback)
        }
        document.body.appendChild(script);
        script.addEventListener("load",function(){
            onLoadHandler(moduleName,callback);
        });
    }
    function define(deps,factory){
        if(arguments.length == 1){
            factory = deps;
            deps = []
        }
        currentLoadedNode = new Node({
            deps:deps,
            factory:factory,
            count:deps.length
        });
    }

    var main = document.querySelector("script[data-main]");
    importModule(main.getAttribute("data-main"),function(){});
    return {
        define:define
    }
})(window);
