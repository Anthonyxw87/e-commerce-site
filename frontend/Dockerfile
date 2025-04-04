# Use the official Node image
FROM node:latest

# Set working directory
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy all files
COPY . .

ENV REACT_APP_API_URL=http://localhost:5002
ENV REACT_APP_ENV=dev

# Build the app
CMD ["npm", "start"]

