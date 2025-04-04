# Use the official Node image
FROM node:latest

# Set working directory
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy all files
COPY . .

# Move .env.development to .env
RUN cp .env.development .env

# Build the app
CMD ["npm", "start"]

