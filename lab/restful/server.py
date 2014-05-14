import os.path
import simplejson
from time import strftime
from flask import Flask
from flask import request
from flask import render_template
from flask import jsonify
from functools import wraps
from flask import make_response, request, current_app
from datetime import timedelta
from functools import update_wrapper
app = Flask(__name__)

CONFIG = {
    "configPath":"./config/"
}

def access_controll_allow_all(f):
    def wrapper(*args, **kwargs):
        response = make_response(f(*args, **kwargs))
        response.headers['Access-Control-Allow-Origin'] = "*"
        response.headers['Access-Control-Allow-Methods'] = "*"
        response.headers['Access-Control-Allow-Headers'] = "*"
        return response
    f.provide_automatic_options = False
    return update_wrapper(wrapper, f)



def support_jsonp(f):
    """Wraps JSONified output for JSONP"""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        callback = request.args.get('callback', False)
        if callback:
            content = str(callback) + '(' + str(f(*args,**kwargs).data) + ')'
            return current_app.response_class(content, mimetype='application/javascript')
        else:
            return f(*args, **kwargs)
    return decorated_function


def constructEditJson(original):
   json = {}
   json["version"] = original["version"]
   json["author"] = ""
   json["name"] = original["name"]
   return json

def getFile(platform,fileName):
    fName = CONFIG["configPath"] + platform +"/"+ fileName + ".conf"
    if os.path.isfile(fName):
        fileRef = open(fName,'r')
        content = fileRef.read()
        jsonObj = simplejson.loads(content)
        editableJson = constructEditJson(jsonObj)
        return jsonify(editableJson)
    else:
        return "no " + fileName  + " config"

def writeFile(fileName):
    pass

@app.route("/getconfig/web/<business>")
@support_jsonp
def getWebConfig(business):
    return getFile("web",business)

@app.route("/getconfig/ios/<business>")
def getIOSConfig(business):
    return getFile("ios",business)

@app.route("/getconfig/android/<business>")
def getAndroidConfig(business):
    return getFile("android",business)


@app.route("/setconfig/web/<business>",methods = ["POST"])
@access_controll_allow_all
def setWebConfig(business):
    ver = request.form['version']
    author = request.form['author']
    updateTime = strftime("%Y-%m-%d %H:%M:%S")

@app.route("/")
def showIndex():
    return render_template("index.html")
if __name__ == "__main__":
    app.debug =True
    app.run()
