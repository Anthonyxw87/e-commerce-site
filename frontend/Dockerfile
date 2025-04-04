# Use the official Node image
FROM node:latest

# Set working directory
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy all files
COPY . .

# Copy env file (for local dev)
ARG ENV_FILE=.env.development
COPY ${ENV_FILE} .env

# Build the app
CMD ["npm", "start"]

