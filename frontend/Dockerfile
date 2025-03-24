# Use the official Node image
FROM node:latest

# Set working directory
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy all files
COPY . .

# Expose the port the app will run on 
EXPOSE 3000

# Build the app
CMD ["npm", "start"]

