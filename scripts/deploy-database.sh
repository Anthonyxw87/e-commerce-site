#!/bin/bash

ENV="dev"  # Only dev environment is supported

# === CONFIG ===
IMAGE_TAG="dev"
LOG_FILE="/Users/anthonywang64/Documents/Coding_projects/e-commerce-site/logs/deploy-database-dev.log"
CONTAINER_NAME="e-commerce-db-dev"
IMAGE_NAME="anthonyxw87/e-commerce-database:$IMAGE_TAG"
PORT="5432"
VOLUME_NAME="e-commerce-dev-data"

# === LOAD SECRETS ===
ENV_FILE="/Users/anthonywang64/Documents/Coding_projects/e-commerce-site/scripts/.env"
if [ -f "$ENV_FILE" ]; then
  source "$ENV_FILE"
else
  echo "[$(date)] ❌ .env file not found. Aborting." >> "$LOG_FILE" 2>&1
  exit 1
fi

# === DEPLOY LOGIC ===
echo "[$(date)] Checking for new database image for environment: $ENV" >> "$LOG_FILE"

docker pull "$IMAGE_NAME" >> "$LOG_FILE" 2>&1

# Check if container exists
if docker ps -a --format '{{.Names}}' | grep -q "^$CONTAINER_NAME$"; then
  CONTAINER_EXISTS=true
else
  CONTAINER_EXISTS=false
fi

# Check if new image is different from the currently running one
CURRENT_IMAGE_ID=$(docker inspect --format='{{.Id}}' "$IMAGE_NAME" 2>/dev/null)
RUNNING_IMAGE_ID=$(docker inspect --format='{{.Image}}' "$CONTAINER_NAME" 2>/dev/null)

if [ "$CONTAINER_EXISTS" = false ] || [ "$CURRENT_IMAGE_ID" != "$RUNNING_IMAGE_ID" ]; then
  echo "[$(date)] New image detected or container does not exist. Restarting $CONTAINER_NAME..." >> "$LOG_FILE"

  if [ "$CONTAINER_EXISTS" = true ]; then
    docker stop "$CONTAINER_NAME" >> "$LOG_FILE" 2>&1
    docker rm "$CONTAINER_NAME" >> "$LOG_FILE" 2>&1

    # Remove old image used by container (if different from current)
    if [ "$RUNNING_IMAGE_ID" != "" ] && [ "$CURRENT_IMAGE_ID" != "$RUNNING_IMAGE_ID" ]; then
      docker rmi "$RUNNING_IMAGE_ID" >> "$LOG_FILE" 2>&1
      echo "[$(date)] Old image removed: $RUNNING_IMAGE_ID" >> "$LOG_FILE"
    fi
  fi

  # Create volume if it doesn't exist
  if ! docker volume ls --format '{{.Name}}' | grep -q "^$VOLUME_NAME$"; then
    echo "[$(date)] Creating volume: $VOLUME_NAME" >> "$LOG_FILE"
    docker volume create "$VOLUME_NAME" >> "$LOG_FILE" 2>&1
  fi

  docker run -d \
    --name "$CONTAINER_NAME" \
    -p "$PORT:5432" \
    -e POSTGRES_USER="$POSTGRES_USER" \
    -e POSTGRES_PASSWORD="$POSTGRES_PASSWORD" \
    -e POSTGRES_DB="$POSTGRES_DB" \
    -v "$VOLUME_NAME":/var/lib/postgresql/data \
    "$IMAGE_NAME" >> "$LOG_FILE" 2>&1

  echo "[$(date)] ✅ Database container $CONTAINER_NAME started on port $PORT" >> "$LOG_FILE"
else
  echo "[$(date)] Image is up to date. No changes." >> "$LOG_FILE"
fi
