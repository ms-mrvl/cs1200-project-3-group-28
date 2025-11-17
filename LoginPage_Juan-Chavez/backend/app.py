from flask import Flask, request, jsonify
from flask_cors import CORS
import json, os

app = Flask(__name__)
CORS(app)

FILE = "users.json"

def load_users():
    if not os.path.exists(FILE):
        return {}
    with open(FILE, "r") as f:
        try:
            return json.load(f)
        except:
            return {}

def save_users(users):
    with open(FILE, "w") as f:
        json.dump(users, f, indent=4)


# signup
@app.route("/signup", methods=["POST"])
def signup():
    store = request.json
    email = store.get("email")
    pw = store.get("password")

    users = load_users()

    if email in users:
        return jsonify({"message":"Email already exists."})

    users[email] = pw
    save_users(users)
    return jsonify({"message":"Account created successfully!"})


# login
@app.route("/login", methods=["POST"])
def login():
    store = request.json
    email = store.get("email")
    pw = store.get("password")

    users = load_users()

    if email not in users:
        return jsonify({"message":"Email not found."})

    if users[email] != pw:
        return jsonify({"message":"Incorrect password."})

    return jsonify({"message":"Login successful!"})


# checking if the email exists
@app.route("/check-email", methods=["POST"])
def check_email():
    email = request.json.get("email")
    users = load_users()
    return jsonify({"exists": email in users})


# reset password
@app.route("/reset", methods=["POST"])
def reset():
    store = request.json
    email = store.get("email")
    new_pw = store.get("new_password")

    users = load_users()

    if email not in users:
        return jsonify({"message":"Email not found."})

    users[email] = new_pw
    save_users(users)
    return jsonify({"message":"Password updated!"})
app.run(debug=True)