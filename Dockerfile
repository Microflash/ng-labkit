# Prepare dependencies
FROM node:alpine as installer
WORKDIR /app
COPY . /app
RUN yarn

# Run unit tests
FROM trion/ng-cli-karma
WORKDIR /app
COPY --from=installer /app .
RUN yarn test:ci

# Run e2e tests
FROM trion/ng-cli-e2e
WORKDIR /app
COPY --from=installer /app .
RUN yarn webdriver:update
RUN yarn e2e:ci --webdriver-update=false

# Generate production build
FROM node:alpine as builder
WORKDIR /app
COPY --from=installer /app .
RUN yarn build

# Serve with Nginx
FROM nginx:alpine
RUN rm -rf /usr/share/nginx/html/*
COPY default.conf /etc/nginx/conf.d/
COPY --from=builder /app/dist/ng-labkit /usr/share/nginx/html
EXPOSE 4200
CMD ["nginx", "-g", "daemon off;"]