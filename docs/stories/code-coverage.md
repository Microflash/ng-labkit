# Code Coverage

Angular CLI can run unit tests and create code coverage reports. Code coverage reports show you any parts of our code base that may not be properly tested by your unit tests.

To generate a coverage report run the following command in the root of your project.

```sh
ng test --no-watch --code-coverage
```

When the tests are complete, the command creates a new `/coverage` directory in the project. Open the `index.html` file to see a report with your source code and code coverage values.

If you want to create code-coverage reports every time you test, you can set the following option in the CLI configuration file, `angular.json`:

```json
"test": {
  "options": {
    "codeCoverage": true
  }
}
```

## Enforce Code Coverage

The code coverage percentages let you estimate how much of your code is tested. If your team decides on a set minimum amount to be unit tested, you can enforce this minimum with the Angular CLI.

For example, suppose you want the code base to have a minimum of 80% code coverage. To enable this, open the [Karma](https://karma-runner.github.io/) test platform configuration file, `karma.conf.js`, and add the following under the `coverageIstanbulReporter` key.

```javascript
coverageIstanbulReporter: {
  reports: [ 'html', 'lcovonly' ],
  fixWebpackSourcePaths: true,
  thresholds: {
    statements: 80,
    lines: 80,
    branches: 80,
    functions: 80
  }
}
```

The `thresholds` key causes the tool to enforce a minimum of 80% code coverage when the unit tests are run in the project.
