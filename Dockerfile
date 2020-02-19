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
RUN yarn build:ssr

# Serve with Nginx
FROM node:alpine
WORKDIR /app
COPY --from=builder /app/dist/ng-labkit .
EXPOSE 4000
CMD ["node", "server/main.js"]