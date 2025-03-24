import logging
from flask import Flask
# from routes import routes

app = Flask(__name__)

logger = logging.getLogger(__name__)


@app.route("/")
def home():
    logger.info("Backend route is running")
    return "Backend route is running"


if __name__ == "__main__":
    logger.info("Starting backend service...")
    try:
        app.run(host="0.0.0.0", port=5001)
        logger.info("Backend service started successfully")
    except Exception as e:
        logger.error(f"Error starting backend service: {str(e)}")
