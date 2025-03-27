#!/bin/bash

ENV="${ENV:-dev}"  # default to dev if ENV is not set

# === CONFIG ===
if [ "$ENV" == "dev" ]; then
  IMAGE_TAG="dev"
  LOG_FILE="/Users/anthonywang64/Documents/Coding_projects/e-commerce-site/logs/deploy-backend-dev.log"
  CONTAINER_NAME="e-commerce-backend-dev"
else
  IMAGE_TAG="latest"  # or "prd"
  LOG_FILE="/Users/anthonywang64/Documents/Coding_projects/e-commerce-site/logs/deploy-backend-prd.log"
  CONTAINER_NAME="e-commerce-backend-prd"
fi

IMAGE_NAME="anthonyxw87/e-commerce-backend:$IMAGE_TAG"

# === DEPLOY LOGIC ===
echo "[$(date)] Checking for new image for environment: $ENV" >> "$LOG_FILE"

docker pull "$IMAGE_NAME" >> "$LOG_FILE" 2>&1

if [ "$(docker inspect --format='{{.Id}}' $IMAGE_NAME)" != "$(docker inspect --format='{{.Image}}' $CONTAINER_NAME 2>/dev/null)" ]; then
  echo "[$(date)] New image detected. Restarting $CONTAINER_NAME..." >> "$LOG_FILE"
  docker stop "$CONTAINER_NAME" >> "$LOG_FILE" 2>&1
  docker rm "$CONTAINER_NAME" >> "$LOG_FILE" 2>&1
  docker run -d --name "$CONTAINER_NAME" "$IMAGE_NAME" >> "$LOG_FILE" 2>&1
else
  echo "[$(date)] Image is up to date. No changes." >> "$LOG_FILE"
fi
