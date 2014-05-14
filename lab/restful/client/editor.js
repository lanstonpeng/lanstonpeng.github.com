 

 var AceEditor = (function(window){
 	var editor; 

    function isJSONValid(){
    	return editor.getSession().getAnnotations().length > 0 ? false :true;
    }
    function isFillAuthor(){
    	var value = editor.getValue();
    	var json = JSON.parse(value);
    	return json.author.length > 0 ? true : false;
    }
    function init(){
 		editor = ace.edit("editor");
	    editor.setTheme("ace/theme/tomorrow");
	    editor.getSession().setMode("ace/mode/javascript");
    }
    function getEditor(){
    	return editor;	
    }
    return {
    	init: init,
    	isJSONValid:isJSONValid,
    	getEditor : getEditor,
    	isFillAuthor:isFillAuthor
    }
 })(window);