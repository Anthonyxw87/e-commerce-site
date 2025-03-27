#!/bin/bash

ENV="dev"  # Only dev environment is supported

# === CONFIG ===
IMAGE_TAG="dev"
LOG_FILE="/Users/anthonywang64/Documents/Coding_projects/e-commerce-site/logs/deploy-frontend-dev.log"
CONTAINER_NAME="e-commerce-frontend-dev"
IMAGE_NAME="anthonyxw87/e-commerce-frontend:$IMAGE_TAG"

# === DEPLOY LOGIC ===
echo "[$(date)] Checking for new frontend image for environment: $ENV" >> "$LOG_FILE"

docker pull "$IMAGE_NAME" >> "$LOG_FILE" 2>&1

# Check if container exists
if docker ps -a --format '{{.Names}}' | grep -q "^$CONTAINER_NAME$"; then
  CONTAINER_EXISTS=true
else
  CONTAINER_EXISTS=false
fi

# Check if new image is different from the currently running one
if [ "$CONTAINER_EXISTS" = false ] || [ "$(docker inspect --format='{{.Id}}' $IMAGE_NAME)" != "$(docker inspect --format='{{.Image}}' $CONTAINER_NAME 2>/dev/null)" ]; then
  echo "[$(date)] New image detected or container does not exist. Restarting $CONTAINER_NAME..." >> "$LOG_FILE"

  if [ "$CONTAINER_EXISTS" = true ]; then
    docker stop "$CONTAINER_NAME" >> "$LOG_FILE" 2>&1
    docker rm "$CONTAINER_NAME" >> "$LOG_FILE" 2>&1
  fi

  docker run -d --name "$CONTAINER_NAME" -p 3000:3000 "$IMAGE_NAME" >> "$LOG_FILE" 2>&1
else
  echo "[$(date)] Image is up to date. No changes." >> "$LOG_FILE"
fi
