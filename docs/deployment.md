# Deployment

Run `yarn build` to generate a production build. Multiple build artifacts will be created in the `dist/ng-labkit/` directory.

> Angular 8 introduced *Differential Loading* enabling the browser to choose between modern (es2015) or legacy JavaScript (es5) bundle based on its own capabilities. That's why, Angular now generates two bundles.

## Nginx Configuration

The production build can be served through any static file server. To serve using Nginx, create a file `default.conf` and add the following configuration.

```conf
server {
  listen 4200;

  sendfile on;

  default_type application/octet-stream;

  gzip on;
  gzip_http_version 1.1;
  gzip_disable "MSIE [1-6]\.";
  gzip_min_length 256;
  gzip_vary on;
  gzip_proxied expired no-cache no-store private auth;
  gzip_types text/plain text/css application/json application/javascript application/x-javascript text/xml application/xml application/xml+rss text/javascript;
  gzip_comp_level 9;

  root /usr/share/nginx/html;

  location / {
    index index.html index.htm;
    try_files $uri $uri/ /index.html =404;
  }
}
```

## Deploy using Docker

Create a `Dockerfile` at the project's root with the following content.

```dockerfile
# Generate a build
FROM node:alpine as builder
WORKDIR /app
COPY . /app
RUN yarn
RUN yarn build

# Serve with Nginx
FROM nginx:alpine
RUN rm -rf /usr/share/nginx/html/*
COPY config/default.conf /etc/nginx/conf.d/
COPY --from=builder /app/dist/ng-labkit /usr/share/nginx/html
EXPOSE 4200
CMD ["nginx", "-g", "daemon off;"]
```

This is a multistage Dockerfile; the first stage generates the production build of the application and the second stage serves it on an Nginx server.

Create a Docker image using the following command.

```sh
docker build -t ng-labkit .
```

Then launch a container with the following command.

```sh
docker run -d -p 4200:4200 ng-labkit
```

To verify if the container is up, use `docker ps | grep ng-labkit` or launch http://localhost:4200 in your browser.
