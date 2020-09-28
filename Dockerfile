# Set base image
FROM node:alpine AS builder

# Set working directory
WORKDIR /app

# Copy package.json and install packages
COPY package.json .
RUN npm install

# Copy other project files and build
COPY . ./
RUN npm build

# Set nginx image
FROM nginx:alpine

# Nginx config
RUN rm -rf /etc/nginx/conf.d/default.conf
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf

# Static build
COPY --from=builder /app /usr/share/nginx/html

# Set working directory
WORKDIR /usr/share/nginx/html

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
#CMD ["/bin/bash", "-c", "nginx -g \"daemon off;\""]
