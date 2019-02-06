from flask import Flask
from app.db import DB

app = Flask(__name__)


@app.route("/")
def hello():
    return f'Hello, ${DB.get_current_user()}'
