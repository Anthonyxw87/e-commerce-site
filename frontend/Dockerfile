# Use the official Node image
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

ENV REACT_APP_API_URL=http://localhost:5002
ENV REACT_APP_ENV=dev

ARG REACT_APP_AUTH0_DOMAIN
ARG REACT_APP_AUTH0_CLIENT_ID
ARG REACT_APP_API_AUDIENCE

ENV REACT_APP_AUTH0_DOMAIN=$REACT_APP_AUTH0_DOMAIN
ENV REACT_APP_AUTH0_CLIENT_ID=$REACT_APP_AUTH0_CLIENT_ID
ENV REACT_APP_API_AUDIENCE=$REACT_APP_API_AUDIENCE

RUN npm run build

# Install lightweight static server
RUN npm install -g serve

# Expose default port for serve
EXPOSE 3000

# Serve the built app
CMD ["serve", "-s", "build", "-l", "3000"]