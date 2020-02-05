# Deployment

Run `yarn build:ssr` to generate an SSR build. The build artifacts will be created in the `dist` directory.

## Deploy using Docker

Create a `Dockerfile` at the project's root with the following content.

```dockerfile
# Generate production build
FROM node:alpine as builder
WORKDIR /app
COPY . .
RUN yarn
RUN yarn build:ssr

# Serve with Nginx
FROM node:alpine
WORKDIR /app
COPY --from=builder /app/dist/ .
EXPOSE 4000
CMD ["node", "server.js"]
```

This is a multistage Dockerfile; the first stage generates the production build of the application and the second stage serves it on an Nginx server.

Create a Docker image using the following command.

```sh
docker build -t ng-labkit .
```

Then launch a container with the following command.

```sh
docker run -d -p 4000:4000 ng-labkit
```

To verify if the container is up, use `docker ps | grep ng-labkit` or launch http://localhost:4000 in your browser.
