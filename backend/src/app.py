import os
import logging
import os
import logging
from flask import Flask
from flask_cors import CORS
from src.routes.user_routes import user_bp

# Initialize logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

ENV = os.getenv("ENV", "dev")
BACKEND_API = os.getenv("BACKEND_API", "http://localhost:3000")

if ENV == "dev":
    cors_origins = ["http://localhost:3000"]
else:
    cors_origins = [BACKEND_API]

app = Flask(__name__)

CORS(app, origins=cors_origins)

app.register_blueprint(user_bp, url_prefix="/api")

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
