# Traceback

> A TRACEBACK is a file containing a series of steps to recreate a project from scratch

1. [Generate the project with Angular CLI](#generate-the-project-with-angular-cli)
2. [Code formatting](./stories/code-formatting.md)
3. [Continuous Integration](./stories/continuous-integration.md)
4. [Code Coverage](./stories/code-coverage.md)

## Generate the project with Angular CLI

Run the following script to generate the project with routing and SASS support, and Ivy Renderer enabled.

```sh
ng new ng-labkit --routing=true --style=scss --enableIvy=true
```

> **WARNING** Ivy is not supported by Angular Universal; don't enable it if you want an SSR app.