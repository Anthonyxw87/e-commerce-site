import os
import logging
from flask import Flask

app = Flask(__name__)
logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)


@app.route("/")
def home():
    logger.info("Backend route is running")
    return "Backend route is running"


if __name__ == "__main__":
    # ENV=dev -> port 5002, ENV=prd -> port 5001
    env = os.getenv("ENV", "dev")
    port = 5002 if env == "dev" else 5001

    logger.info(f"Starting backend service in '{env}' mode on port {port}...")
    try:
        app.run(host="0.0.0.0", port=port)
        logger.info("Backend service started successfully")
    except Exception as e:
        logger.error(f"Error starting backend service: {str(e)}")
