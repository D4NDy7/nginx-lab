import os, time, socket
from flask import Flask, jsonify, request

app = Flask(__name__)

VERSION = os.environ.get("SERVICE_VERSION", "unknown")
COLOR   = os.environ.get("SERVICE_COLOR",   "grey")
HOST    = socket.gethostname()

@app.route("/api/info")
@app.route("/api/v1/info")
@app.route("/api/v2/info")
@app.route("/api/lb/info")
@app.route("/api/fair/info")
@app.route("/api/sticky/info")
@app.route("/api/cached/info")
def info():
    return jsonify({"version": VERSION, "color": COLOR, "host": HOST, "time": time.time()})

@app.route("/api/health")
@app.route("/api/v1/health")
@app.route("/api/v2/health")
def health():
    return jsonify({"status": "ok", "version": VERSION})

@app.route("/api/echo", methods=["GET", "POST"])
@app.route("/api/v1/echo", methods=["GET", "POST"])
@app.route("/api/v2/echo", methods=["GET", "POST"])
@app.route("/api/lb/echo", methods=["GET", "POST"])
@app.route("/api/cached/echo", methods=["GET", "POST"])
def echo():
    return jsonify({
        "method":  request.method,
        "headers": dict(request.headers),
        "body":    request.get_json(silent=True)
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

