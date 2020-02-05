# Continuous Integration

One of the best ways to keep your project bug free is through a test suite, but it's easy to forget to run tests all the time. Continuous integration (CI) servers let you set up your project repository so that your tests run on every commit and pull request.

In this story, we'll see how to configure your project on Jenkins for testing and also update your test configuration to be able to run tests in the Chrome browser in containers.

## Configure Jenkins pipeline

Create a file `Jenkinsfile` in the project root and add the following.

```groovy
pipeline {
  agent { label 'jenkins-labkit' }
  stages {
    stage('Pull source code') {
      steps {
        git 'https://github.com/Microflash/ng-labkit.git'
      }
    }
    stage('Test and Build') {
      steps {
        sh 'docker build --no-cache -t ng-labkit .'
      }
    }
    stage('Tag the build') {
      steps {
        sh 'docker tag ng-labkit nexus/ng-labkit:latest'
      }
    }
  }
  post {
    success {
      echo "SUCCESS: Pipeline ${currentBuild.fullDisplayName} completed"
    }
    failure {
      echo "FAILURE: Pipeline ${currentBuild.fullDisplayName} broken (details at ${env.BUILD_URL})"
    }
  }
}
```

This configuration runs the tests in a Docker container. You need to create a `Dockerfile` to describe how this executes as follows.

```dockerfile
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
```

This is a multistage `Dockefile` where tests are run in different stages and finally a production build gets generated and served with Nginx. 

## Configure CLI for CI testing in Chrome

When the CLI commands `ng test` and `ng e2e` are generally running the CI tests in your environment, you might still need to adjust your configuration to run the Chrome browser tests. We'll create `test:ci` and `e2e:ci` scripts specifically for this purpose.

There are configuration files for both the [Karma JavaScript test runner](https://karma-runner.github.io/latest/config/configuration-file.html) and [Protractor](https://www.protractortest.org/#/api-overview) end-to-end testing tool, which you must adjust to start Chrome without sandboxing.

We'll be using [Headless Chrome](https://developers.google.com/web/updates/2017/04/headless-chrome#cli) in these configurations since we're not interested in launching Chrome with GUI.

In the Karma configuration file, `karma.conf.js`, add a custom launcher called `ChromeHeadlessCI` below browsers:

```javascript
browsers: ['Chrome'],
customLaunchers: {
  ChromeHeadlessCI: {
    base: 'ChromeHeadless',
    flags: ['--no-sandbox']
  }
},
```

In the root folder of your e2e tests project, create a new file named `protractor-ci.conf.js`. This new file extends the original `protractor.conf.js`.

```javascript
const config = require("./protractor.conf").config;

config.capabilities = {
  browserName: "chrome",
  chromeOptions: {
    args: ["--headless", "--no-sandbox"]
  }
};

exports.config = config;
```

Now you can run the following commands to use the `--no-sandbox` flag:

```sh
ng test --no-watch --no-progress --browsers=ChromeHeadlessCI
ng e2e --protractor-config=e2e/protractor-ci.conf.js
```

Alternatively, you can add the following configurations in `angular.json`.

```json
"ng-labkit": {
    "test": {
      "configurations": {
        "ci": {
          "watch": false,
          "progress": false,
          "browsers": "ChromeHeadlessCI"
        }
      }
    },
  }
},
"ng-labkit-e2e": {
  "architect": {
    "e2e": {
      "configurations": {
        "ci": {
          "devServerTarget": "ng-labkit:serve:production",
          "protractorConfig": "e2e/protractor-ci.conf.js"
        }
      }
    },
```

For CI environments it's also a good idea to disable progress reporting (via `--progress=false`) to avoid spamming the server log with progress messages.

> Note Right now, you'll also want to include the `--disable-gpu` flag if you're running on Windows. See <https://crbug.com/737678>.

### Locking the ChromeDriver version

In CI environments, it's a good idea to to use a specific version of [ChromeDriver](http://chromedriver.chromium.org/) instead of allowing `ng e2e` to use the latest one. CI environments often use older versions of Chrome, which are unsupported by newer versions of ChromeDriver.

To avoid this, define the following NPM script:

```json
"webdriver:update": "webdriver-manager update --standalone false --gecko false --versions.chrome 2.41",
```

And then on CI environments, call that script followed by the e2e command without updating webdriver:

```sh
npm run webdriver:update
ng e2e --webdriver-update=false
```
