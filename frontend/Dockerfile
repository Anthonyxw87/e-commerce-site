# Use the official Node image
FROM node:latest

# Set working directory
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy all files
COPY . .

# Copy env file for local dev
COPY .env.development .env

# Build the app
CMD ["npm", "start"]

