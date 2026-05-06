import os, time, socket, random
from flask import Flask, jsonify, request

app = Flask(__name__)
HOST = socket.gethostname()

@app.route("/api/info")
@app.route("/api/fair/info")
def info():
    delay = random.uniform(0.5, 3.0)
    time.sleep(delay)
    return jsonify({"version": "slow", "color": "red", "host": HOST,
                    "time": time.time(), "delay": round(delay, 2)})

@app.route("/api/health")
def health():
    return jsonify({"status": "ok", "version": "slow"})

@app.route("/api/echo", methods=["GET", "POST"])
def echo():
    return jsonify({"method": request.method, "headers": dict(request.headers)})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
