# app.py
from flask import Flask 
from flask_autoindex import AutoIndex

app = Flask(__name__)

ppath = "/root" # update your own parent directory here

app = Flask(__name__)
AutoIndex(app, browse_root=ppath)    

if __name__ == "__main__":
    app.run(host='192.168.56.214',port=4000,debug=True)
