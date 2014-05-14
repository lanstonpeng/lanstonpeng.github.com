var VersionEditor = (function(window){

	var config = {
		getConfigURL:"http://127.0.0.1:5000/getconfig",
		setConfigURL:"http://127.0.0.1:5000/setconfig"
	}
	var $ = function(sel){
		return document.querySelector(sel);
	}
	var randomFuncName;
	function createRandomCallback(randName,callback){
		window[randName] = function(data){
			callback && callback(data);
			window[randName] = null;
		}
	}
	function getConfig(platform,busniess){
		var script = document.createElement("script");
		randomFuncName = "$_" + Math.ceil(Math.random()*1000);	
		createRandomCallback(randomFuncName,function(data){
			AceEditor.init();
			AceEditor.getEditor().setValue(JSON.stringify(data, null, '\t'));
		});

		script.src = [config.getConfigURL,"/",platform,"/",busniess,"?callback=",randomFuncName].join("");	
		document.body.appendChild(script);
		script.onload = function(){
			this.parentNode.removeChild(this);
		}
	}

	function saveConfig(platform,busniess){
		var content = AceEditor.getEditor().getValue(),
			url = "",
			uploadJson = {};

		var randomFuncName = "$_" + Math.ceil(Math.random()*1000);	
		createRandomCallback(randomFuncName,function(data){
			AceEditor.init();
			AceEditor.getEditor().setValue(JSON.stringify(data, null, '\t'));
		});

		var xhr = new XMLHttpRequest();
		xhr.onreadystatechange = function(){
			if(xhr.readyState == 4 && xhr.status == 200){
				debugger;
				console.log(xhr.responseText,"<--");
			}	
		}
		url = [
			config.setConfigURL,"/",
			platform,"/",
			busniess
			//"?callback=",randomFuncName
		].join("");
		uploadJson = JSON.parse(content);
		xhr.open('POST',url,true);
		xhr.setRequestHeader('Content-Type', 'application/json;charset=UTF-8');
		xhr.send(JSON.stringify({
			version:uploadJson["version"],
			author:uploadJson["author"]
		}));
	}
	return {
		getConfig:getConfig,
		saveConfig:saveConfig
	}
})(window);