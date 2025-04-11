import os
import json
import logging
from flask import Flask, request, jsonify
from flask_cors import CORS
from jose import jwt
from urllib.request import urlopen

ENV = os.getenv("ENV", "dev")
AUTH0_DOMAIN = os.getenv("AUTH0_DOMAIN")
API_AUDIENCE = os.getenv("API_AUDIENCE")

app = Flask(__name__)
CORS(app)
logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)


@app.route("/")
def home():
    logger.info("Backend route is running")
    return "Backend route is running"


if __name__ == "__main__":
    # ENV=dev -> port 5002, ENV=prd -> port 5001
    port = 5002 if ENV == "dev" else 5001

    logger.info(f"Starting backend service in '{ENV}' mode on port {port}...")
    try:
        app.run(host="0.0.0.0", port=port)
        logger.info("Backend service started successfully")
    except Exception as e:
        logger.error(f"Error starting backend service: {str(e)}")
