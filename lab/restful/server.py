import os.path
import simplejson
from time import strftime
from flask import Flask
from flask import request
from flask import render_template

app = Flask(__name__)

CONFIG = {
    "configPath":"./config/"
}

def getFile(fileName):
    fName = CONFIG["configPath"] + fileName + ".conf"
    if os.path.isfile(fName):
        fileRef = open(fName,'r')
        content = fileRef.read()
        jsonObj = simplejson.loads(content)
        return str(jsonObj["version"])
    else:
        return "no " + fileName  + " config"

def writeFile(fileName):
    pass

@app.route("/config/<business>")
def getConfig(business):
    return getFile(business)

@app.route("/setting/<business>",methods = ["POST"])
def setConfig(business):
    ver = request.form['version']
    author = request.form['author']
    updateTime = strftime("%Y-%m-%d %H:%M:%S")
    writeFile(business)

@app.route("/")
def showIndex():
    return render_template("index.html")
if __name__ == "__main__":
    app.debug =True
    app.run()
