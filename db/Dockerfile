# Use the official PostgreSQL base image
FROM postgres:latest

# Copy seed SQL files into the init directory
COPY seed/ /docker-entrypoint-initdb.d/
