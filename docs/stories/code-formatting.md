# Code Formatting

ng-labkit uses [Prettier](https://prettier.io/) to format code. [stylelint](https://stylelint.io/) extends the recommended configuration of `prettier` for SASS, however [tslint](https://github.com/palantir/tslint) has not been configured to do so for a variety of reasons.

## Configure stylelint with Prettier

Execute the following command to add `stylelint`.

```sh
yarn add -D stylelint
```

Create `.stylelintignore` and `.stylelintrc` files in the root of Angular project. The former can be used to ignore stylesheets in specified files and directories, while the latter is used to configure the behavior of stylelint.

Add the following plugins for prettier.

```sh
yarn add -D stylelint-config-prettier stylelint-prettier
```

Then add the following in `.stylelintrc`.

```json
{
  "extends": [
    "stylelint-prettier/recommended"
  ]
}
```

### Modify the script for linting

Modify the lint script in `package.json` as follows.

```json
"lint": "npm-run-all lint:*",
"lint:scripts": "ng lint",
"lint:styles": "stylelint \"src/**/*.scss\" --cache --cache-location .cache/.stylelintcache",
```

`lint:styles` will search for SASS files in `src` directory for linting and store a cache of results at `.cache/.stylelintcache`. Make sure that `.cache/` is in your `.gitignore`.

> `npm-run-all` is a CLI tool to run multiple npm-scripts in parallel or sequence. Read more about it [here](https://github.com/mysticatea/npm-run-all).
