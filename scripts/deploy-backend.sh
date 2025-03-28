#!/bin/bash

ENV="${ENV:-dev}"  # default to dev if ENV is not set

# === LOAD SECRETS ===
ENV_FILE="/Users/anthonywang64/Documents/Coding_projects/e-commerce-site/scripts/.env"
if [ -f "$ENV_FILE" ]; then
  source "$ENV_FILE"
else
  echo "[$(date)] ❌ .env file not found. Aborting." >&2
  exit 1
fi

# === CONFIG ===
if [ "$ENV" == "dev" ]; then
  IMAGE_TAG="dev"
  LOG_FILE="/Users/anthonywang64/Documents/Coding_projects/e-commerce-site/logs/deploy-backend-dev.log"
  CONTAINER_NAME="e-commerce-backend-dev"
  PORT="5002"
else
  IMAGE_TAG="prd"
  LOG_FILE="/Users/anthonywang64/Documents/Coding_projects/e-commerce-site/logs/deploy-backend-prd.log"
  CONTAINER_NAME="e-commerce-backend-prd"
  PORT="5001"

  # Validate Ngrok vars only in prd
  if [[ -z "$NGROK_AUTHTOKEN" || -z "$NGROK_DOMAIN" ]]; then
    echo "[$(date)] ❌ NGROK_AUTHTOKEN or NGROK_DOMAIN missing in .env. Aborting Ngrok setup." >> "$LOG_FILE"
    exit 1
  fi
fi

IMAGE_NAME="anthonyxw87/e-commerce-backend:$IMAGE_TAG"

# === DEPLOY LOGIC ===
echo "[$(date)] Checking for new image for environment: $ENV" >> "$LOG_FILE"
docker pull "$IMAGE_NAME" >> "$LOG_FILE" 2>&1

# Check if container exists
if docker ps -a --format '{{.Names}}' | grep -q "^$CONTAINER_NAME$"; then
  CONTAINER_EXISTS=true
else
  CONTAINER_EXISTS=false
fi

# Get image IDs
CURRENT_IMAGE_ID=$(docker inspect --format='{{.Id}}' "$IMAGE_NAME" 2>/dev/null)
RUNNING_IMAGE_ID=$(docker inspect --format='{{.Image}}' "$CONTAINER_NAME" 2>/dev/null)

# Restart if container doesn't exist or image has changed
if [ "$CONTAINER_EXISTS" = false ] || [ "$CURRENT_IMAGE_ID" != "$RUNNING_IMAGE_ID" ]; then
  echo "[$(date)] New image detected or container does not exist. Restarting $CONTAINER_NAME..." >> "$LOG_FILE"

  if [ "$CONTAINER_EXISTS" = true ]; then
    docker stop "$CONTAINER_NAME" >> "$LOG_FILE" 2>&1
    docker rm "$CONTAINER_NAME" >> "$LOG_FILE" 2>&1

    if [ "$RUNNING_IMAGE_ID" != "" ] && [ "$CURRENT_IMAGE_ID" != "$RUNNING_IMAGE_ID" ]; then
      docker rmi "$RUNNING_IMAGE_ID" >> "$LOG_FILE" 2>&1
      echo "[$(date)] Old image removed: $RUNNING_IMAGE_ID" >> "$LOG_FILE"
    fi
  fi

  docker run -d --name "$CONTAINER_NAME" -p "$PORT:$PORT" -e ENV="$ENV" "$IMAGE_NAME" >> "$LOG_FILE" 2>&1
  
  # === START NGROK ONLY IN PRD ===
  if [ "$ENV" == "prd" ]; then
    echo "[$(date)] Starting Ngrok tunnel for $ENV on port $PORT..." >> "$LOG_FILE"

    docker run -d --rm \
      --name "ngrok-$ENV" \
      -e NGROK_AUTHTOKEN="$NGROK_AUTHTOKEN" \
      ngrok/ngrok http host.docker.internal:$PORT \
      --url="$NGROK_DOMAIN" >> "$LOG_FILE" 2>&1

    echo "[$(date)] Ngrok tunnel started: https://$NGROK_DOMAIN -> localhost:$PORT" >> "$LOG_FILE"
  else
    echo "[$(date)] Skipping Ngrok (dev environment)." >> "$LOG_FILE"
  fi

else
  echo "[$(date)] Image is up to date. No changes." >> "$LOG_FILE"
fi
