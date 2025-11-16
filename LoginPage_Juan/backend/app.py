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
        return json.load(f)

def save_users(users):
    with open(FILE, "w") as f:
        json.dump(users, f, indent=4)

# creating a new account if not exists
@app.route("/signup", methods=["POST"])
def signup():
    email = request.json["email"]
    password = request.json["password"]

    users = load_users()

    if email in users:
        return jsonify({"message": "Email already exists."})

    users[email] = password
    save_users(users)
    return jsonify({"message": "Account created successfully!"})

# loging in
@app.route("/login", methods=["POST"])
def login():
    email = request.json["email"]
    password = request.json["password"]

    users = load_users()

    if email not in users:
        return jsonify({"message": "Email not found."})

    if users[email] != password:
        return jsonify({"message": "Incorrect password."})

    return jsonify({"message": "Login successful!"})

# checking if the email exists
@app.route("/check-email", methods=["POST"])
def check_email():
    email = request.json["email"]
    users = load_users()
    return jsonify({"exists": email in users})

# To rest password
@app.route("/reset", methods=["POST"])
def reset():
    email = request.json["email"]
    new_password = request.json["new_password"]

    users = load_users()
    if email not in users:
        return jsonify({"message": "Email not found."})

    users[email] = new_password
    save_users(users)
    return jsonify({"message": "Password updated!"})

app.run(debug=True)


